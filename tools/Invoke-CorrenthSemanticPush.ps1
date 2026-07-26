[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectRoot,
  [string]$Remote = "origin",
  [switch]$SkipPush
)

$ErrorActionPreference = "Stop"

$allowedRoots = @(
  "D:\00_docs",
  "D:\01_studio\redrise-platform",
  "D:\02_labs\redrise-operation"
)
$projectTags = @{
  "D:\00_docs" = "correnth-docs"
  "D:\01_studio\redrise-platform" = "redrise-platform"
  "D:\02_labs\redrise-operation" = "redrise-operation"
}
$resolvedRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path.TrimEnd("\\")
if ($resolvedRoot -notin $allowedRoots) {
  throw "Semantic Graphify is allowed only for a registered project root."
}
if (-not (Test-Path -LiteralPath (Join-Path $resolvedRoot ".git") -PathType Container)) {
  throw "ProjectRoot must be a Git worktree."
}

Push-Location $resolvedRoot
try {
  $initialStatus = @(git status --porcelain)
  if ($initialStatus.Count -gt 0) {
    throw "Refusing to refresh the semantic graph in a dirty worktree. Commit or stash existing changes first."
  }

  $vaultKeyPath = "C:\Users\raulv\OneDrive\Cofre Pessoal\Correnth\Minimax.txt"
  if (-not (Test-Path -LiteralPath $vaultKeyPath -PathType Leaf)) {
    throw "MiniMax key is unavailable in the Personal Vault."
  }
  $miniMaxKey = [System.IO.File]::ReadAllText($vaultKeyPath).Trim()
  if ([string]::IsNullOrWhiteSpace($miniMaxKey)) {
    throw "MiniMax key file is empty."
  }

  $sourceRevision = (git rev-parse HEAD).Trim()
  $previousBaseUrl = $env:OPENAI_BASE_URL
  $previousApiKey = $env:OPENAI_API_KEY
  try {
    $env:OPENAI_BASE_URL = "https://api.minimax.io/v1"
    $env:OPENAI_API_KEY = $miniMaxKey
    & graphify extract $resolvedRoot --backend=openai --model=MiniMax-M2.7-highspeed --mode=deep --out $resolvedRoot --max-concurrency=2
    if ($LASTEXITCODE -ne 0) {
      throw "Graphify semantic extraction failed."
    }
  } finally {
    if ($null -eq $previousBaseUrl) {
      Remove-Item Env:OPENAI_BASE_URL -ErrorAction SilentlyContinue
    } else {
      $env:OPENAI_BASE_URL = $previousBaseUrl
    }
    if ($null -eq $previousApiKey) {
      Remove-Item Env:OPENAI_API_KEY -ErrorAction SilentlyContinue
    } else {
      $env:OPENAI_API_KEY = $previousApiKey
    }
  }

  $graphPath = Join-Path $resolvedRoot "graphify-out\graph.json"
  if (-not (Test-Path -LiteralPath $graphPath -PathType Leaf)) {
    throw "Graphify did not produce graphify-out\\graph.json."
  }
  $graph = Get-Content -Raw -LiteralPath $graphPath | ConvertFrom-Json
  $nodes = @($graph.nodes)
  $links = @($graph.links)
  if ($nodes.Count -eq 0 -or $links.Count -eq 0) {
    throw "Semantic graph must contain nodes and links."
  }
  $nodeIds = @{}
  foreach ($node in $nodes) {
    $nodeIds[$node.id] = $true
    if ($node.source_file -match '(^|[\\/])(graphify-out|\.graphify-quarantine|node_modules|_legacy|archived)([\\/]|$)') {
      throw "Graphify indexed an excluded generated or historical path."
    }
  }
  foreach ($link in $links) {
    if ($link.source -eq $link.target -or -not $nodeIds.ContainsKey($link.source) -or -not $nodeIds.ContainsKey($link.target)) {
      throw "Graph integrity validation failed."
    }
  }
  $semanticLinks = @($links | Where-Object {
    $_.confidence -eq "INFERRED" -or
    $_._origin -eq "semantic" -or
    $_.relation -match "semantic"
  })
  if ($semanticLinks.Count -eq 0) {
    throw "Graphify completed without semantic edges; semantic extraction is required."
  }

  $provenancePath = Join-Path $resolvedRoot "graphify-out\semantic-provenance.json"
  [ordered]@{
    sourceRevision = $sourceRevision
    extractor = "graphify extract"
    backend = "openai-compatible"
    provider = "MiniMax"
    model = "MiniMax-M2.7-highspeed"
    mode = "deep"
    semanticEdgeCount = $semanticLinks.Count
    generatedAt = [DateTime]::UtcNow.ToString("o")
  } | ConvertTo-Json | Set-Content -LiteralPath $provenancePath -Encoding utf8

  & graphify global add $graphPath --as $projectTags[$resolvedRoot]
  if ($LASTEXITCODE -ne 0) {
    throw "Unable to update the local Graphify global index."
  }

  $changedGraphFiles = @(git status --porcelain -- graphify-out)
  if ($changedGraphFiles.Count -eq 0) {
    Write-Output "Semantic graph already matches the current source revision."
  } else {
    git add -- graphify-out
    git commit -m "chore(graphify): refresh semantic index for $sourceRevision"
    if ($LASTEXITCODE -ne 0) { throw "Unable to commit the semantic graph refresh." }
  }

  if (-not $SkipPush) {
    $env:CORRENTH_SEMANTIC_PUSH = "1"
    git push $Remote HEAD
    if ($LASTEXITCODE -ne 0) { throw "Push failed after semantic graph validation." }
  }
} finally {
  Remove-Variable miniMaxKey -ErrorAction SilentlyContinue
  Pop-Location
}
