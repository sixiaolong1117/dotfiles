#!/bin/sh
# =============================================================================
# dotfiles 安装脚本 — macOS
# =============================================================================
# 用法: ./install-macos.sh
#
# 功能:
#   1. 配置 Zsh（.zshrc, .p10k.zsh）
#   2. 配置 WezTerm 终端模拟器
#   3. 配置 Neovim 编辑器
#   4. 配置 AeroSpace 窗口管理器
# =============================================================================

# 遇到未定义变量或命令失败时立即退出
set -eu

# =============================================================================
# 初始化
# =============================================================================

# 脚本所在目录（dotfiles 仓库根目录）
repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# 备份用的时间戳
timestamp=$(date +%Y%m%d-%H%M%S)

# =============================================================================
# 辅助函数
# =============================================================================

# 创建符号链接，若目标已存在则备份。
# 用法: link_file <源路径> <目标路径>
link_file() {
  source_path=$1
  target_path=$2

  # 检查源文件是否存在
  if [ ! -e "$source_path" ]; then
    printf '源文件不存在: %s\n' "$source_path" >&2
    exit 1
  fi

  # 如果目标已存在且不是符号链接，先备份
  if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
    backup_path="$target_path.before-dotfiles-$timestamp"
    mv "$target_path" "$backup_path"
    printf '已备份: %s -> %s\n' "$target_path" "$backup_path"
  fi

  # 创建符号链接（-f 覆盖已有链接，-n 不追溯目录链接）
  ln -sfn "$source_path" "$target_path"
  printf '已链接: %s -> %s\n' "$target_path" "$source_path"
}

# 删除旧版 AeroSpace 配置（从 ~/.aerospace.toml 迁移到 ~/.config/aerospace/）
remove_legacy_aerospace_config() {
  legacy_path="$HOME/.aerospace.toml"

  # 不存在则无需处理
  if [ ! -e "$legacy_path" ] && [ ! -L "$legacy_path" ]; then
    return
  fi

  # 是符号链接则直接删除
  if [ -L "$legacy_path" ]; then
    rm "$legacy_path"
    printf '已删除旧 AeroSpace 链接: %s\n' "$legacy_path"
    return
  fi

  # 是真实文件则备份
  backup_path="$legacy_path.before-dotfiles-$timestamp"
  mv "$legacy_path" "$backup_path"
  printf '已备份旧 AeroSpace 配置: %s -> %s\n' "$legacy_path" "$backup_path"
}

# =============================================================================
# Zsh 配置
# =============================================================================

link_file "$repo_dir/zsh/zshrc" "$HOME/.zshrc"
link_file "$repo_dir/zsh/p10k.zsh" "$HOME/.p10k.zsh"

# =============================================================================
# WezTerm 配置
# =============================================================================

link_file "$repo_dir/wezterm/wezterm.lua" "$HOME/.wezterm.lua"

# =============================================================================
# Neovim 配置
# =============================================================================

mkdir -p "$HOME/.config"
link_file "$repo_dir/nvim" "$HOME/.config/nvim"

# =============================================================================
# AeroSpace 配置
# =============================================================================

mkdir -p "$HOME/.config/aerospace"
remove_legacy_aerospace_config
link_file "$repo_dir/AeroSpace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"

printf 'macOS 配置链接完成。\n'
