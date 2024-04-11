#!/usr/bin/env bash

export PATH='/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/root/bin:/root/.bin'
# Ubuntu Onkey Tools
# Author: Cloudflying
# Time: Mon Apr 1 2019 17:59

# ReSet PATH
if [[ "$(uname -s)" == 'Darwin'  ]]; then
	PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:/usr/local/opt/mysql-client/bin
elif [[ "$(uname -s )" == 'Linux' ]]; then
	PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:~/.bin
fi

# Define Version
VERSION='0.1.1'

# echo ${red} "Hello" ${resetColor}
red=$'\e[01;31m'
green=$'\e[01;32m'
yellow=$'\e[01;33m'
blue=$'\e[01;34m'
magenta=$'\e[01;35m'
resetColor=$'\e[0m'

ARCH=$(uname -m)
CODENAME=$(cat /etc/os-release | grep '^VERSION_CODENAME' | awk -F '=' '{print $2}')
VERSION_ID_SHORT=$(grep 'VERSION_ID' /etc/os-release  | awk -F '"' '{print $2}' | awk -F '.' '{print $1}')

# COUNTRY_CODE=$(curl -sL https://api.xie.ke/api/ip/country)

# check env for depends
_env_check()
{
	if [[ "$(id -u)" != 0 ]]; then
		echo 'super user please'
		exit 1
	fi

	# if [[ -z $(command -v curl) ]]; then
		# spt curl
	# fi
}

