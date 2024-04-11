#!/bin/bash
case $1 in
	ip )
		curl -4 -s icanhazip.com
		;;
esac