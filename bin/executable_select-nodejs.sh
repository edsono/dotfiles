#!/usr/bin/env bash
#/ Usage: select-nodejs <args...>
#/ Redirects to a command that select nodejs in RH-like linux
set -e

if [ $# -eq 0 -o "$1" = "-h" ]; then
	grep '^#/' <"$0" | cut -c4-
	exit 2
fi

# Commands to execute
sudo dnf module -y enable nodejs:20
