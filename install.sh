#!/usr/bin/env bash
set -e

TARGET="$HOME"
MODE="install"
DRY_RUN=0
ADOPT=0
SKIP_FONT_INSTALL=0
PACKAGES=(zsh tmux git bin nvim codex ghostty)
NERD_FONTS_JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

usage() {
  cat <<USAGE
Usage: ./install.sh [options]

Options:
  --target <dir>  Install target directory (default: \$HOME)
  --dry-run       Show planned stow actions without changing files
  --adopt         Adopt existing files into the stow package tree
  --skip-font-install
                   Skip JetBrainsMono Nerd Font install check/download
  --delete        Remove links for configured packages
  -h, --help      Show this help
USAGE
}

font_install_dir() {
  case "$(uname -s)" in
    Darwin)
      echo "${HOME}/Library/Fonts"
      ;;
    Linux)
      echo "${HOME}/.local/share/fonts"
      ;;
    *)
      return 1
      ;;
  esac
}

is_jetbrains_nerd_font_installed() {
  if command -v fc-list >/dev/null 2>&1; then
    if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
      return 0
    fi
  fi

  install_dir="$(font_install_dir 2>/dev/null || true)"
  if [ -n "${install_dir}" ] && [ -d "${install_dir}" ]; then
    if find "${install_dir}" -maxdepth 1 -type f -name "*JetBrainsMono*Nerd*.*" | grep -q .; then
      return 0
    fi
  fi

  return 1
}

ensure_jetbrains_nerd_font() {
  if is_jetbrains_nerd_font_installed; then
    echo "JetBrainsMono Nerd Font already installed."
    return 0
  fi

  install_dir="$(font_install_dir 2>/dev/null || true)"
  if [ -z "${install_dir}" ]; then
    echo "warning: skipping font install on unsupported platform: $(uname -s)" >&2
    return 0
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "warning: 'curl' not found, skipping JetBrainsMono Nerd Font install." >&2
    return 0
  fi
  if ! command -v unzip >/dev/null 2>&1; then
    echo "warning: 'unzip' not found, skipping JetBrainsMono Nerd Font install." >&2
    return 0
  fi

  tmp_dir="$(mktemp -d)"
  zip_file="${tmp_dir}/JetBrainsMono.zip"
  mkdir -p "${install_dir}"

  echo "Installing JetBrainsMono Nerd Font in ${install_dir}..."
  if ! curl -fL --retry 3 --retry-delay 1 -o "${zip_file}" "${NERD_FONTS_JETBRAINS_URL}"; then
    echo "warning: failed to download JetBrainsMono Nerd Font." >&2
    rm -rf "${tmp_dir}"
    return 0
  fi

  if ! unzip -o -q "${zip_file}" -d "${install_dir}"; then
    echo "warning: failed to extract JetBrainsMono Nerd Font archive." >&2
    rm -rf "${tmp_dir}"
    return 0
  fi

  rm -rf "${tmp_dir}"

  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "${install_dir}" >/dev/null 2>&1 || true
  fi
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
    --skip-font-install)
      SKIP_FONT_INSTALL=1
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

if [ "$MODE" = "install" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    if [ "$SKIP_FONT_INSTALL" -eq 0 ]; then
      echo "dry-run: would ensure JetBrainsMono Nerd Font is installed."
    fi
  elif [ "$SKIP_FONT_INSTALL" -eq 0 ]; then
    ensure_jetbrains_nerd_font
  fi
fi

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
