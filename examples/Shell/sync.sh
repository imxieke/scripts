#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-07-08 00:04:40
 # @LastEditTime: 2021-08-06 23:45:47
 # @LastEditors: Cloudflying
 # @Description: 
 # @FilePath: /Shell/sync.sh
### 

# Sync php source code file
wget -c --no-check-certificate -e robots=off -nd -r -l1 --no-parent -A.xz -A.gz -A.bz2 -A.asc https://mirror.cogentco.com/pub/php/

wget -c --no-check-certificate -e robots=off -nd -r -l1 --no-parent -A.zip -A.gz -A.asc https://nginx.org/download/

wget -c --no-check-certificate -e robots=off -nd -r -l1 --no-parent -A.gz -A.sha512 https://unit.nginx.org/download/

mailhog()
{
	https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_darwin_amd64
	https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_386
	https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64
	https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_arm
	https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_windows_386.exe
	https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_windows_amd64.exe
}

ioncube()
{
	wget -c --no-check-certificate https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz
	wget -c --no-check-certificate https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
	wget -c --no-check-certificate https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_armv7l.tar.gz
	wget -c --no-check-certificate https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz
	wget -c --no-check-certificate https://downloads.ioncube.com/loader_downloads/ioncube_loaders_mac_x86.tar.gz
	wget -c --no-check-certificate https://downloads.ioncube.com/loader_downloads/ioncube_loaders_mac_x86-64.tar.gz
}