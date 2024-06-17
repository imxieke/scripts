#!/bin/bash
#
# WDlinux Control Panel,lamp,lnmp system install scripts
# Created by wdlinux QQ:12571192
# Url:http://www.wdlinux.cn
# Last Updated 2012.06.23
#

if [[ $1 == "uninstall" ]];then
	echo "starting backup data..."
	mkdir -p /www/backup
	service mysqld stop
	service nginxd stop
	service httpd stop
	service wdapache stop
	service pureftpd stop
	tar zcvf /www/backup/mysqldatdbk.tar.gz /www/wdlinux/mysql/var
	tar zcvf /www/backup/ngconfbk.tar.gz /www/wdlinux/nginx/conf
	tar zcvf /www/backup/apconfbk.tar.gz /www/wdlinux/apache/conf
	rpm -e lanmp_wdcp --nodeps
	rm -fr /www/wdlinux
	echo
	echo "	lanmp,wdcp remove is OK"
	echo
	exit 0
fi

echo "Turn off selinux..."
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/^exclude=/#exclude=/g' /etc/yum.conf
yum install -y gcc gcc-c++ make autoconf libtool-ltdl-devel gd-devel freetype-devel libxml2-devel libjpeg-devel libpng-devel openssl-devel curl-devel patch libmcrypt-devel libmhash-devel ncurses-devel sudo bzip2 iptables sendmail iptables unzip

#echo "Check the network..."
#ping -c 2 113.105.167.1
#if [[ $? != 0 ]];then
#	echo 
#	echo "network err"
#	exit 1
#fi
ping -c 3 dl.wdlinux.cn
if [[ $? == 2 ]];then
	echo
	echo "dns error"
	exit 1
fi

if [[ ! -d /www/wdlinux ]];then
	echo
	echo "rpm remove..."
	rpm -e php --nodeps
	rpm -e httpd --nodeps
	rpm -e mysql-server --nodeps
	rpm -e mysql --nodeps
fi

echo "yum update..."
yum install -y make autoconf sudo wget libtool-ltdl-devel gd-devel freetype-devel libxml2-devel libjpeg-devel libpng-devel openssl-devel curl-devel patch libmcrypt-devel libmhash-devel ncurses-devel iptables

arch=i386
Aurl="http://dl.wdlinux.cn:5180/rpms"
if [[ `uname -m` == "x86_64" ]];then
	arch="x86_64"
fi

function in_finsh {
        echo
        echo "          configuration ,lamp or lnmp,wdcp install is finshed"
        echo "          visit http://ip"
        echo "          wdcp visit http://ip:8080"
        echo "          more infomation please visit http://www.wdlinux.cn"
        echo
}

function in_check {
        if [[ $1 == 1 ]];then
                echo
                echo "============  $2 install error  ============="
                echo
                exit 1
        else
                echo
                echo "============  $2 install OK  =============="
                echo
                echo
        fi
}

grep -E 'wdOS 1|5\.' /etc/redhat-release > /dev/null 2>&1
v1=$?
grep -E 'wdOS 2|6\.' /etc/redhat-release > /dev/null 2>&1
v2=$?
if [ $v1 == 0 ];then
	RF="lanmp_wdcp-2-5.$arch.rpm";
elif [ $v2 == 0 ];then
	RF="lanmp_wdcp-2-5.el6.$arch.rpm";
	if [ $arch == "x86_64" ];then
		wget -c http://dl.wdlinux.cn:5180/soft/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
		rpm -ivh rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm 
	else
		wget -c http://dl.wdlinux.cn:5180/soft/rpmforge-release-0.5.2-2.el6.rf.i686.rpm
		rpm -ivh rpmforge-release-0.5.2-2.el6.rf.i686.rpm 
	fi
	yum install -y mhash-devel libmcrypt-devel
else
	echo
	echo "The current system does not support"
	echo
	exit
fi
wget -c http://dl.wdlinux.cn:5180/rpms/$RF
rpm -ivh $RF --nodeps
I_F=$?
if [ $I_F == 0 ];then
	echo
fi
in_check $I_F lanmp_wdcp

rm -f wdcp_v*
wget -c http://dl.wdlinux.cn:5180/rpms/wdcp_v2.5.tar.gz > /dev/null 2>&1
tar zxvf wdcp_v2.5.tar.gz -C / > /dev/null 2>&1

in_finsh
