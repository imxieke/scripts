#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2023-09-09 17:16:35
 # @LastEditTime: 2023-09-09 17:23:18
 # @LastEditors: Cloudflying
 # @Description: Server Performance Test
### 

about() {
	echo ""
	echo " ========================================================= "
	echo " \                 	Benchmark                          / "
	echo " \       Basic system info, I/O test and speedtest       / "
	echo " \                   v0.0.1 (9 Sep 2023)                 / "
	echo " \                   Created by Cloudflying              / "
	echo " ========================================================= "
	echo ""
}

cancel() {
	echo ""
	next;
	echo " Abort ..."
	echo " Cleanup ..."
	cleanup;
	echo " Done"
	exit
}

trap cancel SIGINT

_check_env()
{
	echo ""
	
}

sysinfo()
{
	export cpu=''
}