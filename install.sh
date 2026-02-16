#!/usr/bin/env bash
set -e

TARGET="$HOME"
MODE="install"
DRY_RUN=0
ADOPT=0
PACKAGES=(zsh tmux git bin nvim codex ghostty)

usage() {
  cat <<USAGE
Usage: ./install.sh [options]

Options:
  --target <dir>  Install target directory (default: \$HOME)
  --dry-run       Show planned stow actions without changing files
  --adopt         Adopt existing files into the stow package tree
  --delete        Remove links for configured packages
  -h, --help      Show this help
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      shift
      if [ "$#" -eq 0 ]; then
        echo "error: --target requires a directory" >&2
        exit 1
      fi
      TARGET="$1"
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    --adopt)
      ADOPT=1
      ;;
    --delete)
      MODE="delete"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

if ! command -v stow >/dev/null 2>&1; then
  echo "error: GNU Stow is not installed" >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

STOW_FLAGS=(-t "$TARGET")
if [ "$DRY_RUN" -eq 1 ]; then
  STOW_FLAGS=(-n -v "${STOW_FLAGS[@]}")
fi
if [ "$ADOPT" -eq 1 ]; then
  STOW_FLAGS=(--adopt "${STOW_FLAGS[@]}")
fi
if [ "$MODE" = "delete" ]; then
  STOW_FLAGS=(-D "${STOW_FLAGS[@]}")
fi

stow "${STOW_FLAGS[@]}" "${PACKAGES[@]}"
