#!/bin/bash
# Copyright (C) 2015 AppexNetworks
# Author:	Len
# Date:		Aug, 2015

export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"

ROOT_PATH=/serverspeeder
SHELL_NAME=serverSpeeder.sh
PRODUCT_NAME=ServerSpeeder
PRODUCT_ID=serverSpeeder
host=dl.serverspeeder.com

[ -w / ] || {
	echo "You are not running $PRODUCT_NAME Installer as root. Please rerun as root"
	exit 1
}

if [ $# -ge 1 -a "$1" == "uninstall" ]; then
	acceExists=$(ls $ROOT_PATH/bin/acce* 2>/dev/null)
    [ -z "$acceExists" ] && {
        echo "$PRODUCT_NAME is not installed!"
        exit
    }
    $ROOT_PATH/bin/$SHELL_NAME uninstall
    exit
fi

# Locate which
WHICH=`which ls 2>/dev/null`
[ $? -gt 0 ] && {
	echo '"which" not found, please install "which" using "yum install which" or "apt-get install which" according to your linux distribution'
	exit 1
}

IPCS=`which ipcs 2>/dev/null`
[  $? -eq 0 ] && {
    maxSegSize=`ipcs -l | awk -F= '/max seg size/ {print $2}'`
    maxTotalSharedMem=`ipcs -l | awk -F= '/max total shared memory/ {print $2}'`
    [ $maxSegSize -eq 0 -o $maxTotalSharedMem -eq 0 ] && {
        echo "$PRODUCT_NAME needs to use shared memory, please configure the shared memory according to the following link: "
        echo "http://$host/user.do?m=qa#4.4"
        exit 1
    }
}

addStartUpLink() {
	grep -E "CentOS|Fedora|Red.Hat" /etc/issue >/dev/null
	[ $? -eq 0 ] && {
		ln -sf $ROOT_PATH/bin/$SHELL_NAME /etc/rc.d/init.d/$PRODUCT_ID
		[ -z "$boot" -o "$boot" = "n" ] && return
		CHKCONFIG=`which chkconfig`
		if [ -n "$CHKCONFIG" ]; then
			chkconfig --add $PRODUCT_ID >/dev/null
		else
			ln -sf /etc/rc.d/init.d/$PRODUCT_ID /etc/rc.d/rc2.d/S20$PRODUCT_ID
			ln -sf /etc/rc.d/init.d/$PRODUCT_ID /etc/rc.d/rc3.d/S20$PRODUCT_ID
			ln -sf /etc/rc.d/init.d/$PRODUCT_ID /etc/rc.d/rc4.d/S20$PRODUCT_ID
			ln -sf /etc/rc.d/init.d/$PRODUCT_ID /etc/rc.d/rc5.d/S20$PRODUCT_ID
		fi
	}
	grep "SUSE" /etc/issue >/dev/null
	[ $? -eq 0 ] && {
		ln -sf $ROOT_PATH/bin/$SHELL_NAME /etc/rc.d/$PRODUCT_ID
		[ -z "$boot" -o "$boot" = "n" ] && return
		CHKCONFIG=`which chkconfig`
		if [ -n "$CHKCONFIG" ]; then
			chkconfig --add $PRODUCT_ID >/dev/null
		else
			ln -sf /etc/rc.d/$PRODUCT_ID /etc/rc.d/rc2.d/S06$PRODUCT_ID
			ln -sf /etc/rc.d/$PRODUCT_ID /etc/rc.d/rc3.d/S06$PRODUCT_ID
			ln -sf /etc/rc.d/$PRODUCT_ID /etc/rc.d/rc5.d/S06$PRODUCT_ID
		fi
	}
	grep -E "Ubuntu|Debian" /etc/issue >/dev/null
	[ $? -eq 0 ] && {
		ln -sf $ROOT_PATH/bin/$SHELL_NAME /etc/init.d/$PRODUCT_ID
		[ -z "$boot" -o "$boot" = "n" ] && return 
		ln -sf /etc/init.d/$PRODUCT_ID /etc/rc2.d/S03$PRODUCT_ID
		ln -sf /etc/init.d/$PRODUCT_ID /etc/rc3.d/S03$PRODUCT_ID
		ln -sf /etc/init.d/$PRODUCT_ID /etc/rc5.d/S03$PRODUCT_ID
	}
	ln -sf $ROOT_PATH/etc/config /etc/$PRODUCT_ID.conf
}

[ -d $ROOT_PATH/bin ] || mkdir -p $ROOT_PATH/bin
[ -d $ROOT_PATH/etc ] || mkdir -p $ROOT_PATH/etc
[ -d $ROOT_PATH/log ] || mkdir -p $ROOT_PATH/log
cd $(dirname $0)
dt=`date +%Y-%m-%d_%H-%M-%S`
[ -f $ROOT_PATH/etc/config ] && mv -f $ROOT_PATH/etc/config $ROOT_PATH/etc/.config_$dt.bak

cp -f apxfiles/bin/* $ROOT_PATH/bin/
cp -f apxfiles/etc/* $ROOT_PATH/etc/
chmod +x $ROOT_PATH/bin/*

[ -f $ROOT_PATH/etc/.config_$dt.bak ] && {
	while read _line; do
		item=$(echo $_line | awk -F= '/^[^#]/ {print $1}')
		val=$(echo $_line | awk -F= '/^[^#]/ {print $2}' | sed 's#\/#\\\/#g')
		[ -n "$item" -a "$item" != "accpath" -a "$item" != "apxexe" -a "$item" != "apxlic" -a "$item" != "installerID" -a "$item" != "email" -a "$item" != "serial" ] && {
			if [ -n "$(grep $item $ROOT_PATH/etc/config)" ]; then
				sed -i "s/^$item=.*/$item=$val/" $ROOT_PATH/etc/config
			else
				sed -i "/^engineNum=.*/a$item=$val" $ROOT_PATH/etc/config
			fi
		}
	done<$ROOT_PATH/etc/.config_$dt.bak
}

