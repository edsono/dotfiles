#!/usr/bin/env bash
#/ Usage: prepare-env <ssh-host>
#/ Prepare a new enviroment copying useful shell scripts
set -e

if [ $# -eq 0 -o "$1" = "-h" ]; then
	grep '^#/' <"$0" | cut -c4-
	exit 2
fi

# Allows passwordless login
~/bin/ssh-push.sh $1

# Create bin directory
ssh $1 '[ -d ~/bin ] || mkdir ~/bin'

# Copy initial scripts
scp ~/bin/install-*.sh $1:~/bin
