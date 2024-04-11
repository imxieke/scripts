#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

cd /root/;
rm -rf convert;
wget http://amh52.xyz/files/convert.tar.gz;
tar -zxvf convert.tar.gz;
\cp -a ./convert/web/* /usr/local/amh-5.3/web;
chmod -R 775 /usr/local/amh-5.3/web;
\cp -a ./convert/amh-base /root/amh/conf;
chmod -R 775 /root/amh/conf/amh-base;
\cp -a ./convert/AMHScript /root/amh/modules/amh-5.3;
chmod -R 775 /root/amh/modules/amh-5.3/AMHScript;
rm -rf convert convert.tar.gz;

echo '==========================================================================';
echo '[AMH] Congratulations, AMH 5.3 convert completed.';
echo 'More help please visit:http://amh.sh';
echo '==========================================================================';
