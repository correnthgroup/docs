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
'@ | Set-Content -LiteralPath $hookPath -Encoding ascii
Write-Output "Installed Correnth semantic push guard for $resolvedRoot"
