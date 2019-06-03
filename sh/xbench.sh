#!/usr/bin/env bash

export PATH='/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'

#TODO trace

# clear
NAME="XBench"
VERSION='0.1.1'
URL='https://github.com/imxieke/scripts'

function trimall()
{
	echo $1 | sed s/"$2"//g
}

function depededs()
{
	DEPENDS="grep cat"
}

function _iscmd()
{
	if [[ -n $(command -v $1) ]]; then
		echo 'true'
	fi
}

function get_os()
{
	if [[ -f /etc/os-release ]]; then
		OS=$(grep PRETTY_NAME /etc/os-release | awk -F '=' '{print $2}' | sed s/\"//g )
	else
		OS=$(uname -s)	# for mac and more linux
	fi

	echo ${OS}
}

function uptime_human()
{
	UPTIME_TOTAL=$(grep ' ' /proc/uptime | awk -F '.' '{print $1}') # Param: 1 use 2 free time 
	UPTIME_TOTAL=8755468

	# Day 24*60*60 86400
	if [[ ${UPTIME_TOTAL} -gt 86400 ]]; then
		UPTIME_DAYS=$[${UPTIME_TOTAL}/86400]
		UPTIME_REMAIN=$[${UPTIME_TOTAL}%86400]
	fi

	# Hour 60*60 3600 
	if [[ ${UPTIME_TOTAL} -gt 3600 ]]; then
		UPTIME_HOURS=$[${UPTIME_REMAIN}/3600]
		UPTIME_REMAIN=$[${UPTIME_REMAIN}%3600]
	fi

	# Minute 60
	if [[ ${UPTIME_TOTAL} -gt 3600 ]]; then
		UPTIME_MINS=$[${UPTIME_REMAIN}/60]
	fi

	# Second 60
	UPTIME_SEC=$[${UPTIME_REMAIN}%60]

	if [[ ${UPTIME_DAYS} -gt 0 ]]; then
		echo ${UPTIME_DAYS} Day, ${UPTIME_HOURS} Hour, ${UPTIME_MINS} Minute, ${UPTIME_SEC} Second
	elif [[ ${UPTIME_HOURS} -gt 0 ]]; then
		echo ${UPTIME_HOURS} Hour, ${UPTIME_MINS} Minute, ${UPTIME_SEC} Second
	elif [[ ${UPTIME_MINS} -gt 0 ]]; then
		echo ${UPTIME_MINS} Minute, ${UPTIME_SEC} Second
	else
		echo ${UPTIME_SEC} Second
	fi
}

# kvm eth0 ovz venet0
function get_virtual_tech()
{
	if [[ -f /.dockerenv ]]; then
		VIRTUAL='Docker'
	fi

	echo ${VIRTUAL}
}

# @param UNIT  Size Unit (Received)
# param 1G = 1024 MB 1MB = 1024KB etc ...
# Return G MB KB ps : 1.9 G 2.5 MB
function format_size()
{
	UNIT=$1
	SIZE=$[$2*1]
	if [[ ${UNIT} == 'k' ]]; then
		if [[ ${SIZE} -gt 1024 ]]; then
			REMAIN=$[${SIZE}%1024]
			SIZE=$[${SIZE}/1024]

			if [[ ${SIZE} -gt 1024 ]]; then
				UNIT='m'
			else
				if [[ ${REMAIN} -gt 0 ]]; then
					SIZE=${SIZE}'.'${REMAIN}' MB'
				fi
			fi
		else
			if [[ ${SIZE} -eq 0 ]]; then
				SIZE='0 KB'
			else
				SIZE=${size}' KB'
			fi
		fi
	fi

	if [[ ${UNIT} == 'm' ]]; then
		if [[ ${SIZE} -gt 1024 ]]; then

			REMAIN=$[${SIZE}%1024]
			SIZE=$[${SIZE}/1024]

			if [[ ${REMAIN} -gt 0 ]]; then
				SIZE=${SIZE}'.'${REMAIN}' GB'
			fi
		else
			if [[ ${SIZE} -eq 0 ]]; then
				SIZE='0 MB'
			else
				SIZE=${size}' MB'
			fi
		fi
	fi

	echo $SIZE
}


# IP Source: https://tools.ipip.net/traceroute.php
# STDDEV | MDEV Mean Deviation 的缩写，它表示这些 ICMP 包的 RTT 偏离平均值的程度，这个值越大说明你的网速越不稳定。
function pingtest()
{
	IPS="60.166.66.6 113.59.224.1 219.153.31.141 115.238.67.241 202.103.24.68 36.111.160.1 218.2.2.2 202.96.209.133 123.123.123.123 221.6.4.66 202.102.128.68 119.6.6.6 221.131.143.69 211.138.180.2 218.201.96.130"
	INFO=(安徽电信 北京电信 重庆电信 浙江电信 广东电信 贵州电信 江苏电信 上海电信 黑龙江电信 重庆联通 山东联通 四川联通 江苏移动 安徽移动 山东移动)
	TIMES=0
	for ip in ${IPS}; do
		echo "IP: "${ip} "Location: "${INFO[${TIMES}]}
		PINGINFO=$(ping -c 3 ${ip})
		LOSS=$(echo ${PINGINFO} | awk -F '---' '{print $3}' | awk -F ',' '{print $3}' | awk -F ' ' '{print $1}')
		MIN=$(echo ${PINGINFO} | awk -F '---' '{print $3}' | awk -F ',' '{print $3}' | awk -F ' ' '{print $7}' | awk -F '/' '{print $1}')
		MAX=$(echo ${PINGINFO} | awk -F '---' '{print $3}' | awk -F ',' '{print $3}' | awk -F ' ' '{print $7}' | awk -F '/' '{print $3}')
		AVG=$(echo ${PINGINFO} | awk -F '---' '{print $3}' | awk -F ',' '{print $3}' | awk -F ' ' '{print $7}' | awk -F '/' '{print $2}')
		STDDEV=$(echo ${PINGINFO} | awk -F '---' '{print $3}' | awk -F ',' '{print $3}' | awk -F ' ' '{print $7}' | awk -F '/' '{print $4}')
		echo "Min: " ${MIN} " Max: " ${MAX} "Avg: " ${AVG} " STDDEV|MDEV: " ${STDDEV} "Loss: " ${LOSS}
		TIMES=$[${TIMES}+1]
	done
}

# TODO get shell version
function sysinfo()
{
	OS=$(get_os)
	CPU_MODEL=$(grep 'model name' /proc/cpuinfo | head -n 1 | awk -F ':' '{print $2}')
	CPU_CORES=$(grep 'model name' /proc/cpuinfo | wc -l)
	SHELL=$(echo $0 | sed s/-//g)

	MEM_TOTAL=$(grep 'MemTotal' /proc/meminfo | awk -F ' ' '{print $2}')
	MEM_FREE=$(grep 'MemFree:' /proc/meminfo | awk -F ' ' '{print $2}')
	MEM_USED=$[${MEM_TOTAL}-${MEM_FREE}]
	MEM_AVAI=$(grep 'MemAvailable:' /proc/meminfo | awk -F ' ' '{print $2}')
	MEM_BUFFER=$(grep 'Buffers:' /proc/meminfo | awk -F ' ' '{print $2}')
	MEM_CACHED=$(grep '^Cached:' /proc/meminfo | awk -F ' ' '{print $2}')

	MEM_SWAP_TOTAL=$(grep 'SwapTotal:' /proc/meminfo | awk -F ' ' '{print $2}')
	MEM_SWAP_FREE=$(grep 'SwapFree:' /proc/meminfo | awk -F ' ' '{print $2}')
	MEM_SWAP_USED=$[${MEM_SWAP_TOTAL}-${MEM_SWAP_FREE}]

	if [[ -n ${TTY} ]]; then
		TTY=${TTY}
	elif [[ -n $(tty) ]]; then
		TTY=$(tty)
	fi
	echo -e "OS:\t\t" 			${OS} $(uname -m)
	echo -e "Host Name:\t" 		$(hostname)
	echo -e "Memory:\t\t" 		'Total: ' $(format_size k ${MEM_TOTAL})  ' | Free: '  $(format_size k ${MEM_FREE}) ' | Used: '  $(format_size k ${MEM_USED}) ' | Avaiable: '  $(format_size k ${MEM_AVAI})  ' | Buffers: '  $(format_size k ${MEM_BUFFER})  ' | Cached: '  $(format_size k ${MEM_CACHED})

	if [[ -n ${MEM_SWAP_TOTAL} ]]; then
		echo -e "Swap:\t\t" 		'Total: ' $(format_size k ${MEM_SWAP_TOTAL})  ' | Used: '  $(format_size k ${MEM_SWAP_USED}) ' | Free: '  $(format_size k ${MEM_SWAP_FREE})
	fi

	echo -e "Uptime:\t\t" 		$(uptime_human)
	echo -e "Kernel:\t\t" 		$(uname -r)
	echo -e "TTY:\t\t" 			${TTY}
	echo -e "Arch:\t\t" 		$(uname -m)
	echo -e "Virtual:\t" 		$(get_virtual_tech)
	echo -e "CPU Models:\t" 	${CPU_MODEL}
	echo -e "CPU Cores:\t" 		${CPU_CORES}
}

function usage()
{
	echo "XBench ${VERSION} ($(uname -m))"
	echo "usage: xbench [options] value "
	echo ""
	echo "Options:"
	echo "	-i --info  	Show "
}

case $1 in
	-i | info | --info )
		sysinfo
		;;
	-p | ping | --ping )
		pingtest
		;;
	*)
		usage
		;;
esac