# 设置环境变量
_env()
{
    COUNTRY=$(curl -sL https://api.xie.ke/api/ip/country)
}

# depency only , for os normal running
# neovim neofetch need Ubuntu 20
_baseenv()
{
	# dpkg depency
	# if [[ -z $(command -v less) ]]; then
	# 	spt less
	# fi
	# for pkg in ${PKGS} ; do
	# 	if [[ -z $(dpkg -l | awk -F ' ' '{print $2}' | grep -v '^Name$' | grep -v '^Err?' | grep -v '^Status=' | grep "^${pkg}$") ]]; then
	# 		echo "Package: " ${pkg} "Not Install !"
	# 		echo "=> Install " ${pkg}
	# 		spt ${pkg}
	# 	fi
	# done
	echo "All Done"
	install_ohmyzsh
}


# Personal daily use environment
_fullenv()
{
	if [[ "${VERSION_ID_SHORT}" -gt 20 ]]; then
		spt neovim
	fi

	PKGS='less'
	for pkg in ${PKGS} ; do
		if [[ -z $(dpkg -l | awk -F ' ' '{print $2}' | grep -v '^Name$' | grep -v '^Err?' | grep -v '^Status=' | grep "^${pkg}$") ]]; then
			echo "Package: " ${pkg} "Not Install !"
			echo "=> Install " ${pkg}
			spt ${pkg}
		fi
	done
}

_macenv()
{
	brew install mas
}

# Dev environment
_devenv()
{
	spt automake autoconf build-essential ca-certificates curl wget jq htop neovim gcc g++ make cmake python python3 python-pip \
	python3-pip libssl-dev libjpeg-dev libpng-dev libreadline7 libreadlinedev pkg-config autoconf automake libxml2-dev
}

iotest()
{
	dd if=/dev/zero of=/tmp/ramdisk/zero bs=4k count=10000 # Write
	dd if=/tmp/ramdisk/zero of=/dev/null bs=4k count=10000 # Read
}

ramdisk()
{
	# Mount Folder
	mkdir /tmp/ramdisk
	mount -t tmpfs -o size=1024m ramdisk /tmp/ramdisk
	# in /etc/fstab x-gvfs-show is for show in explorer
	ramdisk  /tmp/ramdisk  tmpfs  defaults,size=1G,x-gvfs-show  0  0
}

ubuntu_repo()
{
	add-apt-repository ppa:nginx/stable
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

}

set_gitconfig()
{
    if [[ -n "$(command -v git)" ]]; then
        git config --global core.fileMode false
        git config --global user.name 'imxieke'
        git config --global user.email 'oss@live.hk'
        git config --global author.name 'imxieke'
        git config --global author.email 'oss@live.hk'
        git config --global color.ui always
        echo '==> set git config completed'
    fi
}

ubuntu_env()
{
	# add-apt-repository
	apt-get install python-software-properties software-properties-common -y
	# wget https://github.com/git/git/archive/master.zip && unzip master.zip
	# cd git-master && make && make install && make clean && ln -s /usr/local/bin/git /usr/bin/git 
	# echo $(git version)
}

set_localtime()
{
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

# Huawei Cloud
is_huaweicloud()
{
	if [[ -z  $(grep 4000-955-988 /etc/motd) ]]; then
		echo 'false'
	else
		echo "true"
	fi
}

# Aliyun
is_alicloud()
{
	if [[ -z $(grep Alibaba /etc/motd) ]]; then
		echo 'false'
	else
		echo "true"
	fi
}

now_user()
{
	echo `whoami`;
}

check_user()
{
	if [[ $(id -u) != 0 ]]; then
		echo "Not Permission, Need Root User";
	fi
}
# Debian CentOS Fedora Arch-like Alpine
get_os()
{
	OS_NAME=""
	OS_RELEASE=""
	OS_CODENAME=""

	# Ubuntu/Linux Mint Deepin manjaroLinux etc ...
	if [[ -f '/usr/bin/lsb_releases' ]]; then
		OS_NAME=$(lsb_release -si)
		OS_RELEASE=$(lsb_release -sr)
		OS_CODENAME=$(lsb_release -sc)
	# Ubuntu
	elif [[ $(grep Ubuntu /etc/os-release) ]]; then
		OS_NAME="ubuntu"
		OS_RELEASE=$(grep VERSION_ID /etc/os-release  | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
		OS_CODENAME=$(grep VERSION_CODENAME= /etc/os-release | awk -F '=' '{print $2}')	
	# Debian
	elif [[ $(grep Debian /etc/os-release) ]]; then
		OS_NAME="debian"
		OS_RELEASE=$(grep VERSION_ID /etc/os-release  | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
		OS_CODENAME=$(grep VERSION= /etc/os-release | awk -F '(' '{print $2}' | awk -F ')' '{print $1}')
	# CentOS/Fedora/RHEL
	elif [[ $(grep PRETTY_NAME /etc/os-release | grep CentOS) ]]; then
		OS_NAME="centos"
		OS_RELEASE=$(grep VERSION_ID /etc/os-release  | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
	# Fedora
	elif [[ $(grep Fedora /etc/os-release) ]]; then
		OS_NAME="fedora"
		OS_RELEASE=$(grep VERSION_ID /etc/os-release  | awk -F '=' '{print $2}')
	# Archlinux and distributed version base archlinux etc..
	elif [ -f /usr/bin/pacman ]; then
		OS_NAME="arch"
		OS_RELEASE='Rolling'
	# openSUSE
	elif [[ $(grep openSUSE /etc/os-release) ]]; then
		OS_NAME="opensuse"
		OS_RELEASE=$(grep VERSION_ID /etc/os-release  | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
		OS_CODENAME=$(grep PRETTY_NAME /etc/os-release | awk -F '"' '{print $2}' | awk -F ' ' '{print $2}')
	# #Alpine Alpine Edge
	# VERSION_ID=3.10_alpha20190228
	# PRETTY_NAME="Alpine Linux edge"
	elif [ $(grep Alpine /etc/os-release) ]; then
		OS_NAME="alpine"
		OS_RELEASE=$(grep VERSION_ID /etc/os-release  | awk -F '=' '{print $2}')
	else
		OS_NAME=""
	fi
	echo ${OS_NAME}
}

OS_NAME=$(get_os)

sysinfo()
{
	if [[ ! -z $(free -h  | grep Swap) ]]; then
		swap=$(free -h  | grep Swap | awk -F ' ' '{ print $2}')
	else
		swap='0'
	fi
	if [[ -n "$(command -v dpkg)" ]]; then
		ARCH=$(dpkg --print-architecture)
	elif [[ -n "$(command -v uname)" ]]; then
		ARCH=$(uname -m)
	else
		ARCH=$(getconf LONG_BIT)
	fi
	totalRam=$(free -h | grep Mem | awk -F ' ' '{print $2}')
	usedRam=$(free -h | grep Mem | awk -F ' ' '{print $3}')
	freeRam=$(free -h | grep Mem | awk -F ' ' '{print $4}')
	shareedRam=$(free -h | grep Mem | awk -F ' ' '{print $5}')
	bufferRam=$(free -h | grep Mem | awk -F ' ' '{print $6}')
	avaiRam=$(free -h | grep Mem | awk -F ' ' '{print $7}')
	diskSize=$(df -h | grep -v tmpfs | grep -v \ /dev | grep dev | awk -F ' ' '{print $2}')
	diskUsed=$(df -h | grep -v tmpfs | grep -v \ /dev | grep dev | awk -F ' ' '{print $3}')
	diskFree=$(df -h | grep -v tmpfs | grep -v \ /dev | grep dev | awk -F ' ' '{print $4}')
	diskPersentage=$(df -h | grep -v tmpfs | grep -v \ /dev | grep dev | awk -F ' ' '{print $5}')
	hostname=$(hostname)
	osname=$(grep PRETTY_NAME /etc/os-release | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
	cores=$(grep processor /proc/cpuinfo | wc -l)
	cpu=$(grep model\ name /proc/cpuinfo | uniq | awk -F ':' '{print $2}')
	echo "	System Base Info

OS 	: ${osname} ${ARCH}
Kernel	: $(uname -r)
CPU 	:${cpu} 
Core 	: ${cores}
Swap 	: ${swap}
Ram 	: ${usedRam} / ${freeRam} / ${totalRam}	Used / Free /Total
Disk 	: ${diskUsed} / ${diskFree} / ${diskSize} Used / Free /Total
"
}

# Install Bt Panel
install_btpanel()
{
	MANODE='download.bt.cn'		# Master (China)
	GDNODE='125.88.182.172:5880' # GuangDong
	HKNODE='103.224.251.67:5880' # HongKong
	USNODE='128.1.164.196:5880'  # USA
	if [[ ${OS_NAME} == 'ubuntu' ]]; then
		wget -O install.sh http://${MANODE}/install/install-ubuntu_6.0.sh && bash install.sh
	elif [[ ${OS_NAME} == 'centos' ]]; then
		wget -O install.sh http://${MANODE}/install/install_6.0.sh && sh install.sh
	elif [[ ${OS_NAME} == 'debian' ]]; then
		wget -O install.sh http://${MANODE}/install/install-ubuntu_6.0.sh && bash install.sh
	elif [[ ${OS_NAME} == 'fedora' ]]; then
		wget -O install.sh http://${MANODE}/install/install_6.0.sh && bash install.sh
	fi
}

install_ohmyzsh()
{
    if [[ ! -f ~/.zshrc ]];then
        if [[ "$COUNTRY" == 'CN' ]]; then
            git clone --depth 1 https://gitee.com/mirr/oh-my-zsh.git ~/.oh-my-zsh
        else
            git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
        fi

        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
        sed -i 's/ZSH_THEME.*/ZSH_THEME="strug"/g' ~/.zshrc
        chsh -s "$(command -v zsh)"
        zsh
    fi
}

# For New Server Init
init_server()
{
	apt upgrade
	apt autoremove
}

# For New Server Init With BT Panel
init_server_with_bt()
{
	init_server
	install_btpanel
}

apt_mirrors()
{
	if [[ "${COUNTRY}" == '' ]]; then
		COUNTRY='CN'
	fi

    if [[ "${COUNTRY}" == 'CN' ]]; then
    	sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
    	# sed -i 's/http.*.\/ubuntu\//http:\/\/mirrors.aliyun.com\/ubuntu\//g' /etc/apt/sources.list
    fi
}

# https://docker.mirrors.ustc.edu.cn/
# http://f1361db2.m.daocloud.io
# http://hub-mirror.c.163.com/
docker_mirrors()
{
	FILE='/etc/docker/daemon.json';

	if [[ ! -f ${FILE} ]]; then
		echo "{
  \"registry-mirrors\": [\"https://kfwkfulq.mirror.aliyuncs.com\"]
}" > ${FILE}
	else
		nowMirrors=`grep registry-mirrors ${FILE} | awk -F '[' '{print $2}' | awk -F ']' '{print $1}'`
		sed -i 's/${nowMirrors}/https\:\/\/kfwkfulq.mirror.aliyuncs.com/g' demo.md
	fi
}

# Unset composer config -g --unset repos.packagist
composer_mirrors()
{
	MIRRORS='https://packagist.laravel-china.org';
	echo "Now: " $(grep url ~/.config/composer/config.json | awk -F '"' '{print $4}');
	echo "New: " ${MIRRORS};
	composer config -g repo.packagist composer ${MIRRORS};
}

pip_mirrors()
{
	if [[ ! -f "${HOME}/.pip/pip.conf" ]]; then
		mkdir -p ${HOME}/.pip
		touch ${HOME}/.pip/pip.conf
		echo "[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com" > ${HOME}/.pip/pip.conf
	fi
}

npm_mirrors()
{
	npm config set registry http://registry.npm.taobao.org/
	# npm config set registry https://registry.npmjs.org/
}

# Shell Package Tool
spt()
{
	if [[ ${OS_NAME} == 'ubuntu' ]]; then
		apt install -y --no-install-recommends $*
	elif [[ ${OS_NAME} == 'arch' ]]; then
		pacman -S --noconfirm $1
	elif [[ ${OS_NAME} == 'centos' ]]; then
		yum install -y $1
	fi
}

install_ubuntu_desktop()
{
	apt install --no-install-recommends ubuntu-desktop
}

install_docker()
{
	COUNTRY=$(curl -sL https://apiset.top/api/ip/country)
	if [[ ${COUNTRY } == 'CN' ]]; then
		curl -sSL https://get.daocloud.io/docker | sh
	else
		curl -sL https://get.docker.com | sh
	fi
}

# set neovim default config
set_neovim()
{
    mkdir -p ~/.config/nvim
    echo "syntax on
set number
set nobackup
set fenc=utf-8
set encoding=utf-8
set cursorline
set cursorcolumn
set title
set emoji
set tabstop=4
set autoindent smartindent
    " > ~/.config/nvim/init.vim
}

rsync()
{
	rsync --archive --verbose --compress --recursive --copy-links --times --owner --group --perms --times --progress
}

about()
{
	echo "######################################"
	echo "# Warning:The Script Suitable ubuntu!#"
	echo "# Author: Xiekers <im@xieke.org>     #"
	echo "# time: Sunday Aug 23 2016 2:37      #"
	echo "######################################"
}

usage()
{
	echo "	Easy Env 
		- Easy To Config You Environment

Usage: easyenv [options...] 
Command:
  --set-docker 	Set Docker Mirrors
  --toolbox 	Install Tool for everyday used
			v.${VERSION}
	"
}

_init()
{
	apt_mirrors
	apt update -y
	_env_check
	_baseenv
}
# _init
_env_check
# get_os
# docker_mirrors
# composer_mirrors

case $1 in
	help )
		help
		;;
	about )
		about
		;;
	fullenv )
		_fullenv
		;;
	baseenv )
		_baseenv
		;;
	devenv )
		_devenv
		;;
	sysinfo )
		sysinfo
		;;
	install )
		[ -n "$(command -v install_$2)" ] && install_$2
		;;
	init )
		_init
		;;
	init-server )
		init_server
		;;
	init-server-with-bt )
		init_server_with_bt
		;;
	apt-mirrors)
		apt_mirrors
		;;
	btpanel)
		install_btpanel
		;;
	* )
		usage
		;;
esac
