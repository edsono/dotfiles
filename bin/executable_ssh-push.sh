#!/usr/bin/env bash
#/ Usage: ssh-push
#/ Push ssh certification to permit passwordless login
set -e

if [ $# -eq 0 -o "$1" = "-h" -o "$1" = "--help" ]; then
	grep '^#/' <"$0" |
		cut -c4-
	exit 2
fi

# push SSH public key to another box
[ -f ~/.ssh/id_rsa.pub ] || ssh-keygen -t rsa
for host in "$@"; do
	echo $host
	ssh $host '[ -d ~/.ssh ] || mkdir ~/.ssh; chmod 700 ~/.ssh; [ -f ~/.ssh/authorized_keys ] || touch ~/.ssh/authorized_keys; chmod 600 ~/.ssh/*; cat >> ~/.ssh/authorized_keys' <~/.ssh/id_rsa.pub
done
