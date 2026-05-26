# =============================================================================
# dotfiles 安装脚本 — Windows (PowerShell)
# =============================================================================
# 用法: pwsh -ExecutionPolicy Bypass -File install-windows.ps1
#
# 功能:
#   1. 将 oh-my-posh 主题配置链接到 $HOME
#   2. 如果 oh-my-posh 已安装，自动配置 PowerShell $PROFILE
#   3. 将 Windows Terminal 设置链接到 LocalState
# =============================================================================

# 遇到错误立即停止
$ErrorActionPreference = "Stop"

# =============================================================================
# 初始化
# =============================================================================

# 脚本所在目录（dotfiles 仓库根目录）
$repoDir = $PSScriptRoot

# 备份用的时间戳
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

# =============================================================================
# 辅助函数
# =============================================================================

<#
  .SYNOPSIS
    创建符号链接，若目标已存在则备份。
  .PARAMETER SourcePath
    源文件/目录的绝对路径（dotfiles 仓库内）。
  .PARAMETER TargetPath
    目标符号链接的路径。
#>
function Link-File {
  param(
    [Parameter(Mandatory = $true)]
    [string] $SourcePath,

    [Parameter(Mandatory = $true)]
    [string] $TargetPath
  )

  # 检查源文件是否存在
  if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "源文件不存在: $SourcePath"
  }

  # 确保目标父目录存在
  $targetParent = Split-Path -Parent $TargetPath
  if (-not (Test-Path -LiteralPath $targetParent)) {
    New-Item -ItemType Directory -Path $targetParent | Out-Null
  }

  # 处理目标已存在的情况
  $targetItem = Get-Item -LiteralPath $TargetPath -Force -ErrorAction SilentlyContinue
  if ($targetItem) {
    if ($targetItem.LinkType) {
      # 已存在的符号链接，直接删除
      Remove-Item -LiteralPath $TargetPath -Force
    } else {
      # 真实文件，备份
      $backupPath = "$TargetPath.before-dotfiles-$timestamp"
      Move-Item -LiteralPath $TargetPath -Destination $backupPath
      Write-Host "已备份: $TargetPath -> $backupPath"
    }
  }

  # 创建符号链接
  New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath | Out-Null
  Write-Host "已链接: $TargetPath -> $SourcePath"
}

# =============================================================================
# oh-my-posh 主题配置
# =============================================================================

# 将 oh-my-posh 主题文件链接到 $HOME
$ohMyPoshConfig = Join-Path $HOME "sixiaolong.omp.json"
Link-File `
  -SourcePath (Join-Path $repoDir "oh-my-posh\sixiaolong.omp.json") `
  -TargetPath $ohMyPoshConfig

# =============================================================================
# PowerShell Profile 配置
# =============================================================================
# 如果 oh-my-posh 已安装，自动在 $PROFILE 中添加初始化命令
# 参考: https://ohmyposh.dev/docs/installation/prompt

$ohMyPoshInstalled = Get-Command oh-my-posh -ErrorAction SilentlyContinue
if (-not $ohMyPoshInstalled) {
  Write-Host "oh-my-posh 未安装，跳过 Profile 配置。"
} else {
  # ---- 执行策略 ----
  # 确保 PowerShell 允许运行本地未签名的脚本
  $currentPolicy = Get-ExecutionPolicy -Scope LocalMachine
  if ($currentPolicy -eq 'Restricted' -or $currentPolicy -eq 'AllSigned') {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
    Write-Host "已设置执行策略为 RemoteSigned"
  }

  # ---- 创建 Profile ----
  # 确保 $PROFILE 的父目录和文件本身存在
  $profileDir = Split-Path -Parent $PROFILE
  if (-not (Test-Path -LiteralPath $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir | Out-Null
    Write-Host "已创建 Profile 目录: $profileDir"
  }
  if (-not (Test-Path -LiteralPath $PROFILE)) {
    New-Item -Path $PROFILE -Type File -Force | Out-Null
    Write-Host "已创建 PowerShell Profile: $PROFILE"
  }

  # ---- 写入初始化命令 ----
  # 仅当 $PROFILE 中还没有时才追加，避免重复
  $ohMyPoshInitLine = 'oh-my-posh init pwsh --config ~/sixiaolong.omp.json | Invoke-Expression'

  $profileContent = Get-Content -LiteralPath $PROFILE -Raw -ErrorAction SilentlyContinue
  if (-not $profileContent) { $profileContent = "" }

  if ($profileContent.Contains($ohMyPoshInitLine)) {
    Write-Host "PowerShell Profile 已包含 oh-my-posh 配置，跳过。"
  } else {
    $profileContent = "$profileContent`n# oh-my-posh`n$ohMyPoshInitLine`n"
    Set-Content -LiteralPath $PROFILE -Value $profileContent -NoNewline
    Write-Host "已配置 PowerShell Profile: $PROFILE"
    Write-Host "请执行 '. $PROFILE' 或重启终端以生效。"
  }
}

# =============================================================================
# Windows Terminal 配置
# =============================================================================

# Windows Terminal 的设置文件位于 LocalState 下，需以管理员权限创建符号链接
$wtLocalState = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$wtSettings = Join-Path $wtLocalState "settings.json"
Link-File `
  -SourcePath (Join-Path $repoDir "WindowsTerminal\settings.json") `
  -TargetPath $wtSettings

Write-Host "Windows 配置链接完成。"
