#!/usr/bin/env bash
# Install zsh on RH-like linux
set -e

sudo dnf install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#!/usr/bin/env bash
# Install Homebrew (https://brew.sh/) for Linux (RH-like with zsh)
set -e

sudo yum groupinstall 'Development Tools'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install modern Unix
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install gcc fzf bat git-delta eza fd tldr cheat dust duf broot ripgrep zoxide
