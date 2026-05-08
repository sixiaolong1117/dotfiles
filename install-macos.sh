#!/bin/sh

set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
timestamp=$(date +%Y%m%d-%H%M%S)

link_file() {
  source_path=$1
  target_path=$2

  if [ ! -e "$source_path" ]; then
    printf '源文件不存在: %s\n' "$source_path" >&2
    exit 1
  fi

  if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
    backup_path="$target_path.before-dotfiles-$timestamp"
    mv "$target_path" "$backup_path"
    printf '已备份: %s -> %s\n' "$target_path" "$backup_path"
  fi

  ln -sfn "$source_path" "$target_path"
  printf '已链接: %s -> %s\n' "$target_path" "$source_path"
}

remove_legacy_aerospace_config() {
  legacy_path="$HOME/.aerospace.toml"

  if [ ! -e "$legacy_path" ] && [ ! -L "$legacy_path" ]; then
    return
  fi

  if [ -L "$legacy_path" ]; then
    rm "$legacy_path"
    printf '已删除旧 AeroSpace 链接: %s\n' "$legacy_path"
    return
  fi

  backup_path="$legacy_path.before-dotfiles-$timestamp"
  mv "$legacy_path" "$backup_path"
  printf '已备份旧 AeroSpace 配置: %s -> %s\n' "$legacy_path" "$backup_path"
}

link_file "$repo_dir/zsh/zshrc" "$HOME/.zshrc"
link_file "$repo_dir/zsh/p10k.zsh" "$HOME/.p10k.zsh"
link_file "$repo_dir/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
mkdir -p "$HOME/.config"
link_file "$repo_dir/nvim" "$HOME/.config/nvim"
mkdir -p "$HOME/.config/aerospace"
remove_legacy_aerospace_config
link_file "$repo_dir/AeroSpace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"

printf 'macOS 配置链接完成。\n'
