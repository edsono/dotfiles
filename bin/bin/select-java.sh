#!/usr/bin/env bash
#/ Usage: select-java <args...>
#/ Redirects to a command that select java in RH-derive linux
set -e

if [ $# -eq 0 -o "$1" = "-h" ]; then
	grep '^#/' <"$0" | cut -c4-
	exit 2
fi

# Commands to execute
sudo update-alternatives --config java
