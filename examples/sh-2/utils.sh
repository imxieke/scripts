#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-08-06 23:44:21
 # @LastEditTime: 2021-09-17 13:42:32
 # @LastEditors: Cloudflying
 # @Description: 
 # @FilePath: /scripts/sh/utils.sh
### 

ubuntu_dns_change()
{
    if [ -z "$(command -v resolvconf)" ];then
        sudo apt install resolvconf
    fi

    if [ -f '/etc/resolvconf.conf' ];then
        if [ -z "$(grep 'name_servers' /etc/resolvconf.conf)" ];then
            echo 'name_servers=223.5.5.5' >> /etc/resolvconf.conf
        else
            sed -i 's/name_servers=.*/name_servers=223.5.5.5/g' /etc/resolvconf.conf
        fi
    fi

    sudo resolvconf -u
}

function clear()
{
	git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"
	git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch BIGFILE' --prune-empty --tag-name-filter cat -- --all
	git push origin master --force
	rm -rf .git/refs/original/
	git reflog expire --expire=now --all
	git gc --prune=now
}
