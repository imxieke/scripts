#!/bin/bash
# autoinstall pptpd by script
# code by itybku@139.com < www.361way.com >
# 

# test the kernel can use pptpd
modprobe ppp-compress-18 && echo MPPE is ok

# install soft from epel source
cd /tmp
http://10.212.149.204/soft/epel-release-latest-6.noarch.rpm
rpm -ivh epel-release-latest-6.noarch.rpm
yum clean all
yum -y install ppp pptpd

# bak config file
files='
/etc/sysconfig/iptables
/etc/ppp/options.pptpd
/etc/pptpd.conf
/etc/ppp/chap-secrets
'
for file in $files;do
	cp $file ${file}_`date +%y%m%d`
done


# config /etc/pptpd.conf
cat << EOF > /etc/pptpd.conf
option /etc/ppp/options.pptpd
logwtmp
localip 192.168.100.1
remoteip 192.168.100.100-200
EOF

# config /etc/ppp/options.pptpd
cat << EOF > /etc/ppp/options.pptpd
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 114.114.114.114
ms-dns 8.8.8.8
proxyarp
lock
nobsdcomp
novj
novjccomp
nologfd
EOF


cat << EOF > /etc/ppp/chap-secrets
# client        server  secret                  IP addresses
test       		pptpd  	test123456                    *
EOF

#set the iptables
cat << EOF > /etc/sysconfig/iptables
# Generated by iptables-save
*nat
:PREROUTING ACCEPT [2:120]
:POSTROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A POSTROUTING -s 192.168.100.0/24 -o eth1 -j MASQUERADE 
COMMIT
# Completed on Mon Jan 16 14:57:17 2017
# Generated by iptables-save v1.4.7 on Mon Jan 16 14:57:17 2017
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [23:2180]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 
-A INPUT -p icmp -j ACCEPT 
-A INPUT -p gre -j ACCEPT 
-A INPUT -i lo -j ACCEPT 
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT 
-A INPUT -p tcp -m state --state NEW -m tcp --dport 1723 -j ACCEPT 
-A INPUT -j REJECT --reject-with icmp-host-prohibited 
-A FORWARD  -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK syn -j TCPMSS --set-mss 1356
#-A FORWARD -p tcp -m tcp --syn -s 192.168.100.0/24 -j TCPMSS --set-mss 1356
-A FORWARD -s 192.168.100.0/24 -o eth1 -j ACCEPT 
-A FORWARD -d 192.168.100.0/24 -i eth1 -j ACCEPT 
-A FORWARD -j REJECT --reject-with icmp-host-prohibited 
COMMIT
EOF


sed 's/^net.ipv4.ip_forward/# &/' sysctl.conf 
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p 
chkconfig iptables on
chkconfig pptpd on 
/etc/init.d/iptables restart 
/etc/init.d/pptpd restart-kill
/etc/init.d/pptpd start
