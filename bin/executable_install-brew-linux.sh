#!/usr/bin/env bash
# Install Homebrew (https://brew.sh/) for Linux
set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install modern Unix
brew install fzf bat git-delta eza fd tldr cheat dust duf broot ripgrep zoxide
