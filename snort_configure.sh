#!/bin/bash
#This file is for usage with VAGRANT ! (because /vagrant/ filepath is used as shared folder)
mkdir /etc/snort
mkdir /etc/snort/rules
mkdir /etc/snort/rules/iplists
mkdir /etc/snort/preproc_rules
mkdir /usr/local/lib/snort_dynamicrules
mkdir /etc/snort/so_rules
touch /etc/snort/rules/iplists/black_list.rules
touch /etc/snort/rules/iplists/white_list.rules
touch /etc/snort/rules/local.rules
touch /etc/snort/sid-msg.map
mkdir /var/log/snort
mkdir /var/log/snort/archived_logs
chmod -R 5775 /etc/snort
chmod -R 5775 /var/log/snort
chmod -R 5775 /var/log/snort/archived_logs
chmod -R 5775 /etc/snort/so_rules
chmod -R 5775 /usr/local/lib/snort_dynamicrules
cd /home/ubuntu/snort-2.9.9.0/etc
cp *.conf* /etc/snort
cp *.map /etc/snort
cp *.dtd /etc/snort
cd ..
cd src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/
cp * /usr/local/lib/snort_dynamicpreprocessor/

#Generic part. Not needed for testbed because it brings it's own config files !
sed -i -e 's!ipvar HOME_NET any!ipvar HOME_NET 10.0.0.0/24!g' /etc/snort/snort.conf
sed -i -e 's!var RULE_PATH ../rules!var RULE_PATH /etc/snort/rules!g' /etc/snort/snort.conf
sed -i -e 's!var PREPROC_RULE_PATH ../preproc_rules!var PREPROC_RULE_PATH /etc/snort/preproc_rules!g' /etc/snort/snort.conf
sed -i -e 's!var SO_RULE_PATH ../so_rules!var SO_RULE_PATH /etc/snort/so_rules!g' /etc/snort/snort.conf
sed -i -e 's!var WHITE_LIST_PATH ../rules!var WHITE_LIST_PATH /etc/snort/rules/iplists!g' /etc/snort/snort.conf
sed -i -e 's!var BLACK_LIST_PATH ../rules!var BLACK_LIST_PATH /etc/snort/rules/iplists!g' /etc/snort/snort.conf
#It is recommended to goto www.snort.org and make a free account to retrieve a personal "oinkcode" to being able to download the registered rules package.

cd /home/ubuntu
wget -N https://www.snort.org/reg-rules/snortrules-snapshot-2990.tar.gz/OINKCODE -O snortrules-snapshot-2990.tar.gz
sudo tar xvfz snortrules-snapshot-2990.tar.gz -C /etc/snort
cd /etc/snort/etc
sudo cp ./*.conf* ../
sudo cp ./*.map ../
cd /etc/snort
sudo rm -Rf /etc/snort/etc
#Bring Snort Configuration files in place
cp /vagrant/helpers/configs/snort/* /etc/snort/
mv /etc/snort/local.rules /etc/snort/rules/
