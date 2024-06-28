#!/usr/bin/env sh
# Usage: debug-fakg
# Debug FAKg
set -e

if [ "$1" = "--help" ]; then
	grep '^#/' <"$0" |
		cut -c4-
	exit 2
fi

# Start debugger
sudo /home/edsono/go/bin/dlv --listen=:8033 --headless=true --api-version=2 attach $(pidof /srv/fakg/fakg) /srv/fakg/fakg
