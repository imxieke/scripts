#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-12-06 13:52:13
 # @LastEditTime: 2021-12-06 17:43:23
 # @LastEditors: Cloudflying
 # @Description: Upgrade debian os version
 # @FilePath: /scripts/sh/debian-upgrade-os-version.sh
### 

if [[ "$(grep '^ID=' /etc/os-release | awk -F '=' '{print $2}')" != 'debian' ]]; then
    echo 'sorry only for debian'
    exit 1
fi

if [ "$(id -u)" != 0 ];then
    echo 'use root user please'
    exit 1
fi

# debian > 9 have CODENAME
CODENAME=$(grep '^VERSION_CODENAME=' /etc/os-release | awk -F '=' '{print $2}')
DEBIAN_VERSION_SHORT=$(cat /etc/debian_version | awk -F '\.' '{print $1}')
_MIRRORS_SECUIRTY_URL=$(grep 'security' /etc/apt/sources.list | grep -v '#' | head -n 1 | awk -F ' ' '{print $2}')
_MIRRORS_URL=$(grep -v '#' /etc/apt/sources.list | grep '/debian' | head -n 1 | awk -F ' ' '{print $2}')
_SECUIRTY_BRANCH=$(grep 'security' /etc/apt/sources.list | grep -v '#' | head -n 1 | awk -F ' ' '{print $3}')

cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%s)

if [[ "${DEBIAN_VERSION_SHORT}" -gt 10 ]] || [[ "${DEBIAN_VERSION_SHORT}" -lt 8 ]]; then
    echo "only support debian 8-10, current is debian ${DEBIAN_VERSION_SHORT}"
    exit 1
fi

echo -e "
###################################################################################################
Warnning: This script is dangerous. If you don't know what you're doing, please exit immediately
###################################################################################################"

echo "Confirm your input is right:"
read -p "Please type yes|no: " _UPGRADECONFIRM

if [[ -z "${_UPGRADECONFIRM}" ]]; then
    echo "sorry ,you are't type confirm, exited" && exit 1
elif [[ "${_UPGRADECONFIRM}" == y* ]] || [[ "${_UPGRADECONFIRM}" == Y* ]] ; then
    echo "is confirmed, continue to next step now"
elif [[ "${_UPGRADECONFIRM}" == n* ]] || [[ "${_UPGRADECONFIRM}" == N* ]] ; then
    echo "sorry you are type no, quit exec next step now"
    exit 1
else
    echo "sorry unknown $_UPGRADECONFIRM , type is wrong exit now"
    exit 1
fi

# debian 8 can't get it
# TOOD check /etc/debian_version or os-release VERSION_ID or /etc/issue ,maybe in winter
if [[ -z "${CODENAME}" ]]; then
    if [[ -n "$(command -v lsb_release)" ]]; then
        CODENAME=$(lsb_release -cs)
    elif [[ -n "$(grep '^VERSION=' /etc/os-release | awk -F '(' '{print $2}' | awk -F ')' '{print $1}')" ]]; then
        CODENAME=$(grep '^VERSION=' /etc/os-release | awk -F '(' '{print $2}' | awk -F ')' '{print $1}')
    else
        echo "can't get debian codename exit"
        exit 1
    fi
fi

# check mirrors for china
if [[ $1 == 'CN' ]] || [[ $1 == 'cn' ]]; then
    _LATEST_MIRRORS_URL='http://repo.huaweicloud.com/debian/'
    _LATEST_SECURITY_MIRRORS_URL='http://repo.huaweicloud.com/debian-security/'
elif [[ -z "$1" ]]; then
    _LATEST_MIRRORS_URL='http://deb.debian.org/debian/'
    _LATEST_SECURITY_MIRRORS_URL='http://security.debian.org/debian-security/'
fi

if [[ -n "${_MIRRORS_SECUIRTY_URL}" ]]; then
    sed -i "s#${_MIRRORS_SECUIRTY_URL}#${_LATEST_SECURITY_MIRRORS_URL}#g" /etc/apt/sources.list
fi

sed -i "s#${_MIRRORS_URL}#${_LATEST_MIRRORS_URL}#g" /etc/apt/sources.list

apt update -y && apt install --no-install-recommends -y gnupg dirmngr

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 54404762BBB6E853
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 605C66F00D6C9793
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50

apt-get update -y && apt-get upgrade -y && apt full-upgrade -y

# debian-security include 
# support 8-9 9-10 10-11 
# Cross version upgrade is not supported
# 7 wheezy
# 8 jessie
# 9 stretch
# 10 buster
# 11 bullseye
case "$CODENAME" in
    # 7-8
    wheezy)
        _NEW_CODENAME='jessie'
        ;;
    # can direct upgrade to debian 10 have unknown error
    # 8-9
    # 8-10
    # 8-11 TODO
    jessie)
        _NEW_CODENAME='buster'
        ;;
    # 9-10
    # 9-11
    stretch)
        # _NEW_CODENAME='buster'
        _NEW_CODENAME='bullseye'
        if [[ -n "${_MIRRORS_SECUIRTY_URL}" ]]; then
            sed -i "s#${_MIRRORS_SECUIRTY_URL}#${_LATEST_SECURITY_MIRRORS_URL}#g" /etc/apt/sources.list
            sed -i "s#debian-security/ ${_SECUIRTY_BRANCH}.*#debian-security/ bullseye-security main non-free contrib#g" /etc/apt/sources.list
        fi
        ;;
    # 10 - 11
    buster)
        _NEW_CODENAME='bullseye'
        echo $_MIRRORS_SECUIRTY_URL
        if [[ -n "${_MIRRORS_SECUIRTY_URL}" ]]; then
            sed -i "s#${_MIRRORS_SECUIRTY_URL}#${_LATEST_SECURITY_MIRRORS_URL}#g" /etc/apt/sources.list
            sed -i "s#debian-security/ ${_SECUIRTY_BRANCH}.*#debian-security/ bullseye-security main non-free contrib#g" /etc/apt/sources.list
        fi
        ;;
    *)
        echo -e "unknow debian version ${CODENAME}, please try again"
        exit 1
        ;;
esac

sed -i "s#${CODENAME}#${_NEW_CODENAME}#g" /etc/apt/sources.list

apt-get update -y && apt-get upgrade -y && apt full-upgrade -y && apt-get dist-upgrade

# cleanup
# debian 8 not have apt autoremove
echo "==> clean unneed package"
apt-get autoremove -y

read -p "All is complete, reboot now ?" _CONFIRM_REBOOT
if [[ "${_CONFIRM_REBOOT}" == y* ]] || [[ "${_CONFIRM_REBOOT}" == Y* ]]; then
    echo "is confirmed, reboot now" && reboot
else
    echo "sorry you are type no, maybe you need reboot later manual"
fi