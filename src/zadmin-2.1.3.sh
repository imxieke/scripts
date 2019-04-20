#!/bin/bash
#version 2.1.5
#release 0
#time:2014-07-01 17:55:56
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
curdir=`pwd`

release=

if [ $(id -u) != "0" ]
then
  echo -e "Error: You must be root to run this script, please use root to install this script."
  exit 1
fi

if [[ $1 == "uninstall" ]]; then
  rpm -e zadmin
  echo "Zhujibao is uninstalled!"
  exit 0
fi


#检查用�?
function check_user(){

  yum -y install wget

  wget http://licenses.admin5.com/a/b
  liense=`cat ./b`
  if [ $liense -ne '1' ]
  then
    echo -e "Error: Your must not be installed"
    rm ./b
    exit 1
  fi
  rm ./b
  echo -e "Please waiting  , zadmin is starting ......"
}

#close selinux
function disable_selinux(){
  
  sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
  setenforce 0

}

function open_port(){

  /etc/init.d/iptables stop
  /sbin/iptables -I INPUT -p tcp --dport 9999 -j ACCEPT
  /sbin/iptables -I INPUT -p tcp --dport 21 -j ACCEPT
  /sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
  /sbin/iptables -I INPUT -p tcp --dport 35000:50000 -j ACCEPT
  /etc/rc.d/init.d/iptables save 
  /etc/init.d/iptables restart

}

#卸载本机原有自带服务
function remove_old(){

  rpm -e httpd
  rpm -e mysql
  rpm -e php

  yum -y remove httpd
  yum -y remove php
  yum -y remove mysql-server mysql mysql*
  yum -y remove php-mysql
  yum -y remove pure-ftpd


}


#获取系统发行版本号and系统架构and安装环境fodera-epel
function get_release(){

  var=`cat /etc/issue`
  release=`echo $var | awk -F '.' '{print $1}' | awk -F ' ' '{print $NF}'`
  
  #判断Centos/Redhat/Aliyun
  temp=`echo $var | awk -F ' ' '{print $1}'`
  
  
  osbit=`getconf LONG_BIT`
  os=${release}"_"${osbit}

  if [ "$temp" == "Aliyun" ];then
    
    rpm -Uvh http://dl2.admin5.com/redhat/${os}/yum-metadata-parser.rpm
    rpm -Uvh http://dl2.admin5.com/redhat/${os}/yum.centos.noarch.rpm http://dl2.admin5.com/redhat/${os}/yum-fastestmirror.centos.noarch.rpm
    wget http://dl2.admin5.com/redhat/${os}/CentOS-Base.repo
    mv -f CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
    
  fi

  
  if [ "$temp" == "Red" ];then
    
    rpm -Uvh http://dl2.admin5.com/redhat/${os}/yum-metadata-parser.rpm
    rpm -Uvh http://dl2.admin5.com/redhat/${os}/yum.centos.noarch.rpm http://dl2.admin5.com/redhat/${os}/yum-fastestmirror.centos.noarch.rpm
    wget http://dl2.admin5.com/redhat/${os}/CentOS-Base.repo
    mv CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
    
  fi
  
#  yum makecache
#  yum -y install redhat-release
#  rpm -Uvh http://dl2.admin5.com/fedora-epel/epel-release-${os}.noarch.rpm
#  yum makecache
  wget http://dl2.admin5.com/fedora-epel/epel-${os}.repo
  mv -f epel-${os}.repo /etc/yum.repos.d/fedora-epel.repo
  yum makecache
  yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libmcrypt-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 unzip bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers patch zip unzip pcre-devel readline-devel mhash perl-DBI perl-devel libevent memcached mcrypt mhash-devel libtool-ltdl-devel pcre pcre-devel vixie-cron crontabs 
  chkconfig memcached on
  service memcached start
}

#获取zadminrpm�?
function install_zadmin(){

  rm /etc/init.d/mysql* -f
  rm /usr/bin/my* -f
  rm /etc/ld.so.conf.d/mysql* -f
  #os=${osbit}"_"${p_release}
  wget http://dl2.admin5.com/libiconv-1.14.tar.gz
  tar -zxvf libiconv-1.14.tar.gz
  cd libiconv-1.14 && ./configure && make && make install && cd ${curdir}
  rm -rf libiconv-*
  rpm -Uvh http://dl2.admin5.com/zadmin/2.x.x/zadmin-2.1.3-1.${os}.rpm --nodeps
  echo "/a/apps/mysql-5.1.73/lib/mysql/" > /etc/ld.so.conf.d/mysql-5.1.conf
  ldconfig
  service mysqld start
  service nginx start  
  service php-fpm start
  service zadmin start
  service zhujibao start
  service pure-ftpd start
  
}

#配置mysql和主机宝密码
function modity_sql_z_passwd(){
  a=`cat /dev/urandom | head -1 | md5sum | head -c 8`
  sed -i "s/7bfc40ad/${a}/g" /a/apps/pure-ftpd/etc/pureftpd-mysql.conf
  modity_sql="SET PASSWORD FOR 'mysqlftp'@'localhost' = PASSWORD('${a}');"
  /a/apps/mysql-5.1.73/bin/mysql -u root -padmin5os zadmin -e "${modity_sql}"
  service pure-ftpd restart

  b=`cat /dev/urandom | head -1 | md5sum | head -c 8`  
  modity_sql_z="update zadmin.admin set password=md5('${b}') where id=1;SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${b}');"
  /a/apps/mysql-5.1.73/bin/mysql -u root -padmin5os zadmin -e "${modity_sql_z}"
  sed -i "s/admin5os/${b}/g" /a/apps/zhujibao/manager/apps/config/mysql.ini  
}




#设置zadmin开机启�?
function auto_start(){

  chkconfig  mysqld on
  chkconfig  nginx on
  chkconfig  zadmin on
  chkconfig  php-fpm on
  chkconfig  zhujibao on
  chkconfig  pure-ftpd on
  echo "/a/apps/zhujibao/scripts/check.sh" >> /etc/rc.local
  /a/apps/zhujibao/scripts/check.sh&
}

check_user
disable_selinux
open_port
remove_old
get_release
install_zadmin
auto_start
modity_sql_z_passwd

echo
echo " ========== Zhujibao install is finished ===="
echo "            Manager URL: http://ip:9999"
echo "            Username:admin Password: ${b}  "
echo " ========== Power By z.admin5.com ==========="
echo

# log -will
# 2014-7-1 change fedora-epel
# 2014-7-22 add crontabs

