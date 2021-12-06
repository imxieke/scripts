#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-11-14 20:46:40
 # @LastEditTime: 2021-11-14 21:34:02
 # @LastEditors: Cloudflying
 # @Description: 
 # @FilePath: /scripts/sh/openwert.sh
### 

# can't mount usd disk
# kmod-fs-ntfs read only
opkg install fdisk
opkg install block-mount kmod-usb-storage kmod-usb-storage-extras kmod-usb-storage-uas e2fsprogs kmod-usb-core kmod-usb2 kmod-usb3 kmod-usb-ehci kmod-usb-ohci kmod-scsi-core
opkg install kmod-fs-ext4 kmod-fs-configfs kmod-fs-exfat kmod-fs-hfs kmod-fs-hfsplus kmod-fs-nfs kmod-fs-vfat ntfs-3g ntfs-3g-utils
opkg install wget ca-certificates openssl-util ca-bundle git-http