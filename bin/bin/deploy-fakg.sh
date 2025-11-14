#!/usr/bin/env sh
# Usage: deploy-fakg
# Deploy a new version o FAKg
set -e

if [ "$1" = "--help" ]; then
	grep '^#/' <"$0" |
		cut -c4-
	exit 2
fi

sudo systemctl stop fakg

sudo cp ~/fakg /srv/fakg
sudo chmod 550 /srv/fakg/fakg
sudo chown fakg:fakg /srv/fakg/fakg

sudo systemctl start fakg
