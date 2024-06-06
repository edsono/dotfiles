#!/usr/bin/env bash
# Corrige url de um git config
set -e

sed 's|^\s\+url\s\?=\s\?.*$|\turl = git@github.com:edsono/dotfiles.git|' .git/config >.git/config.tmp &&
	mv .git/config.tmp .git/config &&
	rm .git/config.tmp
