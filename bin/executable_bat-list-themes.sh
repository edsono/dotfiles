#!/usr/bin/env bash
# Lista os temas para o bat
set -e

bat --list-themes | fzf --preview="bat --theme={} --color=always $1"
