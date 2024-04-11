#!/usr/bin/env bash
# case $1 in
# 	one )
# 		echo "Hello World"
# 		;;

# 	* )
# 		echo "default option"
# 		;;
# esac

if [[ 2 > 3 || 1 > 2 ]]; then
	echo "The result error"
else
	echo "result is ecorrt"
fi