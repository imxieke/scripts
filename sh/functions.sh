#!/usr/bin/env bash
# @Author: imxieke
# @Date:   2021-09-29 21:34:58
# @Last Modified by:   imxieke
# @Last Modified time: 2021-11-13 23:05:13

# 字符转大写
strtoupper()
{
	echo $1 | tr '[a-z]' '[A-Z]'
}

# 字符转小写
strtolower()
{
	echo $1 | tr '[A-Z]' '[a-z]'
}

# 字符大小写反转
strtolower()
{
	echo $1 |tr '[a-zA-Z]' '[A-Za-z]'
}


random_string(){
    length=${1:-32}
    echo `cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${length} | head -n 1`
}

# 终结包管理器运行 先提示 避免正在执行安装丢失数据
kill_apt()
{
    if ps aux | grep -E "apt-get|dpkg|apt" | grep -qv "grep"; then
        kill -9 $(ps -ef|grep -E "apt-get|apt|dpkg"|grep -v grep|awk '{print $2}')
        if [[ -s /var/lib/dpkg/lock-frontend || -s /var/lib/dpkg/lock ]]; then
            rm -f /var/lib/dpkg/lock-frontend
            rm -f /var/lib/dpkg/lock
            dpkg --configure -a
        fi
    fi
}

Auto_Swap()
{
    swap=$(free |grep Swap|awk '{print $2}')
    if [ "${swap}" -gt 1 ];then
        echo "Swap total sizse: $swap";
        return;
    fi
    if [ ! -d /www ];then
        mkdir /www
    fi
    swapFile="/www/swap"
    dd if=/dev/zero of=$swapFile bs=1M count=1025
    mkswap -f $swapFile
    swapon $swapFile
    echo "$swapFile    swap    swap    defaults    0 0" >> /etc/fstab
    swap=`free |grep Swap|awk '{print $2}'`
    if [ $swap -gt 1 ];then
        echo "Swap total sizse: $swap";
        return;
    fi
    
    sed -i "/\/www\/swap/d" /etc/fstab
    rm -f $swapFile
}

sys_init()
{
    # 初始化系统环境
    if [[ -n "$(grep `whoami` /etc/passwd | grep 'zsh$')" ]]; then
        USER_SHELL='zsh'
    elif [[ -n "$(grep `whoami` /etc/passwd | grep 'bash$')" ]]; then
        USER_SHELL='bash'
    fi
    USER_SHELL_BIN=$(command -v "${USER_SHELL}")

    # 设置时区

    if [[ -f '/etc/timezone' ]]; then
        if [[ "$(cat /etc/timezone)" != "${TIMEZONE}" ]]; then
            rm -fr /etc/localtime
            ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
        fi
    else
        apt install --no-install-recommends tzdata locales
        rm -fr /etc/localtime
        ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
    fi
	ntpdate -u pool.ntp.org
	#尝试同步国际时间(从ntp服务器)
	ntpdate 0.asia.pool.ntp.org
	ntpdate -d cn.pool.ntp.org
}

