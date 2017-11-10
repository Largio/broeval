# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_check_update = false

  config.vm.define "bro11", autostart: false do |bro11|
    bro11.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.11"
  end
  config.vm.define "bro12", autostart: false do |bro12|
    bro12.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.12"
  end
  config.vm.define "bro13", autostart: false do |bro13|
    bro13.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.13"
  end
  config.vm.define "bro14", autostart: false do |bro14|
    bro14.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.14"
  end

  config.vm.define "bro21", autostart: false do |bro21|
    bro21.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.21"
  end
  config.vm.define "bro22", autostart: false do |bro22|
    bro22.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.22"
  end
  config.vm.define "bro23", autostart: false do |bro23|
    bro23.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.23"
  end
  config.vm.define "bro24", autostart: false do |bro24|
    bro24.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.24"
  end

  config.vm.define "bro31", autostart: false do |bro31|
    bro31.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.31"
  end
  config.vm.define "bro32", autostart: false do |bro32|
    bro32.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.32"
  end
  config.vm.define "bro33", autostart: false do |bro33|
    bro33.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.33"
  end
  config.vm.define "bro34", autostart: false do |bro34|
    bro34.vm.network "public_network", bridge: "enp0s25", ip: "10.0.0.34"
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "3072"
  end

  config.vm.provision "shell", inline: <<-SHELL   
#export LANGUAGE=en_US.UTF-8
#export LANG=en_US.UTF-8
#export LC_ALL=en_US.UTF-8
#locale-gen en_US.UTF-8
#ex +"%s@DPkg@//DPkg" -cwq /etc/apt/apt.conf.d/70debconf
#dpkg-reconfigure debconf -f noninteractive -p critical	

	apt-get update
    apt-get install -y apache2 openssh-server vim git curl parallel sysstat htop openssl
    # Download and install Bro
	pwd
    [ -d bro-2.4.1/ ] || curl -O https://www.bro.org/downloads/bro-2.4.1.tar.gz
    [ -d bro-2.4.1/ ] || tar -vxzf bro-2.4.1.tar.gz
	pwd    
	cd bro-2.4.1/
	pwd    
	apt-get install -y cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig 
    ./configure
    make
    make install
    echo "export PATH=\"$PATH:/usr/local/bro/bin\"" >> ~/.bashrc
    # Generate directory for logging
	mkdir -p ~/brolog
	mkdir -p ~/snortlog
	[ -e ~/broeval ] || ln -s /vagrant ~/broeval
#Download and install Snort

