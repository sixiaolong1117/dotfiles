# Merge OpenCode\opencode.jsonc from this repo into the local opencode config (Windows).
# Usage: .\OpenCode\sync-opencode.ps1 [-Test]
$ErrorActionPreference = "Stop"

$py = Get-Command python3 -ErrorAction SilentlyContinue
if (-not $py) { $py = Get-Command python -ErrorAction SilentlyContinue }
if (-not $py) { throw "python3 / python not found; install Python 3" }

$args = @()
if ($Test) { $args += "--test" }
& $py.Source (Join-Path $PSScriptRoot "sync-opencode.py") @args
exit $LASTEXITCODE
