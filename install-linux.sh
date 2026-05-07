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

link_file "$repo_dir/zsh/zshrc" "$HOME/.zshrc"
link_file "$repo_dir/wezterm/wezterm.lua" "$HOME/.wezterm.lua"

printf 'Linux 配置链接完成。\n'
