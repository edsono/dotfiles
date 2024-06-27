#!/usr/bin/env sh
#/ Usage: linux-fix-sssd-db.sh
#/ Fix a problem in RH linux with SSSD
set -e

if [ "$1" = "--help" ]; then
	grep '^#/' <"$0" |
		cut -c4-
	exit 2
fi

systemctl stop sssd
rm -rf /var/lib/sss/db/*
systemctl restart sssd
