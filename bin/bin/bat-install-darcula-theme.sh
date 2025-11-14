#!/usr/bin/env bash
# Lista os temas para o bat
set -e

mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
curl -O https://raw.githubusercontent.com/lesiak/Darcula.tmTheme/master/Darcula.tmTheme
bat cache --build

bat --list-themes | fzf --preview="bat --theme={} --color=always $1"
