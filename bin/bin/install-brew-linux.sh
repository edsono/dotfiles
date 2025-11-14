#!/usr/bin/env bash
# Install Homebrew (https://brew.sh/) for Linux (RH-like with zsh)
set -e

sudo yum -y groupinstall 'Development Tools'

bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install modern Unix
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install gcc fzf zoxide lsd bat fd ripgrep git-delta tldr cheat dust duf broot
