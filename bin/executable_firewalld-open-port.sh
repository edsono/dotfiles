#!/usr/bin/env bash
#/ Usage: firewalld-open-port.sh <port>
#/ Description of what this script does
set -e

if [ $# -eq 0 -o "$1" = "-h" ]; then
  grep '^#/' <"$0" | cut -c4-
  exit 2
fi

# Commands to execute
sudo firewall-cmd --permanent --zone=public --add-port=$1/tcp
sudo firewall-cmd --reload