#CHANGED THIS:::NEEDS TO BE TESTED (LARS):
	cd /home/ubuntu/
	[ -d pcre-8.40/ ] || wget -N https://ftp.pcre.org/pub/pcre/pcre-8.40.tar.gz
	[ -d pcre-8.40/ ] || tar vxzf pcre-8.40.tar.gz
	[ -d daq-2.0.6/ ] || wget -N https://www.snort.org/downloads/archive/snort/daq-2.0.6.tar.gz
	[ -d daq-2.0.6/ ] || tar vxzf daq-2.0.6.tar.gz
	[ -d snort-2.9.9.0/ ] || wget -N https://www.snort.org/downloads/archive/snort/snort-2.9.9.0.tar.gz
	[ -d snort-2.9.9.0/ ] || tar vxzf snort-2.9.9.0.tar.gz
	apt-get install libdumbnet-dev
	cd pcre-8.40/
	./configure
	make
	make install
	cd ..
	cd daq-2.0.6
	./configure && make && make install
	cd ..
	cd snort-2.9.9.0
	./configure --enable-sourcefile && make && make install
	ldconfig
	cd /vagrant
	./snort_configure.sh
	cd /home/ubuntu


    # Generate random files of fixed size
    cd /var/www/html
    base64 --wrap=99 /dev/urandom | head -c 10 > 1.txt
    base64 --wrap=99 /dev/urandom | head -c 100 > 2.txt
    base64 --wrap=99 /dev/urandom | head -c 1000 > 3.txt
    base64 --wrap=99 /dev/urandom | head -c 10000 > 4.txt
    base64 --wrap=99 /dev/urandom | head -c 100000 > 5.txt
    base64 --wrap=99 /dev/urandom | head -c 1000000 > 6.txt
    base64 --wrap=99 /dev/urandom | head -c 10000000 > 7.txt
    base64 --wrap=99 /dev/urandom | head -c 100000000 > 8.txt
    base64 --wrap=99 /dev/urandom | head -c 1000000000 > 9.txt
	
	#Temporaryly copy Rand data for later use within mysql
	mkdir ~/temp_rand
	cp /var/www/html/* ~/temp_rand	
	
	#Install FTP Server and prepare Rand Data
	apt-get install vsftpd
	mkdir -p /home/upload
	sed -i s/anonymous_enable=NO/anonymous_enable=YES/g /etc/vsftpd.conf
	sed -i '$aanon_root= /home/upload' /etc/vsftpd.conf
	sed -i '$ano_anon_password=YES' /etc/vsftpd.conf
	sed -i '$ahide_ids=YES' /etc/vsftpd.conf
	sed -i '$apasv_min_port=40000' /etc/vsftpd.conf
	sed -i '$apasv_max_port=50000' /etc/vsftpd.conf
	service vsftpd restart
	cp -R /var/www/html/* /home/upload

	#Create OpenSSl Certificate
	openssl genrsa -des3 -passout pass:x -out testbed.pass.key 2048
	openssl rsa -passin pass:x -in testbed.pass.key -out testbed.key
	rm testbed.pass.key
	openssl req -new -key testbed.key -out testbed.csr -subj "/C=DE/ST=BadenWuerttemberg/L=Heidelberg/O=University/OU=Informatik/CN=testbedheidelberg.com"
	openssl x509 -req -days 365 -in testbed.csr -signkey testbed.key -out testbed.crt
	cp testbed.key /etc/ssl/private/
	cp testbed.crt /etc/ssl/certs/
	rm testbed.crt
	rm testbed.key
	rm testbed.csr

	#Create VirtualHost
	touch ssl.conf
	echo -e $'<VirtualHost *:443>\n\tSSLEngine on\n\tSSLCertificateFile /etc/ssl/certs/testbed.crt\n\tSSLCertificateKeyFile /etc/ssl/private/testbed.key\n\n\t# Pfad zu den Webinhalten\n\tDocumentRoot /var/www/html/\n</VirtualHost>' > ssl.conf
	mv ssl.conf /etc/apache2/sites-available/	

	#Activate Apache SSL
	a2enmod ssl
	a2ensite ssl.conf
	service apache2 force-reload

	#Install MySQL Server and populate DB
	debconf-set-selections <<< 'mysql-server mysql-server/root_password password brosnort-1386'
	debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password brosnort-1386'
	apt-get install -y mysql-server
	#Make mysql accessible without password	
	echo -e "[client]\nuser=root\npassword=brosnort-1386\n" > /home/ubuntu/.my.cnf
	echo -e "[client]\nuser=root\npassword=brosnort-1386\n" > ~/.my.cnf
	chown root ~/.my.cnf
	chmod 0600 ~/.my.cnf
	sed -i "s/.*bind-address.*/bind-address=0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
	service mysql restart
	mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'brosnort-1386' WITH GRANT OPTION;"
	mysql -e "FLUSH PRIVILEGES;"
	mysql -e "CREATE DATABASE ids_rand DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
	mysql --database=ids_rand --execute="CREATE TABLE rand_data (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), size INT(20) UNSIGNED);"
	mysql --database=ids_rand --execute="LOAD DATA LOCAL INFILE '~/temp_rand/1.txt' INTO TABLE rand_data LINES TERMINATED BY '\\n' (data) SET size = 10;"
	mysql --database=ids_rand --execute="LOAD DATA LOCAL INFILE '~/temp_rand/2.txt' INTO TABLE rand_data LINES TERMINATED BY '\\n' (data) SET size = 100;"
	mysql --database=ids_rand --execute="LOAD DATA LOCAL INFILE '~/temp_rand/3.txt' INTO TABLE rand_data LINES TERMINATED BY '\\n' (data) SET size = 1000;"
	mysql --database=ids_rand --execute="LOAD DATA LOCAL INFILE '~/temp_rand/4.txt' INTO TABLE rand_data LINES TERMINATED BY '\\n' (data) SET size = 10000;"
	mysql --database=ids_rand --execute="LOAD DATA LOCAL INFILE '~/temp_rand/5.txt' INTO TABLE rand_data LINES TERMINATED BY '\\n' (data) SET size = 100000;"
	mysql --database=ids_rand --execute="LOAD DATA LOCAL INFILE '~/temp_rand/6.txt' INTO TABLE rand_data LINES TERMINATED BY '\\n' (data) SET size = 1000000;"
	mysql --database=ids_rand --execute="LOAD DATA LOCAL INFILE '~/temp_rand/7.txt' INTO TABLE rand_data LINES TERMINATED BY '\\n' (data) SET size = 10000000;"
	mysql --database=ids_rand --execute="LOAD DATA LOCAL INFILE '~/temp_rand/8.txt' INTO TABLE rand_data LINES TERMINATED BY '\\n' (data) SET size = 100000000;"

	rm -rf ~/temp_rand

	chown ubuntu /home/ubuntu/.my.cnf
	chmod 0600 /home/ubuntu/.my.cnf

	#Bring Bro Configuration- and Signature-Files into place
	cp /vagrant/helpers/configs/bro/* /usr/local/bro/share/bro/site
	mv /usr/local/bro/share/bro/site/sigs-testbed.sig /usr/local/bro/share/bro/policy/frameworks/signatures/

	
	#Install hping3 for ICMP Traffic
	apt-get --assume-yes install hping3
  SHELL
end
