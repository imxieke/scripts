wget http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm 
rpm -ivh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm 
yum -y install aria2

mkdir /etc/aria2/
cat /dev/null > /etc/aria2/aria2.session
wget http://7jps5o.com1.z0.glb.clouddn.com/aria2/conf/aria2.conf -O /etc/aria2/aria2.conf

wget http://7jps5o.com1.z0.glb.clouddn.com/aria2/conf/aria2 -O /etc/init.d/aria2
chmod +x /etc/init.d/aria2
echo "/etc/init.d/aria2 start">> /etc/rc.local
/etc/init.d/aria2 start
iptables -A INPUT -p tcp --dport 6800 -j ACCEPT

#lip = /sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"

echo "================================================="
echo "Aria2 RPC Address : your ip:6800/jsonrpc"
echo "You can access http://aria2.jike.info"
echo "================================================="

git clone https://github.com/ziahamza/webui-aria2
cd webui-aria2
python -m SimpleHTTPServer 9999
