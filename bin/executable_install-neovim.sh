#!/usr/bin/env bash
# Install NeoVim using Homebrew
set -e

# Install requirements for NeoVim
if [ $(cat /etc/redhat-release | grep -oh -m 1 '[[:digit:]]\+' | head -n 1) -ge 8 ]; then
	# Redhat 8+ have support to recent versions of nodejs and python

	# Select an newer version of NodeJS first
	# if necessary, reset selection using: dnf module reset nodejs
	# https://developers.redhat.com/hello-world/nodejs#enable_the_node_js_module
	sudo dnf module -y enable nodejs:20
	sudo yum -y install nodejs python3.12
else
	# Older version of redhat
	#
	# In this case, use brew to install recent versions of nodejs and python
	# as requirements to neovim treesitter and mason
	brew install nodejs python@3.12

	# Install last supported version of python to use it system-wide
	sudo yum -y install python36
fi
sudo yum -y install golang

# Install NeoVim
brew install lazygit tmux neovim

# Install tmux tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
