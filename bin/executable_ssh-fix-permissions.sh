#!/usr/bin/env bash
#/ Author: Edson César <edsono@gmail.com>
#/ Date: 2016 Oct 31
#/ Usage: ssh-fix-permissions...
#/ Fix file permissions on .ssh directory
set -e

if [ "$1" = "--help" ]; then
	grep '^#/' <"$0" |
		cut -c4-
	exit 2
fi

chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
