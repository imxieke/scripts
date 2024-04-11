setenforce 0
ulimit -n 1048576
echo "* soft nofile 1048576" >> /etc/security/limits.conf
echo "* hard nofile 1048576" >> /etc/security/limits.conf
echo "alias net-pf-10 off" >> /etc/modprobe.d/dist.conf
echo "alias ipv6 off" >> /etc/modprobe.d/dist.conf
killall sendmail
/etc/init.d/postfix stop
chkconfig --level 2345 postfix off
chkconfig --level 2345 sendmail off
yum -y install squid wget
wget http://ruyo-net-demo.qiniudn.com/centos-squid.conf -O /etc/squid/squid.conf
mkdir -p /var/cache/squid
chmod -R 777 /var/cache/squid
chown -R squid:squid /usr/share/squid
chown -R squid:squid /etc/squid
chown -R squid:squid /var/log/squid
chown -R squid:squid /var/cache/squid
squid -z
service squid restart
chkconfig --level 2345 squid on
vi /etc/squid/squid.conf