[ -f apxfiles/expiredDate ] && {
    echo -n "Expired date: "
    cat apxfiles/expiredDate
    echo
}

echo "Installation done!"
echo
 
# Set acc inf
echo ----
echo You are about to be asked to enter information that will be used by $PRODUCT_NAME,
echo there are several fields and you can leave them blank,
echo 'for all fields there will be a default value.'
echo ----
echo -n "Enter your accelerated interface(s) [eth0]: "
read accif
echo -n "Enter your outbound bandwidth [1000000 kbps]: "
read wankbps
echo -n "Enter your inbound bandwidth [1000000 kbps]: "
read waninkbps

echo -e "\033[30;40;1m"
echo 'Notice:After set shorttRtt-bypass value larger than 0,' 
echo 'it will bypass(not accelerate) all first flow from same 24-bit'
echo 'network segment and the flows with RTT lower than the shortRtt-bypass value'
echo -e "\033[0m"
echo -n "Configure shortRtt-bypass [0 ms]: "
read shortRttMS
[ -z "$shortRttMS" ] || [ -n "${shortRttMS//[0-9]}" ] && shortRttMS=0

[ -n "$accif" ] && sed -i "s/^accif=.*/accif=\"$accif\"/" $ROOT_PATH/etc/config
[ -n "$wankbps" ] && {
	wankbps=$(echo $wankbps | tr -d "[:alpha:][:space:]")
	sed -i "s/^wankbps=.*/wankbps=\"$wankbps\"/" $ROOT_PATH/etc/config
}
[ -n "$waninkbps" ] && {
	waninkbps=$(echo $waninkbps | tr -d "[:alpha:][:space:]")
	sed -i "s/^waninkbps=.*/waninkbps=\"$waninkbps\"/" $ROOT_PATH/etc/config
}
[ -n "$shortRttMS" ] && {
	shortRttMS=$(echo $shortRttMS | tr -d "[:alpha:][:space:]")
	sed -i "s/^shortRttMS=.*/shortRttMS=\"$shortRttMS\"/" $ROOT_PATH/etc/config
}

while [ "$boot" != 'y' -a "$boot" != 'n' -a "$boot" != 'Y' -a "$boot" != 'N'  ]; do
	echo -n "Auto load $PRODUCT_NAME on linux start-up? [n]:"
	read boot
	[ -z "$boot" ] && boot=n
done
[ "$boot" = "N" ] && boot=n 
addStartUpLink

while [ "$startNow" != 'y' -a "$startNow" != 'n' -a "$startNow" != 'Y' -a "$startNow" != 'N'  ]; do
	echo -n "Run $PRODUCT_NAME now? [y]:"
	read startNow
	[ -z "$startNow" ] && startNow=y
done

[ "$startNow" = "y" -o "$startNow" = "Y" ] && {
	$ROOT_PATH/bin/$SHELL_NAME stop >/dev/null 2>&1
	$ROOT_PATH/bin/$SHELL_NAME start 
}