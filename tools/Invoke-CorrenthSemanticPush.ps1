[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectRoot,
  [string]$Remote = "origin",
  [switch]$SkipPush
)

$ErrorActionPreference = "Stop"

# Only these artifacts are published. Caches, dated backups, visualizations and
# quarantine content are reproducible or local diagnostic material.
$canonicalArtifacts = @(
  "graph.json",
  "GRAPH_REPORT.md",
  "manifest.json",
  "semantic-provenance.json",
  ".graphify_analysis.json",
  ".graphify_labels.json"
)

function Invoke-GraphifyPython {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GraphifyArguments)

  # The user-level graphify.exe shim is blocked by Windows Code Integrity.
  # uv executes the official Python module in an isolated environment instead.
  & uv run --with 'graphifyy[openai]' python -m graphify @GraphifyArguments
  if ($LASTEXITCODE -ne 0) { throw "Graphify Python module failed." }
}

function Get-ArtifactHash {
  param([Parameter(Mandatory = $true)][string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Missing canonical Graphify artifact: $Path" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}

function Get-GraphSnapshot {
  param([Parameter(Mandatory = $true)][string]$OutputDirectory)

  $graphPath = Join-Path $OutputDirectory "graph.json"
  $graph = Get-Content -Raw -LiteralPath $graphPath | ConvertFrom-Json
  $nodes = @($graph.nodes)
  $links = @($graph.links)
  if ($nodes.Count -eq 0 -or $links.Count -eq 0) { throw "Semantic graph must contain nodes and links." }

  $removedSelfLoops = @($links | Where-Object { $_.source -eq $_.target })
  if ($removedSelfLoops.Count -gt 0) {
    $graph.links = @($links | Where-Object { $_.source -ne $_.target })
    [System.IO.File]::WriteAllText($graphPath, ($graph | ConvertTo-Json -Depth 100), [System.Text.UTF8Encoding]::new($false))
    $links = @($graph.links)
  }

  $nodeIds = @{}
  foreach ($node in $nodes) {
    $nodeIds[$node.id] = $true
    if ($node.source_file -match '(^|[\\/])(graphify-out|\.graphify-quarantine|node_modules|_legacy|archived|cache)([\\/]|$)') {
      throw "Graphify indexed an excluded generated, dependency, or historical path."
    }
  }
  foreach ($link in $links) {
    if ($link.source -eq $link.target -or -not $nodeIds.ContainsKey($link.source) -or -not $nodeIds.ContainsKey($link.target)) {
      throw "Graph integrity validation failed."
    }
  }
  $semanticLinks = @($links | Where-Object {
    $_.confidence -eq "INFERRED" -or $_._origin -eq "semantic" -or $_.relation -match "semantic"
  })
  if ($semanticLinks.Count -eq 0) { throw "Graphify completed without semantic edges; semantic extraction is required." }

  return [ordered]@{
    nodeCount = $nodes.Count
    edgeCount = $links.Count
    semanticEdgeCount = $semanticLinks.Count
    removedSelfLoopCount = $removedSelfLoops.Count
  }
}

function Write-Provenance {
  param(
    [Parameter(Mandatory = $true)][string]$OutputDirectory,
    [Parameter(Mandatory = $true)][string]$SourceRevision,
    [Parameter(Mandatory = $true)][hashtable]$Snapshot
  )

  $provenancePath = Join-Path $OutputDirectory "semantic-provenance.json"
  $artifactHashes = [ordered]@{}
  foreach ($artifact in $canonicalArtifacts | Where-Object { $_ -ne "semantic-provenance.json" }) {
    $artifactHashes[$artifact] = Get-ArtifactHash (Join-Path $OutputDirectory $artifact)
  }
  [ordered]@{
    sourceRevision = $SourceRevision
    extractor = "graphify extract"
    backend = "openai-compatible"
    provider = "MiniMax"
    model = "MiniMax-M2.7-highspeed"
    mode = "deep"
    nodeCount = $Snapshot.nodeCount
    edgeCount = $Snapshot.edgeCount
    semanticEdgeCount = $Snapshot.semanticEdgeCount
    removedSelfLoopCount = $Snapshot.removedSelfLoopCount
    artifactSha256 = $artifactHashes
    generatedAt = [DateTime]::UtcNow.ToString("o")
  } | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $provenancePath -Encoding utf8
}

function Write-DeterministicCommunityLabels {
  param([Parameter(Mandatory = $true)][string]$OutputDirectory)

  $graph = Get-Content -Raw -LiteralPath (Join-Path $OutputDirectory "graph.json") | ConvertFrom-Json
  $labels = [ordered]@{}
  @($graph.nodes | ForEach-Object { [int]$_.community } | Sort-Object -Unique) |
    ForEach-Object { $labels[[string]$_] = "Community $_" }
  [System.IO.File]::WriteAllText(
    (Join-Path $OutputDirectory ".graphify_labels.json"),
    ($labels | ConvertTo-Json -Compress),
    [System.Text.UTF8Encoding]::new($false)
  )
}

function Test-CanonicalArtifacts {
  param(
    [Parameter(Mandatory = $true)][string]$OutputDirectory,
    [Parameter(Mandatory = $true)][string]$SourceRevision
  )

  foreach ($artifact in $canonicalArtifacts) {
    if (-not (Test-Path -LiteralPath (Join-Path $OutputDirectory $artifact) -PathType Leaf)) {
      throw "Graphify promotion refused: missing $artifact."
    }
  }
  $snapshot = Get-GraphSnapshot $OutputDirectory
  $provenance = Get-Content -Raw -LiteralPath (Join-Path $OutputDirectory "semantic-provenance.json") | ConvertFrom-Json
  if ($provenance.sourceRevision -ne $SourceRevision -or $provenance.model -ne "MiniMax-M2.7-highspeed" -or $provenance.mode -ne "deep") {
    throw "Graphify promotion refused: provenance does not match the source revision or configured model."
  }
  foreach ($name in @("nodeCount", "edgeCount", "semanticEdgeCount")) {
    if ([int]$provenance.$name -ne [int]$snapshot[$name]) { throw "Graphify promotion refused: provenance count $name diverges from graph.json." }
  }
  $report = Get-Content -Raw -LiteralPath (Join-Path $OutputDirectory "GRAPH_REPORT.md")
  $shortRevision = $SourceRevision.Substring(0, 8)
  $reportRevision = "Built from commit: ``" + $shortRevision + "``"
  if ($report -notmatch ("{0} nodes.*{1} edges" -f $snapshot.nodeCount, $snapshot.edgeCount) -or $report -notmatch [regex]::Escape($reportRevision)) {
    throw "Graphify promotion refused: GRAPH_REPORT.md diverges from graph.json or source revision."
  }
  foreach ($artifact in $canonicalArtifacts | Where-Object { $_ -ne "semantic-provenance.json" }) {
    $expectedHash = [string]$provenance.artifactSha256.$artifact
    if ([string]::IsNullOrWhiteSpace($expectedHash) -or $expectedHash -ne (Get-ArtifactHash (Join-Path $OutputDirectory $artifact))) {
      throw "Graphify promotion refused: $artifact diverges from the canonical provenance manifest."
    }
  }
  return $snapshot
}

$allowedRoots = @("D:\00_docs", "D:\01_studio\redrise-platform", "D:\02_labs\redrise-operation")
$projectTags = @{ "D:\00_docs" = "correnth-docs"; "D:\01_studio\redrise-platform" = "redrise-platform"; "D:\02_labs\redrise-operation" = "redrise-operation" }
$resolvedRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path.TrimEnd("\\")
if ($resolvedRoot -notin $allowedRoots) { throw "Semantic Graphify is allowed only for a registered project root." }
if (-not (Test-Path -LiteralPath (Join-Path $resolvedRoot ".git") -PathType Container)) { throw "ProjectRoot must be a Git worktree." }

Push-Location $resolvedRoot
try {
  if (@(git status --porcelain).Count -gt 0) { throw "Refusing to refresh the semantic graph in a dirty worktree. Commit or stash existing changes first." }

  # A graph-only commit must never force another graph-only commit. The source
  # revision therefore excludes all generated and quarantine paths.
  $sourceRevision = (git log -1 --format=%H -- . ':(exclude)graphify-out/**' ':(exclude).graphify-quarantine/**').Trim()
  if ([string]::IsNullOrWhiteSpace($sourceRevision)) { throw "Unable to determine the source revision for Graphify." }
  $canonicalOutput = Join-Path $resolvedRoot "graphify-out"
  $existingProvenance = Join-Path $canonicalOutput "semantic-provenance.json"
  if (Test-Path -LiteralPath $existingProvenance -PathType Leaf) {
    $existing = Get-Content -Raw -LiteralPath $existingProvenance | ConvertFrom-Json
    if ($existing.sourceRevision -eq $sourceRevision -and $existing.model -eq "MiniMax-M2.7-highspeed" -and $existing.mode -eq "deep") {
      Test-CanonicalArtifacts $canonicalOutput $sourceRevision | Out-Null
      Invoke-GraphifyPython global add (Join-Path $canonicalOutput "graph.json") --as $projectTags[$resolvedRoot]
      Write-Output "Semantic graph already matches the current source revision."
      if (-not $SkipPush) { $env:CORRENTH_SEMANTIC_PUSH = "1"; git push $Remote HEAD; if ($LASTEXITCODE -ne 0) { throw "Push failed after semantic graph validation." } }
      return
    }
  }

  $vaultKeyPath = "C:\Users\raulv\OneDrive\Cofre Pessoal\Correnth\Minimax.txt"
  if (-not (Test-Path -LiteralPath $vaultKeyPath -PathType Leaf)) { throw "MiniMax key is unavailable in the Personal Vault." }
  $miniMaxKey = [System.IO.File]::ReadAllText($vaultKeyPath).Trim()
  if ($miniMaxKey -match '^[^:\r\n]+:\s*(\S+)$') { $miniMaxKey = $Matches[1] }
  if ([string]::IsNullOrWhiteSpace($miniMaxKey) -or $miniMaxKey -match '\s') { throw "MiniMax key file must contain one credential value." }

  $runDirectory = Join-Path $resolvedRoot (".graphify-quarantine\\extract-" + [Guid]::NewGuid().ToString("N"))
  $stagingOutput = Join-Path $runDirectory "graphify-out"
  New-Item -ItemType Directory -Path $runDirectory | Out-Null
  # Keep the extraction transaction isolated, but reuse an ignored local cache
  # from the latest completed quarantine run. Graphify validates cache keys
  # against source content; changed files are still dispatched to MiniMax.
  $previousCache = Get-ChildItem -LiteralPath (Join-Path $resolvedRoot ".graphify-quarantine") -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -ne $runDirectory -and (Test-Path -LiteralPath (Join-Path $_.FullName "graphify-out\\cache") -PathType Container) } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
  if ($null -ne $previousCache) {
    New-Item -ItemType Directory -Path $stagingOutput | Out-Null
    Copy-Item -LiteralPath (Join-Path $previousCache.FullName "graphify-out\\cache") -Destination (Join-Path $stagingOutput "cache") -Recurse
  }
  $previousBaseUrl, $previousApiKey = $env:OPENAI_BASE_URL, $env:OPENAI_API_KEY
  try {
    $env:OPENAI_BASE_URL = "https://api.minimax.io/v1"
    $env:OPENAI_API_KEY = $miniMaxKey
    Invoke-GraphifyPython extract $resolvedRoot --backend=openai --model=MiniMax-M2.7-highspeed --mode=deep --out $runDirectory --max-concurrency=2 --api-timeout=120
    # Community labels are presentation metadata, not semantic evidence.
    # MiniMax may emit non-JSON reasoning during labeling and cluster-only has
    # no request-timeout option, so keep deterministic placeholders here.
    Invoke-GraphifyPython cluster-only $runDirectory --graph (Join-Path $stagingOutput "graph.json") --no-viz --no-label
    Write-DeterministicCommunityLabels $stagingOutput
  } finally {
    if ($null -eq $previousBaseUrl) { Remove-Item Env:OPENAI_BASE_URL -ErrorAction SilentlyContinue } else { $env:OPENAI_BASE_URL = $previousBaseUrl }
    if ($null -eq $previousApiKey) { Remove-Item Env:OPENAI_API_KEY -ErrorAction SilentlyContinue } else { $env:OPENAI_API_KEY = $previousApiKey }
  }

  $stagedSnapshot = Get-GraphSnapshot $stagingOutput
  Write-Provenance $stagingOutput $sourceRevision $stagedSnapshot
  Test-CanonicalArtifacts $stagingOutput $sourceRevision | Out-Null

  $previousOutput = Join-Path $runDirectory "previous-canonical"
  $promoted = $false
  try {
    if (Test-Path -LiteralPath $canonicalOutput) { Move-Item -LiteralPath $canonicalOutput -Destination $previousOutput }
    New-Item -ItemType Directory -Path $canonicalOutput | Out-Null
    foreach ($artifact in $canonicalArtifacts) { Copy-Item -LiteralPath (Join-Path $stagingOutput $artifact) -Destination (Join-Path $canonicalOutput $artifact) }
    Test-CanonicalArtifacts $canonicalOutput $sourceRevision | Out-Null
    $promoted = $true
  } finally {
    if (-not $promoted -and (Test-Path -LiteralPath $previousOutput)) {
      Remove-Item -LiteralPath $canonicalOutput -Recurse -Force -ErrorAction SilentlyContinue
      Move-Item -LiteralPath $previousOutput -Destination $canonicalOutput
    }
  }

  Invoke-GraphifyPython global add (Join-Path $canonicalOutput "graph.json") --as $projectTags[$resolvedRoot]
  $changedGraphFiles = @(git status --porcelain -- graphify-out)
  if ($changedGraphFiles.Count -gt 0) {
    git add -- graphify-out
    git commit -m "chore(graphify): refresh semantic index for $sourceRevision"
    if ($LASTEXITCODE -ne 0) { throw "Unable to commit the semantic graph refresh." }
  }
  if (-not $SkipPush) { $env:CORRENTH_SEMANTIC_PUSH = "1"; git push $Remote HEAD; if ($LASTEXITCODE -ne 0) { throw "Push failed after semantic graph validation." } }
} finally {
  Remove-Variable miniMaxKey -ErrorAction SilentlyContinue
  Pop-Location
}
