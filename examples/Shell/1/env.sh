#!/bin/bash
echo "Start Deploy Ubuntu System envirtual!"
apt-get update && apt-get upgrade -y
echo "Start install base Software packages:"
sudo add-apt-repository ppa:git-core/ppa && sudo apt-get update
sudo apt-get install git gcc autoconf make automake software-properties-common python-pip
#php extension
apt-get install php5-curl php5-gd php5-imap php5-dev php5-mcrypt \
				php5-odbc php5-ldap php5-sqlite php5-mysql php5-pgsql

php5enmod mcrypt && php5enmod imap 
service apache2 restart