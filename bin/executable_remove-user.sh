#!/usr/bin/env bash
#/ Usage: remove-user <username>
#/ Remove a user using userdel
set -e

if [ $# -eq 0 -o "$1" = "-h" ]; then
	grep '^#/' <"$0" | cut -c4-
	exit 2
fi

# -r: remove mailbox too
userdel -r $1
