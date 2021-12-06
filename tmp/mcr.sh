#!/bin/bash

echo "Welcome to MoeChecker Installer"

# Install & update system software
yum update -y
yum install epel-release -y
yum install htop wget screen figlet vim gcc libstdc++ python2 python2-pip python36 python36-pip unzip -y
pip3 install requests

# Install PHP
yum install patch gcc glibc libstdc++ binutils libtool autoconf make bison pam-devel libcap-devel openssl-devel tcp_wrappers-devel bzip2-devel curl-devel db4-devel gmp-devel httpd-devel libstdc++-devel sqlite-devel sqlite2-devel liyuybedit-devel pcre-devel libtool gcc-c++ libtool-ltdl-devel libevent-devel libc-client-devel cyrus-sasl-devel openldap-devel mysql-devel postgresql-devel unixODBC-devel libxml2-devel net-snmp-devel libxslt-devel libxml2-devel libjpeg-devel libpng-devel freetype-devel libXpm-devel t1lib-devel libmcrypt-devel libtidy-devel freetds-devel aspell-devel recode-devel enchant-devel firebird-devel gdbm-devel tokyocabinet-devel libsodium libsodium-devel argon2 libargon2 libargon2-devel -y
cd /tmp/
wget https://www.php.net/distributions/php-7.3.8.tar.gz -O php.tar.gz
tar xzvf php.tar.gz
cd php-7.3.8/
./configure '--prefix=/usr/local/php' '--exec-prefix=/usr/local/php' '--bindir=/usr/local/php/bin' '--sbindir=/usr/local/php/sbin' '--includedir=/usr/local/php/include' '--libdir=/usr/local/php/lib/php' '--mandir=/usr/local/php/php/man' '--with-config-file-path=/usr/local/php/etc' '--with-mysql-sock=/var/lib/mysql/mysql.sock' '--with-mcrypt=/usr/include' '--with-mhash' '--with-mysqli=shared,mysqlnd' '--with-pdo-mysql' '--with-gd' '--with-iconv' '--with-zlib' '--enable-inline-optimization' '--disable-debug' '--disable-rpath' '--enable-shared' '--enable-xml' '--enable-bcmath' '--enable-shmop' '--enable-sysvsem' '--enable-mbregex' '--enable-mbstring' '--enable-ftp' '--enable-pcntl' '--enable-sockets' '--with-xmlrpc' '--enable-soap' '--with-pear' '--with-gettext' '--enable-session' '--with-curl' '--with-openssl' '--with-jpeg-dir' '--with-freetype-dir' '--with-mysqli' '--enable-fpm' '--with-fpm-user=www' '--with-fpm-group=www' '--with-gdbm' '--enable-fileinfo' '--enable-maintainer-zts'
make ZEND_EXTRA_LIBS='-liconv' -j 8
make install

# Install Swoole
cd /tmp/
yum install openssl-devel openssl -y
cd ~
wget https://github.com/swoole/swoole-src/archive/v4.4.3.tar.gz -O swoole.tar.gz
tar xzvf swoole.tar.gz
cd swoole-src-4.4.3/
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --enable-coroutine --enable-openssl --enable-http2 --enable-async-redis --enable-sockets --enable-mysqlnd
make clean
make -j 4
make install
echo "extension=swoole.so" >> /usr/local/php/etc/php.ini
/usr/local/php/bin/php -v

# Install backend

cd /usr/local/
wget https://github.com/kasuganosoras/MoeChecker_Backend/raw/master/backend.py
wget http://ip.zerodream.net:81/test.zip
unzip test.zip
wget https://mcr.moe/data/backend.service -O /etc/systemd/system/backend.service
wget https://mcr.moe/data/backend2.service -O /etc/systemd/system/backend2.service
systemctl enable backend --now
systemctl enable backend2 --now

# Install finish
echo "Install finished!"