#!/usr/bin/env sh
# Usage: deploy-fakd
# Deploy a new version o FAKd
set -e

if [ "$1" = "--help" ]; then
	grep '^#/' <"$0" |
		cut -c4-
	exit 2
fi

sudo systemctl stop fakg

sudo cp ~/fakd.jar /srv/fakd
# chmod 550?
sudo chmod 500 /srv/fakd/fakd.jar
sudo chown fakd:fakd /srv/fakd/fakd.jar

sudo systemctl start fakg
# sudo systemctl only restart??? fakd
