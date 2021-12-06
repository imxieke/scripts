#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-12-06 13:52:13
 # @LastEditTime: 2021-12-06 14:48:14
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

[ -z $1 ] && echo -e "\ntype debian version to upgrade(can't downgrade) , support debian 6-11
example: 6|squeeze 7|wheezy 8|jessie 9|stretch 10|buster 11|bullseye" && exit 1

UPTO=$1

echo "cofirm your input is right please"
read -p "type yes|no: " _UPGRADECONFIRM

if [[ -z "${_UPGRADECONFIRM}" ]]; then
    echo "sorry ,you are't type confirm, exited" && exit 1
elif [[ "${_UPGRADECONFIRM}" == y* ]] || [[ "${_UPGRADECONFIRM}" == Y* ]] ; then
    echo "is confirmed, continue to next step now"
elif [[ "${_UPGRADECONFIRM}" == n* ]] || [[ "${_UPGRADECONFIRM}" == N* ]] ; then
    echo "sorry you are type no, quit exec next step now"
else
    echo "sorry unknown $_UPGRADECONFIRM , type is wrong exit now"
fi

# 
CODENAME=$(grep '^VERSION_CODENAME=' /etc/os-release | awk -F '=' '{print $2}')

cp /etc/apt/sources.list /etc/apt/sources.list.bak

apt-get update -y && apt-get upgrade -y && apt full-upgrade -y

case "$UPTO" in
    11|bullseye)
        UPTO_CODENAME='bullseye'
        ;;
    10|buster)
        UPTO_CODENAME='buster'
        ;;
    9|stretch)
        UPTO_CODENAME='stretch'
        ;;
    8|jessie)
        UPTO_CODENAME='jessie'
        ;;
    7|wheezy)
        UPTO_CODENAME='wheezy'
        ;;
    6|squeeze)
        UPTO_CODENAME='squeeze'
        ;;
    *)
        echo -e "unknow debian version ${UPTO}, please try again"
        exit 1
        ;;
esac

sed -i "s#${CODENAME}#${UPTO_CODENAME}#g" /etc/apt/sources.list

apt-get update -y && apt-get upgrade -y && apt full-upgrade -y && apt-get dist-upgrade

# Clean
apt-get autoremove -y

read -p "All is complete, reboot now ?" _CONFIRM_REBOOT
if [[ "${_CONFIRM_REBOOT}" == y* ]] || [[ "${_CONFIRM_REBOOT}" == Y* ]]; then
    echo "is confirmed, reboot now" && reboot
else
    echo "sorry you are type no, maybe you need reboot later manual"
fi