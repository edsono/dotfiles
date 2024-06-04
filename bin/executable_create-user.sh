#!/usr/bin/env bash
#/ Usage: create-user <username>
#/ Creater a new user using useradd
set -e

if [ $# -eq 0 -o "$1" = "-h" ]; then
	grep '^#/' <"$0" | cut -c4-
	exit 2
fi

# -m: cria o home directory
# -G wheel: permite ao usuário executar o sudo
useradd -m -G wheel edsono
