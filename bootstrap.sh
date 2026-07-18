#!/usr/bin/env bash
#/ Usage: bootstrap.sh [install.sh options...]
#/ Bootstrap dotfiles on a fresh machine: install git/stow, clone the
#/ repository into ~/Code/dotfiles and run ./install.sh.
#/
#/ One-liner:
#/   curl -fsSL https://raw.githubusercontent.com/edsono/dotfiles/main/bootstrap.sh | bash
set -euo pipefail

REPO_HTTPS="https://github.com/edsono/dotfiles.git"
REPO_SSH="git@github.com:edsono/dotfiles.git"
CLONE_DIR="${DOTFILES_DIR:-$HOME/Code/dotfiles}"

install_packages() {
  if command -v brew >/dev/null 2>&1; then
    brew install "$@"
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y "$@"
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y "$@"
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm "$@"
  elif command -v zypper >/dev/null 2>&1; then
    sudo zypper install -y "$@"
  elif command -v apk >/dev/null 2>&1; then
    sudo apk add "$@"
  else
    echo "error: no supported package manager found; install manually: $*" >&2
    exit 1
  fi
}

missing=()
command -v git >/dev/null 2>&1 || missing+=(git)
command -v stow >/dev/null 2>&1 || missing+=(stow)
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Installing missing packages: ${missing[*]}"
  install_packages "${missing[@]}"
fi

if [ -d "$CLONE_DIR/.git" ]; then
  echo "Repository already present, updating: $CLONE_DIR"
  git -C "$CLONE_DIR" pull --rebase
else
  mkdir -p "$(dirname "$CLONE_DIR")"
  # Prefer SSH when a key is available; fall back to HTTPS.
  if ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    git clone "$REPO_SSH" "$CLONE_DIR"
  else
    git clone "$REPO_HTTPS" "$CLONE_DIR"
  fi
fi

cd "$CLONE_DIR"
./install.sh "$@"
