#!/usr/bin/env sh

apk add supervisor
rc-update add supervisord
rc-update add local

# install smaba 
apk add samba-server samba-common-tools
# smbpasswd -a username only exist in os

# Raid
apk add mdadm

# lvm2
apk add lvm2

# Disk Manager
apk add parted cfdisk sfdisk sgdisk

# su login groups chsh useradd userdel groupadd groupdel and more user command
apk add shadow 

# ltrace ld nm strings strip command
apk add ltrace 	binutils