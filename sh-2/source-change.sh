#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-12-05 13:28:47
 # @LastEditTime: 2021-12-05 13:45:33
 # @LastEditors: Cloudflying
 # @Description: software source changer
 # @FilePath: /scripts/sh/source-change.sh
### 

# 进行测速后选择软件源

# cat /etc/apt/sources.list | grep "`grep '^VERSION_CODENAME=' /etc/os-release | awk -F '=' '{print $2}'` main"

OSCODENAME=$(grep '^VERSION_CODENAME=' /etc/os-release | awk -F '=' '{print $2}')
MAIN_SOURCE_URL=$(grep "${OSCODENAME} main" /etc/apt/sources.list | grep -v '#' | awk -F '/' '{print $3}' | head -n 1)
SEC_SOURCE_URL=$(grep "${OSCODENAME}-security main" /etc/apt/sources.list | grep -v '#' | awk -F '/' '{print $3}' | head -n 1)

sed -i "s#${MAIN_SOURCE_URL}#mirrors.aliyun.com#g" /etc/apt/sources.list

