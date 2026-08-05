#!/usr/bin/env bash
# Merge OpenCode/opencode.jsonc from this repo into the local opencode config (macOS / Linux).
# Usage: ./OpenCode/sync-opencode.sh [--test]
set -euo pipefail
exec python3 "$(dirname "$0")/sync-opencode.py" "$@"
