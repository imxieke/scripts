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

echo -e "
###################################################################################################
Warnning: This script is dangerous. If you don't know what you're doing, please exit immediately
###################################################################################################"

[ -z $1 ] && echo -e "
type debian version to upgrade(can't downgrade) , support debian 10-11
maybe have any depens error need fix manual
example: 10|buster 11|bullseye
"
exit 1

UPTO=$1

echo "cofirm your input is right please"
read -p "type yes|no: " _UPGRADECONFIRM

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
CODENAME=$(grep '^VERSION_CODENAME=' /etc/os-release | awk -F '=' '{print $2}')

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

_SECUIRTY_URL=$(grep 'security' /etc/apt/sources.list | grep -v '#' | head -n 1 | awk -F ' ' '{print $2}')
_SECUIRTY_BRANCH=$(grep 'security' /etc/apt/sources.list | grep -v '#' | head -n 1 | awk -F ' ' '{print $3}')
_LATEST_SECURITY_URL='http://security.debian.org/debian-security'
cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%s)

apt install --no-install-recommends -y gnupg

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 54404762BBB6E853
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 605C66F00D6C9793

apt-get update -y && apt-get upgrade -y && apt full-upgrade -y

# debian-security include 
case "$UPTO" in
    11|bullseye)
        UPTO_CODENAME='bullseye'
        if [[ -n "${_SECUIRTY_URL}" ]]; then
            sed -i "s#${_SECUIRTY_URL}#${_LATEST_SECURITY_URL}#g" /etc/apt/sources.list
            sed -i "s#debian-security ${_SECUIRTY_BRANCH}#debian-security bullseye-security#g" /etc/apt/sources.list
        fi
        ;;
    10|buster)
        UPTO_CODENAME='buster'
        if [[ -n "${_SECUIRTY_URL}" ]]; then
            sed -i "s#${_SECUIRTY_URL}#${_LATEST_SECURITY_URL}#g" /etc/apt/sources.list
            sed -i "s#debian-security ${_SECUIRTY_BRANCH}#debian-security buster/updates#g" /etc/apt/sources.list
        fi
        ;;
    *)
        echo -e "unknow debian version ${UPTO}, please try again"
        exit 1
        ;;
esac

sed -i "s#${CODENAME}#${UPTO_CODENAME}#g" /etc/apt/sources.list

apt-get update -y && apt-get upgrade -y && apt full-upgrade -y && apt-get dist-upgrade

# Clean
# debian 8 not have apt autoremove
apt-get autoremove -y

read -p "All is complete, reboot now ?" _CONFIRM_REBOOT
if [[ "${_CONFIRM_REBOOT}" == y* ]] || [[ "${_CONFIRM_REBOOT}" == Y* ]]; then
    echo "is confirmed, reboot now" && reboot
else
    echo "sorry you are type no, maybe you need reboot later manual"
fi