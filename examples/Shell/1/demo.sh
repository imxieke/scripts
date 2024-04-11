#!/usr/bin/env bash
# case $1 in
# 	one )
# 		echo "Hello World"
# 		;;

# 	* )
# 		echo "default option"
# 		;;
# esac
echo_text(){
	echo "Hello World"
}

if [[ `id -u` !=  "0" ]]; then
	echo "Current user not root"
elif 
	echo "Have "
fi