get_os_name()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun Linux" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Amazon Linux" /etc/issue || grep -Eq "Amazon Linux" /etc/*-release; then
        DISTRO='Amazon'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Oracle Linux" /etc/issue || grep -Eq "Oracle Linux" /etc/*-release; then
        DISTRO='Oracle'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux" /etc/issue || grep -Eq "Red Hat Enterprise Linux" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    elif grep -Eqi "Deepin" /etc/issue || grep -Eq "Deepin" /etc/*-release; then
        DISTRO='Deepin'
        PM='apt'
    elif grep -Eqi "Mint" /etc/issue || grep -Eq "Mint" /etc/*-release; then
        DISTRO='Mint'
        PM='apt'
    elif grep -Eqi "Kali" /etc/issue || grep -Eq "Kali" /etc/*-release; then
        DISTRO='Kali'
        PM='apt'
    else
        DISTRO='unknow'
    fi
}

Add_Swap()
{
    if ! command -v python >/dev/null 2>&1; then
        if [ "$PM" = "yum" ]; then
            yum -y install python2
        elif [ "$PM" = "apt" ]; then
            apt-get --no-install-recommends install -y python
        fi
    fi
    if command -v python >/dev/null 2>&1; then
        Disk_Avail=$(python ${cur_dir}/include/disk.py)
    elif command -v python3 >/dev/null 2>&1; then
        Disk_Avail=$(python3 ${cur_dir}/include/disk.py)
    elif command -v python2 >/dev/null 2>&1; then
        Disk_Avail=$(python2 ${cur_dir}/include/disk.py)
    fi
    if [ "${MemTotal}" -lt 1024 ]; then
        DD_Count='1024'
        if [ "${Disk_Avail}" -lt 5 ]; then
            Enable_Swap='n'
        fi
    elif [[ "${MemTotal}" -ge 1024 && "${MemTotal}" -le 2048 ]]; then
        DD_Count='2028'
        if [ "${Disk_Avail}" -lt 13 ]; then
            Enable_Swap='n'
        fi
    elif [[ "${MemTotal}" -ge 2048 && "${MemTotal}" -le 4096 ]]; then
        DD_Count='4096'
        if [ "${Disk_Avail}" -lt 17 ]; then
            Enable_Swap='n'
        fi
    elif [[ "${MemTotal}" -ge 4096 && "${MemTotal}" -le 16384 ]]; then
        DD_Count='8192'
        if [ "${Disk_Avail}" -lt 19 ]; then
            Enable_Swap='n'
        fi
    elif [[ "${MemTotal}" -ge 16384 ]]; then
        DD_Count='8192'
        if [ "${Disk_Avail}" -lt 27 ]; then
            Enable_Swap='n'
        fi
    fi
    Swap_Total=$(free -m | grep Swap | awk '{print  $2}')
    if [[ "${Enable_Swap}" = "y" && "${Swap_Total}" -le 512 && ! -s /var/swapfile ]]; then
        echo "Add Swap file..."
        [ $(cat /proc/sys/vm/swappiness) -eq 0 ] && sysctl vm.swappiness=10
        dd if=/dev/zero of=/var/swapfile bs=1M count=${DD_Count}
        chmod 0600 /var/swapfile
        echo "Enable Swap..."
        /sbin/mkswap /var/swapfile
        /sbin/swapon /var/swapfile
        if [ $? -eq 0 ]; then
            [ `grep -L '/var/swapfile'    '/etc/fstab'` ] && echo "/var/swapfile swap swap defaults 0 0" >>/etc/fstab
            /sbin/swapon -s
        else
            rm -f /var/swapfile
            echo "Add Swap Failed!"
        fi
    fi
}

_remove_basedir_restrict()
{
    while :;do
        read -p "Enter website root directory: " website_root
        if [ -d "${website_root}" ]; then
            if [ -f ${website_root}/.user.ini ];then
                chattr -i ${website_root}/.user.ini
                rm -f ${website_root}/.user.ini
                sed -i 's/^fastcgi_param PHP_ADMIN_VALUE/#fastcgi_param PHP_ADMIN_VALUE/g' /usr/local/nginx/conf/fastcgi.conf
                /etc/init.d/php-fpm restart
                /etc/init.d/nginx reload
                echo "done."
            else
                echo "${website_root}/.user.ini is not exist!"
            fi
            break
        else
            echo "${website_root} is not directory or not exist!"
        fi
    done
}

add_swap()
{
	if [ -z "$(grep 'swap' /etc/fstab)" ] && [ "${Swap}" == '0' ] && [ ${Mem} -le 2048 ]; then
	  echo "${CWARNING}Add Swap file, It may take a few minutes... ${CEND}"
	  dd if=/dev/zero of=/swapfile count=2048 bs=1M
	  mkswap /swapfile
	  swapon /swapfile
	  chmod 600 /swapfile
	  [ -z "`grep swapfile /etc/fstab`" ] && echo '/swapfile    swap    swap    defaults    0 0' >> /etc/fstab
	fi
}

check_502()
{
	CheckURL="http://www.xxx.com"

	STATUS_CODE=`curl -o /dev/null -m 10 --connect-timeout 10 -s -w %{http_code} $CheckURL`
	#echo "$CheckURL Status Code:\t$STATUS_CODE"
	if [ "$STATUS_CODE" = "502" ]; then
	    /etc/init.d/php-fpm restart
	fi
}