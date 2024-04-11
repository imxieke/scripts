#!/bin/bash
# created by "black" on lowendtalk.com
# please give credit if you plan on using this for your own projects 

fileName="100mb.test";

speedtest () {
	dlspeed=$(echo -n "scale=2; " && curl --connect-timeout 8 http://$1/$fileName -w "%{speed_download}" -o $fileName -s | sed "s/\,/\./g" && echo "/1048576");
	echo "$dlspeed" | bc -q | sed "s/$/ MB\/sec/;s/^/\tDownload Speed\: /";
	ulspeed=$(echo -n "scale=2; " && curl --connect-timeout 8 -F "file=@$fileName" http://$1/webtests/ul.php -w "%{speed_upload}" -s -o /dev/null | sed "s/\,/\./g" && echo "/1048576");
	echo "$ulspeed" | bc -q | sed "s/$/ MB\/sec/;s/^/\tUpload speed\: /";
}

ls "$fileName" 1>/dev/null 2>/dev/null;
if [ $? -eq 0 ]
then
	echo "$fileName already exists, remove it or rename it";
	exit 1;
fi

cputest () {
	cpuName=$(cat /proc/cpuinfo | grep "model name" | cut -d ":" -f2 | tr -s " " | head -n 1);
	cpuCount=$(cat /proc/cpuinfo | grep "model name" | cut -d ":" -f2 | wc -l);
	echo "CPU: $cpuCount x$cpuName";
	echo -n "Time taken to generate PI to 5000 decimal places with a single thread: ";
	(time echo "scale=5000; 4*a(1)" | bc -lq) 2>&1 | grep real |  cut -f2
}

disktest () {
	echo "Writing 1000MB file to disk"
	dd if=/dev/zero of=$$.disktest bs=64k count=16k conv=fdatasync 2>&1 | tail -n 1 | cut -d " " -f3-;
	rm $$.disktest;
}

#check dependencies
metDependencies=1;
#check if curl is installed
type curl 1>/dev/null 2>/dev/null;
if [ $? -ne 0 ]
then
	echo "curl is not installed, install it to continue, typically you can install it by typing"
	echo "apt-get install curl"
	echo "yum install curl"
	echo "depending on your OS";
	metDependencies=0 ;
fi
#check if bc is installed
type bc 1>/dev/null 2>/dev/null;
if [ $? -ne 0 ]
then
	echo "bc is not installed, install it to continue, typically you can install it by typing"
	echo "apt-get install bc"
	echo "yum install bc"
	echo "depending on your OS";
	metDependencies=0;
fi
if [ $metDependencies -eq 0 ]
then
	exit 1;
fi


## start speed test
echo "-------------Speed test--------------------";

echo -e "\nTesting Asian locations";

### Singapore
echo "Speedtest from Singapore on a shared 1 Gbps port";
speedtest 128.199.65.191;

unlink $fileName;

### Due to expensive bandwidth, use the 10MB test file instead
fileName="10mb.test";

### Tokyo, Japan
echo "Speedtest from Tokyo, Japan on a shared 1 Gbps port";
speedtest 108.61.200.70:12601;

unlink $fileName;

## start CPU test
echo "---------------CPU test--------------------";
cputest;

## start disk test
echo "----------------IO test-------------------";
disktest;
