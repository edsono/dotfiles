#!/usr/bin/env bash
# Install Homebrew (https://brew.sh/) for Linux (RH-like with zsh)
set -e

sudo yum groupinstall 'Development Tools'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install modern Unix
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install gcc fzf bat git-delta eza fd tldr cheat dust duf broot ripgrep zoxide
