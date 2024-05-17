#!/usr/bin/env bash
# Install zsh on RH-like linux
set -e

sudo dnf install zsh
chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
