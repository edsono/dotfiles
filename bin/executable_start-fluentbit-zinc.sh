
#/usr/bin/env bash

fluent-bit -f 1 -R /home/linuxbrew/.linuxbrew/Cellar/fluent-bit/2.2.0/etc/fluent-bit/parsers.conf \
	   -i tail -p path=sfl.log -p parser=json -p read_from_head=true \
	   -o es -p Host=127.0.0.1 -p Port=4080 -p Path=/api -p HTTP_User=admin -p HTTP_Passwd=admin -p Generate_ID=on -p Index=job-logs-sfl -p type=_doc -m '*' \
	   -o stdout -m '*'
