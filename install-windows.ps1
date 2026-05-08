$ErrorActionPreference = "Stop"

$repoDir = $PSScriptRoot
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

function Link-File {
  param(
    [Parameter(Mandatory = $true)]
    [string] $SourcePath,

    [Parameter(Mandatory = $true)]
    [string] $TargetPath
  )

  if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "源文件不存在: $SourcePath"
  }

  $targetParent = Split-Path -Parent $TargetPath
  if (-not (Test-Path -LiteralPath $targetParent)) {
    New-Item -ItemType Directory -Path $targetParent | Out-Null
  }

  $targetItem = Get-Item -LiteralPath $TargetPath -Force -ErrorAction SilentlyContinue
  if ($targetItem) {
    if ($targetItem.LinkType) {
      Remove-Item -LiteralPath $TargetPath -Force
    } else {
      $backupPath = "$TargetPath.before-dotfiles-$timestamp"
      Move-Item -LiteralPath $TargetPath -Destination $backupPath
      Write-Host "已备份: $TargetPath -> $backupPath"
    }
  }

  New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath | Out-Null
  Write-Host "已链接: $TargetPath -> $SourcePath"
}

$ohMyPoshConfig = Join-Path $HOME "sixiaolong.omp.json"

Link-File `
  -SourcePath (Join-Path $repoDir "oh-my-posh\sixiaolong.omp.json") `
  -TargetPath $ohMyPoshConfig

Write-Host "Windows 配置链接完成。"
