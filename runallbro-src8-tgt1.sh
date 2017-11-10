#!/bin/bash

echo "Please edit this file and uncomment the experiments you intended to run."

#./runs/snort/100KB/src8-tgt1/icmp-par-noids-iter.sh
#./runs/snort/100KB/src8-tgt1/icmp-par-min-iter.sh
#./runs/snort/100KB/src8-tgt1/icmp-par-max-iter.sh
#./runs/snort/100KB/src8-tgt1/icmp-par-icmp-iter.sh
#./runs/bro/100KB/src8-tgt1/icmp-par-noids-iter.sh
#./runs/bro/100KB/src8-tgt1/icmp-par-min-iter.sh
#./runs/bro/100KB/src8-tgt1/icmp-par-max-iter.sh
#./runs/bro/100KB/src8-tgt1/icmp-par-icmp-iter.sh

#Nur mit 100 und 200 Iter:

#Stürzt ab:
#./runs/bro/100KB/src8-tgt1/ssl-par-noids-iter.sh
#./runs/bro/100KB/src8-tgt1/ssl-par-min-iter.sh
./runs/bro/100KB/src8-tgt1/ssl-par-max-iter.sh
#./runs/bro/100KB/src8-tgt1/ssl-par-ssl-iter.sh

#./runs/bro/100KB/src8-tgt1/http-par-noids-iter.sh
#./runs/bro/100KB/src8-tgt1/http-par-min-iter.sh
#./runs/bro/100KB/src8-tgt1/http-par-max-iter.sh
#./runs/bro/100KB/src8-tgt1/http-par-http-iter.sh
#./runs/snort/100KB/src8-tgt1/http-par-noids-iter.sh
#./runs/snort/100KB/src8-tgt1/http-par-min-iter.sh
#./runs/snort/100KB/src8-tgt1/http-par-max-iter.sh
#./runs/snort/100KB/src8-tgt1/http-par-http-iter.sh
#./runs/snort/100KB/src8-tgt1/ssl-par-noids-iter.sh
#./runs/snort/100KB/src8-tgt1/ssl-par-min-iter.sh
#STUERZT AB:
#./runs/snort/100KB/src8-tgt1/ssl-par-max-iter.sh
#./runs/snort/100KB/src8-tgt1/ssl-par-ssl-iter.sh

#./runs/snort/100KB/src8-tgt1/ftp-par-noids-iter.sh
#./runs/snort/100KB/src8-tgt1/ftp-par-min-iter.sh
#./runs/snort/100KB/src8-tgt1/ftp-par-max-iter.sh
#./runs/snort/100KB/src8-tgt1/ftp-par-ftp-iter.sh
#./runs/snort/100KB/src8-tgt1/mysql-par-noids-iter.sh
#./runs/snort/100KB/src8-tgt1/mysql-par-min-iter.sh
#./runs/snort/100KB/src8-tgt1/mysql-par-max-iter.sh
#./runs/snort/100KB/src8-tgt1/mysql-par-mysql-iter.sh

#./runs/bro/100KB/src8-tgt1/ftp-par-noids-iter.sh
#./runs/bro/100KB/src8-tgt1/ftp-par-min-iter.sh
#./runs/bro/100KB/src8-tgt1/ftp-par-max-iter.sh
#./runs/bro/100KB/src8-tgt1/mysql-par-noids-iter.sh
####################################################
./runs/bro/100KB/src8-tgt1/mysql-par-mysql-iter.sh
./runs/bro/100KB/src8-tgt1/mysql-par-min-iter.sh
./runs/bro/100KB/src8-tgt1/mysql-par-max-iter.sh
./runs/bro/100KB/src8-tgt1/ftp-par-ftp-iter.sh
