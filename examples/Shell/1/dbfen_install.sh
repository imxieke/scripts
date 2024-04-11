#!/bin/sh
# Any questions, please constact with us by email: support@dbfen.com or QQ:4006005699
#Date:   Feb, 2015

export LANG=C

arch=`getconf LONG_BIT`
install_dir=/usr/local/services/dbfen

[ -w / ] || {
    echo "Run this script with root priviliges!"
    export LANG=$lang
    exit 1
}

error()
{
    echo $2
    echo "error code:$1"
    export LANG=$lang
    exit 1
}

check_env()
{
    CURL=`which curl 2>/dev/null`
    if [ $? -ne 0 ];then
        error -1 "curl is not found, please install curl!"
    fi
    UNZIP=`which unzip 2>/dev/null`
    if [ $? -ne 0 ];then
        error -1 "unzip is not found, please install unzip!"
    fi
}

check_env

if [ $arch -eq 64 ]; then
    url="www.dbfen.com/index.php/help/downclient/linux-generic-x86_64-GLIBC_2.5.zip";
else
    url="www.dbfen.com/index.php/help/downclient/linux-generic-i686-GLIBC_2.5.zip";
fi

curl $url -o /tmp/dbfen.zip
if [ ! -f /tmp/dbfen.zip ];then
    error -2 "download error"
fi

[ -d $install_dir ] || mkdir -p $install_dir 
if [ $? -ne 0 ];then
    error -3 "cannot mkdir, please check you are root"
fi

unzip -o /tmp/dbfen.zip -d $install_dir
if [ $? -ne 0 ];then
    error -4 "decompress error!! Maybe download error package!"
fi

chmod +x $install_dir/startdbfen $install_dir/dbfensrv

ldisk=`df -l -P | grep "/" | sort -n -k4,4 -r | grep -vE "none|udev|tmpfs|none|boot" | awk '{print $NF}' `
DumpDir="/usr/local/services/dbfen/DBCache/"
for dir in $ldisk
do
    [ -w $dir ] || continue
    if [ "X/" != "X$dir" ];then
        DumpDir=$dir"/DBCache/"
        break
    fi
done

echo ""
echo "安装成功"
echo ""

if [ -f $install_dir/profiles/dbfen.ini ];then
	echo "==============================================================================================="
	echo "可通过浏览器管理和监控本系统运行参数, 其配置管理地址为：http://本机IP:40000/view/index.html 。"
	echo ""
	echo "执行${install_dir}/startdbfen 可启动服务"
	echo "==============================================================================================="
else
    echo "[Database]
DumpDir=$DumpDir" >> $install_dir/profiles/dbfen.ini

	echo "==============================================================================================="
	echo "可通过浏览器管理和监控本系统运行参数, 其配置管理地址为：http://本机IP:40000/view/index.html 。"
	echo ""
	echo "执行${install_dir}/startdbfen 可启动服务"
	echo "==============================================================================================="
fi

exit 0