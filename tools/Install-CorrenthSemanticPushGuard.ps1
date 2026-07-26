[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectRoot
)

$ErrorActionPreference = "Stop"
$allowedRoots = @(
  "D:\00_docs",
  "D:\01_studio\redrise-platform",
  "D:\02_labs\redrise-operation"
)
$resolvedRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path.TrimEnd("\\")
if ($resolvedRoot -notin $allowedRoots) {
  throw "Push guard is allowed only for a registered project root."
}

$hookPath = Join-Path $resolvedRoot ".git\hooks\pre-push"
@'
#!/bin/sh
if [ "$CORRENTH_SEMANTIC_PUSH" != "1" ]; then
  echo "Push blocked: run D:/00_docs/tools/Invoke-CorrenthSemanticPush.ps1 -ProjectRoot <project-root>." >&2
  exit 1
fi

# Preserve the Git LFS transport after the semantic gate. Without this call,
# a tracked graph.json pointer could be pushed while its LFS object remains
# only on the local machine.
if git check-attr filter -- graphify-out/graph.json | grep -q 'filter: lfs$'; then
  git lfs pre-push "$@"
  lfs_status=$?
  if [ "$lfs_status" -ne 0 ]; then
    echo "Push blocked: Git LFS failed to upload the canonical graph object." >&2
    exit "$lfs_status"
  fi
fi
'@ | Set-Content -LiteralPath $hookPath -Encoding ascii
Write-Output "Installed Correnth semantic push guard for $resolvedRoot"
