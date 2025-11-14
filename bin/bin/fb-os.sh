
#/usr/bin/env bash

fluent-bit -f 1 -R /home/linuxbrew/.linuxbrew/Cellar/fluent-bit/2.2.0/etc/fluent-bit/parsers.conf \
	   -i tail -p path=sfl.log -p parser=json -p read_from_head=true \
	   -o opensearch -p Host=10.10.25.150 -p Port=8200 -p Index=job-logs-sfl -p Suppress_Type_Name=on -m '*' \
	   -o stdout -m '*'
