#!/usr/bin/env bash
# Install NeoVim using Homebrew
set -e

# Select an newer version of NodeJS first
# if necessary, reset selection using: dnf module reset nodejs
# https://developers.redhat.com/hello-world/nodejs#enable_the_node_js_module
sudo dnf module enable nodejs:20

# Install requirements for NeoVim
sudo yum install golang nodejs python@3.12

# Install NeoVim
brew install lazygit tmux neovim

# Install tmux tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
