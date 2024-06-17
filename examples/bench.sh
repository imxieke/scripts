#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2022-10-01 17:11:53
 # @LastEditTime: 2022-10-03 01:24:01
 # @LastEditors: Cloudflying
 # @Description: 
### 


speedtest_v4()
{
	echo "message"
}

speed_test() {
	local speedtest=$(wget -4O /dev/null -T300 $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}')
	local ipaddress=$(ping -c1 -n `awk -F'/' '{print $3}' <<< $1` | awk -F'[()]' '{print $2;exit}')
	local nodeName=$2
	printf "${YELLOW}%-32s${GREEN}%-24s${RED}%-14s${PLAIN}\n" "${nodeName}:" "${ipaddress}:" "${speedtest}"
}

printf "%-32s%-24s%-14s\n" "Mirror Name" "IPv4 address" "Download Speed"
# speed_test 'https://mirrors.edge.kernel.org/alpine/edge/releases/x86_64/netboot/modloop-lts' 'Kernel, US'
speed_test 'https://mirrors.ocf.berkeley.edu/alpine/edge/releases/x86_64/netboot/modloop-lts' 'Berkeley, US'

https://mirrors.tuna.tsinghua.edu.cn/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
http://mirrors.ustc.edu.cn/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
http://mirrors.aliyun.com/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
http://mirrors.tencent.com/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
https://mirrors.tencent.com/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
https://repo.huaweicloud.com/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
https://mirrors.huaweicloud.com/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
https://mirrors.sustech.edu.cn/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
http://mirror.bit.edu.cn/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
http://mirror.lzu.edu.cn/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
http://mirrors.hit.edu.cn/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
https://mirrors.pinganyun.com/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz
https://mirrors.ocf.berkeley.edu/archlinux/iso/latest/archlinux-bootstrap-2022.09.03-x86_64.tar.gz