#!/bin/bash
VERSION="3.5.7"
if test $# != 1;then
        echo "Usage: $0 dir"
        exit 1;
fi
PREFIX="/vhs/kangle"
ARCH="-6"
if test `ldd --version|head -1|awk '{print $NF;}'` = "2.5" ; then
        ARCH="-5"
fi
if test `arch` = "x86_64"; then
        ARCH="$ARCH-x64"
fi
URL="http://github.itzmx.com/1265578519/kangle/master/ent/kangle-ent-$VERSION$ARCH.tar.gz"
wget $URL -O kangle.tar.gz
tar xzf kangle.tar.gz
cd kangle
$PREFIX/bin/kangle -q
sleep 3
killall -9 kangle
sleep 3
yum -y install wget;wget http://github.itzmx.com/1265578519/kangle/master/ent/license/Ultimate/license.txt -O $PREFIX/license.txt
./install.sh $PREFIX
$PREFIX/bin/kangle
/vhs/kangle/bin/kangle -q
/vhs/kangle/bin/kangle
clear
echo "Kangle商业版本安装成功-VPSPS.COM";