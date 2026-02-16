#!/usr/bin/env bash
set -e

TARGET="$HOME"
MODE="install"
DRY_RUN=0
ADOPT=0
SKIP_FONT_INSTALL=0
SKIP_ZSH_INSTALL=0
SET_DEFAULT_SHELL=0
PACKAGES=(zsh tmux git bin nvim codex ghostty)
CODEX_PACKAGE="codex"
CODEX_IGNORE_REGEX='^\.codex/skills/\.system(/|$)'
NERD_FONTS_JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

usage() {
  cat <<USAGE
Usage: ./install.sh [options]

Options:
  --target <dir>  Install target directory (default: \$HOME)
  --dry-run       Show planned stow actions without changing files
  --adopt         Adopt existing files into the stow package tree
  --skip-zsh-install
                   Skip zsh install check/package-manager install attempt
  --set-default-shell
                   Attempt to set zsh as the user's login shell
  --skip-font-install
                   Skip JetBrainsMono Nerd Font install check/download
  --delete        Remove links for configured packages
  -h, --help      Show this help
USAGE
}

collect_stow_conflict_targets() {
  local stow_output=""
  local non_codex_packages=()
  local package_name=""

  for package_name in "${PACKAGES[@]}"; do
    if [ "$package_name" = "$CODEX_PACKAGE" ]; then
      continue
    fi
    non_codex_packages+=("$package_name")
  done

  stow_output="$(
    {
      stow -n -v -t "$TARGET" "${non_codex_packages[@]}"
      stow -n -v --ignore="$CODEX_IGNORE_REGEX" -t "$TARGET" "$CODEX_PACKAGE"
    } 2>&1 || true
  )"

  printf '%s\n' "$stow_output" | sed -nE 's/.* over existing target (.*) since .*/\1/p' | sort -u
}

backup_stow_conflicts() {
  local conflicts=()
  local rel_path=""
  local src_path=""
  local backup_root=""
  local backup_path=""

  while IFS= read -r rel_path; do
    if [ -n "$rel_path" ]; then
      conflicts+=("$rel_path")
    fi
  done < <(collect_stow_conflict_targets)

  if [ "${#conflicts[@]}" -eq 0 ]; then
    return 0
  fi

  backup_root="${TARGET%/}/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup_root"
  echo "Backing up conflicting files to ${backup_root}"

  for rel_path in "${conflicts[@]}"; do
    src_path="${TARGET%/}/${rel_path}"
    if [ ! -e "$src_path" ] && [ ! -L "$src_path" ]; then
      continue
    fi

    backup_path="${backup_root}/${rel_path}"
    mkdir -p "$(dirname "$backup_path")"
    mv "$src_path" "$backup_path"
    echo "  moved ${src_path} -> ${backup_path}"
  done
}

run_with_privileges() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
    return $?
  fi

  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
    return $?
  fi

  return 1
}

ensure_zsh_installed() {
  if command -v zsh >/dev/null 2>&1; then
    echo "zsh already installed."
    return 0
  fi

  echo "zsh not found. Attempting to install..."
  case "$(uname -s)" in
    Darwin)
      if ! command -v brew >/dev/null 2>&1; then
        echo "warning: Homebrew not found, skipping zsh install." >&2
        return 0
      fi
      if ! brew list --formula zsh >/dev/null 2>&1; then
        if ! brew install zsh; then
          echo "warning: failed to install zsh with Homebrew." >&2
          return 0
        fi
      fi
      ;;
    Linux)
      if command -v apt-get >/dev/null 2>&1; then
        if ! run_with_privileges apt-get update; then
          echo "warning: failed to run apt-get update for zsh install." >&2
          return 0
        fi
        if ! run_with_privileges apt-get install -y zsh; then
          echo "warning: failed to install zsh with apt-get." >&2
          return 0
        fi
      elif command -v dnf >/dev/null 2>&1; then
        if ! run_with_privileges dnf install -y zsh; then
          echo "warning: failed to install zsh with dnf." >&2
          return 0
        fi
      elif command -v yum >/dev/null 2>&1; then
        if ! run_with_privileges yum install -y zsh; then
          echo "warning: failed to install zsh with yum." >&2
          return 0
        fi
      elif command -v pacman >/dev/null 2>&1; then
        if ! run_with_privileges pacman -Sy --noconfirm zsh; then
          echo "warning: failed to install zsh with pacman." >&2
          return 0
        fi
      elif command -v zypper >/dev/null 2>&1; then
        if ! run_with_privileges zypper install -y zsh; then
          echo "warning: failed to install zsh with zypper." >&2
          return 0
        fi
      elif command -v apk >/dev/null 2>&1; then
        if ! run_with_privileges apk add zsh; then
          echo "warning: failed to install zsh with apk." >&2
          return 0
        fi
      else
        echo "warning: no supported package manager found, skipping zsh install." >&2
        return 0
      fi
      ;;
    *)
      echo "warning: unsupported platform for zsh auto-install: $(uname -s)" >&2
      return 0
      ;;
  esac

  if command -v zsh >/dev/null 2>&1; then
    echo "zsh installation check passed."
  else
    echo "warning: zsh still not available in PATH after install attempt." >&2
  fi
}

ensure_zsh_default_shell() {
  local zsh_path=""
  local current_shell=""
  zsh_path="$(command -v zsh || true)"

  if [ -z "$zsh_path" ]; then
    echo "warning: zsh not found, skipping default-shell update." >&2
    return 0
  fi

  current_shell="${SHELL:-}"
  if [ "$current_shell" = "$zsh_path" ]; then
    echo "zsh is already the current shell."
    return 0
  fi

  if ! command -v chsh >/dev/null 2>&1; then
    echo "warning: 'chsh' not found, skipping default-shell update." >&2
    return 0
  fi

  if run_with_privileges chsh -s "$zsh_path" "$USER"; then
    echo "Login shell updated to zsh (${zsh_path})."
  else
    echo "warning: failed to set zsh as login shell automatically." >&2
    echo "warning: run manually: chsh -s \"$zsh_path\"" >&2
  fi
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
    --skip-zsh-install)
      SKIP_ZSH_INSTALL=1
      ;;
    --set-default-shell)
      SET_DEFAULT_SHELL=1
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
    if [ "$SKIP_ZSH_INSTALL" -eq 0 ]; then
      echo "dry-run: would ensure zsh is installed."
    fi
    if [ "$SKIP_FONT_INSTALL" -eq 0 ]; then
      echo "dry-run: would ensure JetBrainsMono Nerd Font is installed."
    fi
    if [ "$SET_DEFAULT_SHELL" -eq 1 ]; then
      echo "dry-run: would set zsh as the login shell."
    fi
  else
    if [ "$SKIP_ZSH_INSTALL" -eq 0 ]; then
      ensure_zsh_installed
    fi
    if [ "$SKIP_FONT_INSTALL" -eq 0 ]; then
      ensure_jetbrains_nerd_font
    fi
    if [ "$SET_DEFAULT_SHELL" -eq 1 ]; then
      ensure_zsh_default_shell
    fi
    if [ "$ADOPT" -eq 0 ]; then
      backup_stow_conflicts
    fi
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

non_codex_packages=()
for package_name in "${PACKAGES[@]}"; do
  if [ "$package_name" = "$CODEX_PACKAGE" ]; then
    continue
  fi
  non_codex_packages+=("$package_name")
done

stow "${STOW_FLAGS[@]}" "${non_codex_packages[@]}"
stow --ignore="$CODEX_IGNORE_REGEX" "${STOW_FLAGS[@]}" "$CODEX_PACKAGE"
