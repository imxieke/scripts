#/usr/bin/env bash
case $1 in
	hello )
		echo "Hello hello"
		;;

	two ) 
		echo "Hello two"
		;;
	three )
		echo "Hello three"
		;;
	* )
		echo "command error"
		;;
esac