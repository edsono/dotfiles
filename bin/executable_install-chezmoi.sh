#!/usr/bin/env bash
# Install Chezmoi to apply my dotfiles
set -e

sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply edsono
