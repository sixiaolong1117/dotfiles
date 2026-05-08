#!/bin/sh

set -eu

if ! command -v jq >/dev/null 2>&1; then
  printf '%s\n' 'scale-outputs: jq is required to detect output resolutions.' >&2
  exit 0
fi

swaymsg -t get_outputs |
  jq -r '.[] | select(.active) | [.name, (.current_mode.height // 0)] | @tsv' |
  while IFS="$(printf '\t')" read -r output height; do
    [ -n "$output" ] || continue

    if [ "$height" -gt 1440 ]; then
      scale=2
    else
      scale=1
    fi

    swaymsg output "$output" scale "$scale" >/dev/null
  done
