#!/bin/bash

#CyberPanel installer script for Ubuntu 18.X and CentOS 7.X
#When I wrote this, only God and I understand what I was doing.
#Now, only God knows...

is_first_floating_number_bigger()
{
    number1="$1"
    number2="$2"

    [ ${number1%.*} -eq ${number2%.*} ] && [ ${number1#*.} \> ${number2#*.} ] || [ ${number1%.*} -gt ${number2%.*} ];
    result=$?
    if [ "$result" -eq 0 ]; then result=1; else result=0; fi

    __FUNCTION_RETURN="${result}"
}
# 1 = bigger , 0 = smaller


server_test() {
	
if [[ $OS = centos ]] ; then
	yum clean all
	yum install wget curl which bc -y
fi

if [[ $OS = ubuntu ]] ; then
	apt update
	apt install wget curl bc -y
fi

server1=lax.cyberpanel.sh
server2=sgp.cyberpanel.sh
server3=fra.cyberpanel.sh
multiply=1024
re='^[0-9]+([.][0-9]+)?$'



echo -e "Chekcing latency to $server1...\n"
ping1=$(timeout 5s ping -c 3 $server1 |  awk 'FNR == 2 { print $(NF-1) }' | cut -d'=' -f2)
if ! [[ $ping1 =~ $re ]] ; then
   echo -e "\e[31m$server1 is unreachable...\e[39m\n"
   ping1=9999
else
echo -e "Your ping to \e[31m$server1\e[39m is \e[31m$ping1 ms\e[39m\n"
sleep 1
fi

echo -e "Checking download speed to $server1 ..."

if [[ $OS = centos ]] ; then
speed1=$(timeout 15s wget -O /dev/null https://$server1/10MB.test 2>&1 | grep -o "[0-9.]\+ [KM]*B/s")
else
speed1=$(timeout 15s wget -o - -O /dev/null https://$server1/10MB.test 2>&1 | grep -o "[0-9.]\+ [KM]*B/s")
fi
echo ""

if [[ $speed1 = *"MB"* ]]; then
speed11=($speed1 sed -e 's/\MB\/s//g')
speed111=$(echo "${speed11}*${multiply}" |bc)
echo -e "Download speed to \e[31m$server1\e[39m is \e[31m$speed1\e[39m ...\n"
sleep 1
elif [[ $speed1 = *"KB"* ]]; then
speed11=($speed1 sed -e 's/\KB\/s//g')
speed111=$(echo "${speed11}" |bc)
echo -e "Download speed to \e[31m$server1\e[39m is \e[31m$speed1\e[39m ...\n"
sleep 1
else
echo -e "\e[31m$server1 is not favorable...\e[39m\n"
sleep 1
speed11=1
speed111=1
fi

echo -e "Chekcing latency to $server2...\n"
ping2=$(timeout 5s ping -c 3 $server2 |  awk 'FNR == 2 { print $(NF-1) }' | cut -d'=' -f2)
if ! [[ $ping2 =~ $re ]] ; then
   echo -e "\e[31m$server2 unreachable...\e[39m\n"
   ping2=9999
sleep 1
else
echo -e "Your ping to \e[31m$server2\e[39m is \e[31m$ping2 ms\e[39m\n"
sleep 1
fi

echo -e "Checking download speed to $server2 ...\n"
if [[ $OS = centos ]] ; then
speed2=$(timeout 15s wget -O /dev/null https://$server2/10MB.test 2>&1 | grep -o "[0-9.]\+ [KM]*B/s")
else
speed2=$(timeout 15s wget -o - -O /dev/null https://$server2/10MB.test 2>&1 | grep -o "[0-9.]\+ [KM]*B/s")
fi
if [[ $speed2 = *"MB"* ]]; then
speed22=($speed2 sed -e 's/\MB\/s//g')
speed222=$(echo "${speed22}*${multiply}" |bc)
echo -e "Download speed to \e[31m$server2\e[39m is \e[31m$speed2\e[39m ...\n"
sleep 1
elif [[ $speed2 = *"KB"* ]]; then
speed22=($speed1 sed -e 's/\KB\/s//g')
speed222=$(echo "${speed22}" |bc)
sleep 1
echo -e "Download speed to \e[31m$server2\e[39m is \e[31m$speed2\e[39m ...\n"
else
echo -e "\e[31m$server2 is not favorable...\e[39m\n"
sleep 1
speed22=1
speed222=1
fi

echo -e "Chekcing latency to $server3...\n"
ping3=$(timeout 5s ping -c 3 $server3 |  awk 'FNR == 2 { print $(NF-1) }' | cut -d'=' -f2)
if ! [[ $ping3 =~ $re ]] ; then
   echo -e "\e[31m$server3 unreachable...\e[39m\n"
   ping3=9999
sleep 1
else
echo -e "Your ping to \e[31m$server3\e[39m is \e[31m$ping3 ms\e[39m\n"
sleep 1
fi
echo -e "Checking download speed to $server3 ...\n"
if [[ $OS = centos ]] ; then
speed3=$(timeout 15s wget -O /dev/null https://$server3/10MB.test 2>&1 | grep -o "[0-9.]\+ [KM]*B/s")
else
speed3=$(timeout 15s wget -o - -O /dev/null https://$server3/10MB.test 2>&1 | grep -o "[0-9.]\+ [KM]*B/s")
fi

if [[ $speed3 = *"MB"* ]]; then
speed33=($speed3 sed -e 's/\MB\/s//g')
speed333=$(echo "${speed33}*${multiply}" |bc)
echo -e "Download speed to \e[31m$server3\e[39m is \e[31m$speed3\e[39m ...\n"
sleep 1
elif [[ $speed3 = *"KB"* ]]; then
speed33=($speed3 sed -e 's/\KB\/s//g')
speed333=$(echo "${speed33}" |bc)
echo -e "Download speed to \e[31m$server3\e[39m is \e[31m$speed3\e[39m ...\n"
sleep 1
else
echo -e "\e[31m$server3 is not favorable...\e[39m\n"
sleep 1
speed33=1
speed333=1
fi

is_first_floating_number_bigger $speed111 $speed222
result="${__FUNCTION_RETURN}"
if [ $result == 1 ]; then
faster1=$speed111
faster_server1=$server1
else
faster1=$speed222
faster_server1=$server2
fi

is_first_floating_number_bigger $speed222 $speed333
result="${__FUNCTION_RETURN}"
if [ $result == 1 ]; then
faster2=$speed222
faster_server2=$server2
else
faster2=$speed333
faster_server2=$server3
fi

is_first_floating_number_bigger $faster1 $faster2
result="${__FUNCTION_RETURN}"
if [ $result == 1 ]; then
fastest=$faster1
fastest_server=$faster_server1
else
fastest=$faster2
fastest_server=$faster_server2
fi

if [[ $fastest == $speed111 ]]; then
fastest_ping=$ping1
elif [[ $fastest == $speed222 ]]; then
fastest_ping=$ping2
elif [[ $fastest == $speed333 ]]; then
fastest_ping=$ping3
fi

is_first_floating_number_bigger $ping1 $ping2
result="${__FUNCTION_RETURN}"
if [ $result == 0 ]; then
smaller1=$ping1
smaller_server1=$server1
else
smaller1=$ping2
smaller_server1=$server2
fi

is_first_floating_number_bigger $ping2 $ping3
result="${__FUNCTION_RETURN}"
if [ $result == 0 ]; then
smaller2=$ping2
smaller_server2=$server2
else
smaller2=$ping3
smaller_server2=$server3
fi

is_first_floating_number_bigger $smaller1 $smaller2
result="${__FUNCTION_RETURN}"
if [ $result == 0 ]; then
smallest=$smaller1
smallest_server=$smaller_server1
else
smallest=$smaller2
smallest_server=$smaller_server2
fi
}



install_php_memcached() {
if [[ $OS = centos ]] ; then
yum install -y lsphp54-pecl-memcached lsphp55-pecl-memcached lsphp56-pecl-memcached lsphp70-memcached lsphp71-memcached lsphp72-memcached lsphp73-memcached
fi
if [[ $OS = ubuntu ]] ; then
apt-get install lsphp70-memcached lsphp71-memcached lsphp72-memcached -y
fi
}

install_lsmcd() {
if [[ $OS = centos ]] ; then
yum groupinstall "Development Tools" -y
		yum install autoconf automake zlib-devel openssl-devel expat-devel pcre-devel libmemcached-devel cyrus-sasl* -y
		wget https://$download_server/litespeed/lsmcd.tar.gz
		tar xzvf lsmcd.tar.gz
		cd lsmcd
		./fixtimestamp.sh
		./configure CFLAGS=" -O3" CXXFLAGS=" -O3"
		make
		make install
systemctl enable lsmcd
systemctl start lsmcd
fi
if [[ $OS = ubuntu ]] ; then
  apt-get update -y
	apt-get install build-essential zlib1g-dev libexpat1-dev openssl libssl-dev libsasl2-dev libpcre3-dev git -y
	git clone https://github.com/litespeedtech/lsmcd.git
	cd lsmcd
	./fixtimestamp.sh
	./configure CFLAGS=" -O3" CXXFLAGS=" -O3"
	make
	make install
	systemctl enable lsmcd
	systemctl start lsmcd
fi
}

install_memcached() {
if [[ $OS = centos ]] ; then
	
		yum install memcached -y
		systemctl start memcached
		systemctl enable memcached
fi

if [[ $OS = ubuntu ]] ; then
	apt-get install memcached -y
	systemctl start memcached
	systemctl enable memcached
fi
}

install_php_redis() {
if [[ $OS = centos ]] ; then
yum install -y lsphp54-pecl-redis lsphp55-pecl-redis lsphp56-pecl-redis lsphp70-pecl-redis lsphp71-pecl-redis lsphp72-pecl-redis lsphp73-redis
fi
if [[ $OS = ubuntu ]] ; then
apt-get install -y lsphp70-redis lsphp71-redis lsphp72-redis
fi
}

install_redis() {
if [[ $OS = centos ]] ; then
	yum install -y redis
	systemctl enable redis
	systemctl start redis
fi

if [[ $OS = ubuntu ]] ; then
	apt-get install redis -y
	systemctl enable redis
	systemctl start redis
fi
}

cdn_replace() {
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css|https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.css|g' /usr/local/lscp/cyberpanel/static/baseTemplate/templates/baseTemplate/index.html
sed -i 's|https://fonts.googleapis.com/css?family=Raleway:300|https://cdn.jsdelivr.net/npm/fonts-raleway@0.0.4/css/raleway.min.css|g' /usr/local/lscp/cyberpanel/static/baseTemplate/assets/themes/admin/color-schemes/default.css
sed -i 's|https://fonts.googleapis.com/css?family=Open+Sans|https://cdn.jsdelivr.net/npm/open-sans-fontface@1.4.0/open-sans.css|g' /usr/local/lscp/cyberpanel/static/baseTemplate/assets/themes/admin/color-schemes/default.css
sed -i 's|https://fonts.googleapis.com/css?family=Raleway:300|https://cdn.jsdelivr.net/npm/fonts-raleway@0.0.4/css/raleway.min.css|g' /usr/local/lscp/cyberpanel/static/baseTemplate/assets/finalBase/finalBaseTheme.css
sed -i 's|https://fonts.googleapis.com/css?family=Open+Sans|https://cdn.jsdelivr.net/npm/open-sans-fontface@1.4.0/open-sans.css|g' /usr/local/lscp/cyberpanel/static/baseTemplate/assets/finalBase/finalBaseTheme.css
sed -i 's|https://fonts.googleapis.com/css?family=Raleway:300|https://cdn.jsdelivr.net/npm/fonts-raleway@0.0.4/css/raleway.min.css|g' /usr/local/lscp/cyberpanel/static/baseTemplate/assets/finalLoginPageCSS/allCssNormal.css
sed -i 's|https://fonts.googleapis.com/css?family=Open+Sans|https://cdn.jsdelivr.net/npm/open-sans-fontface@1.4.0/open-sans.css|g' /usr/local/lscp/cyberpanel/static/baseTemplate/assets/finalLoginPageCSS/allCssNormal.css
sed -i 's|https://fonts.googleapis.com/css?family=Raleway:300|https://cdn.jsdelivr.net/npm/fonts-raleway@0.0.4/css/raleway.min.css|g' /usr/local/lscp/cyberpanel/static/baseTemplate/assets/allCss.css
sed -i 's|https://fonts.googleapis.com/css?family=Open+Sans|https://cdn.jsdelivr.net/npm/open-sans-fontface@1.4.0/open-sans.css|g' /usr/local/lscp/cyberpanel/static/baseTemplate/assets/allCss.css
sed -i 's|https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|https://cdn.jsdelivr.net/npm/roboto-fontface-woff@0.8.0/css/roboto/roboto-fontface.css|g' /usr/local/lscp/cyberpanel/static/filemanager_app/bower_components/bootswatch/paper/bootstrap.min.css
sed -i 's|https://fonts.googleapis.com/css?family=Raleway:300|https://cdn.jsdelivr.net/npm/fonts-raleway@0.0.4/css/raleway.min.css|g' /usr/local/CyberCP/baseTemplate/static/baseTemplate/assets/themes/admin/color-schemes/default.css
sed -i 's|https://fonts.googleapis.com/css?family=Open+Sans|https://cdn.jsdelivr.net/npm/open-sans-fontface@1.4.0/open-sans.css|g' /usr/local/CyberCP/baseTemplate/static/baseTemplate/assets/themes/admin/color-schemes/default.css
sed -i 's|https://fonts.googleapis.com/css?family=Raleway:300|https://cdn.jsdelivr.net/npm/fonts-raleway@0.0.4/css/raleway.min.css|g' /usr/local/CyberCP/baseTemplate/static/baseTemplate/assets/finalLoginPageCSS/allCssNormal.css
sed -i 's|https://fonts.googleapis.com/css?family=Open+Sans|https://cdn.jsdelivr.net/npm/open-sans-fontface@1.4.0/open-sans.css|g' /usr/local/CyberCP/baseTemplate/static/baseTemplate/assets/finalLoginPageCSS/allCssNormal.css
sed -i 's|https://fonts.googleapis.com/css?family=Raleway:300|https://cdn.jsdelivr.net/npm/fonts-raleway@0.0.4/css/raleway.min.css|g' /usr/local/CyberCP/baseTemplate/static/baseTemplate/assets/finalBase/finalBaseTheme.css
sed -i 's|https://fonts.googleapis.com/css?family=Open+Sans|https://cdn.jsdelivr.net/npm/open-sans-fontface@1.4.0/open-sans.css|g' /usr/local/CyberCP/baseTemplate/static/baseTemplate/assets/finalBase/finalBaseTheme.css
sed -i 's|https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular.js|https://cdn.jsdelivr.net/npm/angular@1.6.5/angular.min.js|g' /usr/local/CyberCP/loginSystem/templates/loginSystem/test.html
sed -i 's|https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular-route.js|https://cdn.jsdelivr.net/npm/angular-route@1.6.4/angular-route.min.js|g' /usr/local/CyberCP/loginSystem/templates/loginSystem/test.html
sed -i 's|https://code.angularjs.org/1.6.5/angular.min.js|https://cdn.jsdelivr.net/npm/angular@1.6.5/angular.min.js|g' /usr/local/CyberCP/baseTemplate/templates/baseTemplate/index.html
sed -i 's|https://code.jquery.com/jquery-3.2.1.min.js|https://cdn.jsdelivr.net/npm/jquery@3.2.1/dist/jquery.min.js|g' /usr/local/CyberCP/baseTemplate/templates/baseTemplate/index.html
sed -i 's|https://code.angularjs.org/1.6.5/angular.min.js|https://cdn.jsdelivr.net/npm/angular@1.6.5/angular.min.js|g' /usr/local/CyberCP/baseTemplate/templates/baseTemplate/indexJavaFixed.html
sed -i 's|https://code.jquery.com/jquery-3.2.1.min.js|https://cdn.jsdelivr.net/npm/jquery@3.2.1/dist/jquery.min.js|g' /usr/local/CyberCP/baseTemplate/templates/baseTemplate/indexJavaFixed.html
sed -i 's|https://code.angularjs.org/1.6.5/angular.min.js|https://cdn.jsdelivr.net/npm/angular@1.6.5/angular.min.js|g' /usr/local/CyberCP/filemanager/templates/filemanager/index.html
sed -i 's|<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>|<script src="https://cdn.jsdelivr.net/npm/jquery@3.2.1/dist/jquery.slim.min.js" integrity="sha256-k2WSCIexGzOj3Euiig+TlR8gA0EmPjuc79OEeY5L45g=" crossorigin="anonymous"></script>|g' /usr/local/CyberCP/filemanager/templates/filemanager/index.html
sed -i 's|<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>|<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.3/dist/umd/popper.min.js" integrity="sha256-jpW4gXAhFvqGDD5B7366rIPD7PDbAmqq4CO0ZnHbdM4=" crossorigin="anonymous"></script>|g' /usr/local/CyberCP/filemanager/templates/filemanager/index.html
sed -i 's|https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular.js|https://cdn.jsdelivr.net/npm/angular@1.6.5/angular.min.js|g' /usr/local/CyberCP/loginSystem/templates/loginSystem/login.html
sed -i 's|https://code.angularjs.org/1.6.5/angular.min.js|https://cdn.jsdelivr.net/npm/angular@1.6.5/angular.min.js|g' /usr/local/CyberCP/loginSystem/templates/loginSystem/login.html
sed -i 's|https://code.angularjs.org/1.6.5/angular-route.min.js|https://cdn.jsdelivr.net/npm/angular-route@1.6.5/angular-route.min.js|g' /usr/local/CyberCP/loginSystem/templates/loginSystem/login.html
sed -i 's|https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular-route.js|https://cdn.jsdelivr.net/npm/angular-route@1.6.5/angular-route.min.js|g' /usr/local/CyberCP/loginSystem/templates/loginSystem/login.html
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.min.js|https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv.min.js|g' /usr/local/lscp/cyberpanel/static/filemanager/js/ace/snippets/html.js
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv-printshiv.min.js|https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv-printshiv.min.js|g' /usr/local/lscp/cyberpanel/static/filemanager/js/ace/snippets/html.js
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.min.js|https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv.min.js|g' /usr/local/CyberCP/filemanager/static/filemanager/js/ace/snippets/html.js
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv-printshiv.min.js|https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv-printshiv.min.js|g' /usr/local/CyberCP/filemanager/static/filemanager/js/ace/snippets/html.js
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/openlayers/2.13.1/OpenLayers.js|https://cdn.jsdelivr.net/npm/@visallo/openlayers2@2.13.1/lib/OpenLayers.js|g' /usr/local/CyberCP/lib/python2.7/site-packages/django/contrib/gis/admin/options.py
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/ol3/3.20.1/ol.css|https://cdn.jsdelivr.net/npm/openlayers@3.20.1/dist/ol.css|g' /usr/local/CyberCP/lib/python2.7/site-packages/django/contrib/gis/forms/widgets.py
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/ol3/3.20.1/ol.js|https://cdn.jsdelivr.net/npm/openlayers@3.20.1/dist/ol.js|g' /usr/local/CyberCP/lib/python2.7/site-packages/django/contrib/gis/forms/widgets.py
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.min.js|https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv.min.js|g' /usr/local/CyberCP/cyberpanel.min.js
sed -i 's|https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv-printshiv.min.js|https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv-printshiv.min.js|g' /usr/local/CyberCP/cyberpanel.min.js
sed -i 's|<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">|<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0-beta.2/dist/css/bootstrap.min.css" integrity="sha256-QUyqZrt5vIjBumoqQV0jM8CgGqscFfdGhN+nVCqX0vc=" crossorigin="anonymous">|g' /usr/local/CyberCP/filemanager/templates/filemanager/index.html
sed -i 's|<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>|<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0-beta.2/dist/js/bootstrap.min.js" integrity="sha256-GIa8Vh3sfESnVB2CN3rYGkD/MklvMq0lmITweQxE1qU=" crossorigin="anonymous"></script>|g' /usr/local/CyberCP/filemanager/templates/filemanager/index.html
echo -e "\nStatic files have been set to use jsdeliver"
}

after_install() {
if grep "CyberPanel installation successfully completed" /var/log/installLogs.txt > /dev/null; then 

	if [[ $cdn_replace = "1" ]] ; then
		cdn_replace
	fi
	
	if [[ $addons_php_memcached = "1" ]] ; then
		install_php_memcached
		echo "Memcached extension installed..."
	fi
	
	if [[ $addons_lsmcd = "1" ]] ; then
			install_lsmcd
		echo "LiteSpeed Memcached installed..."
	fi
	
	if [[ $addons_memcached = "1" ]] ; then
     install_memcached
		echo "Memcached installed..."
	fi
	
	if [[ $addons_php_redis = "1" ]] ; then
		install_php_redis
		echo "Redis extension installed..."
	fi
	
	if [[ $addons_redis = "1" ]] ; then
		install_redis
	echo "Redis installed..."
	fi

if [[ $OS = "centos" ]] ; then
yum install -y lsphp54-devel lsphp55-devel lsphp56-devel lsphp70-devel lsphp71-devel lsphp72-devel lsphp73-devel make gcc glibc-devel libmemcached-devel zlib-devel
mkdir /usr/local/lsws/lsphp{54,55,56,70,71,72,73}/tmp
/usr/local/lsws/lsphp54/bin/pear config-set temp_dir /usr/local/lsws/lsphp54/tmp
/usr/local/lsws/lsphp55/bin/pear config-set temp_dir /usr/local/lsws/lsphp55/tmp
/usr/local/lsws/lsphp56/bin/pear config-set temp_dir /usr/local/lsws/lsphp56/tmp
/usr/local/lsws/lsphp70/bin/pear config-set temp_dir /usr/local/lsws/lsphp70/tmp
/usr/local/lsws/lsphp71/bin/pear config-set temp_dir /usr/local/lsws/lsphp71/tmp
/usr/local/lsws/lsphp72/bin/pear config-set temp_dir /usr/local/lsws/lsphp72/tmp
/usr/local/lsws/lsphp73/bin/pear config-set temp_dir /usr/local/lsws/lsphp73/tmp

/usr/local/lsws/lsphp54/bin/pecl install timezonedb
/usr/local/lsws/lsphp55/bin/pecl install timezonedb
/usr/local/lsws/lsphp56/bin/pecl install timezonedb
/usr/local/lsws/lsphp70/bin/pecl install timezonedb
/usr/local/lsws/lsphp71/bin/pecl install timezonedb
/usr/local/lsws/lsphp72/bin/pecl install timezonedb
/usr/local/lsws/lsphp73/bin/pecl install timezonedb
echo "extension=timezonedb.so" > /usr/local/lsws/lsphp54/etc/php.d/20-timezone.ini
echo "extension=timezonedb.so" > /usr/local/lsws/lsphp55/etc/php.d/20-timezone.ini
echo "extension=timezonedb.so" > /usr/local/lsws/lsphp56/etc/php.d/20-timezone.ini
echo "extension=timezonedb.so" > /usr/local/lsws/lsphp70/etc/php.d/20-timezone.ini
echo "extension=timezonedb.so" > /usr/local/lsws/lsphp71/etc/php.d/20-timezone.ini
echo "extension=timezonedb.so" > /usr/local/lsws/lsphp72/etc/php.d/20-timezone.ini
echo "extension=timezonedb.so" > /usr/local/lsws/lsphp73/etc/php.d/20-timezone.ini
sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp53/etc/php.ini
sed -i 's/mail.add_x_header = On/mail.add_x_header = Off/g' /usr/local/lsws/lsphp53/etc/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp54/etc/php.ini
sed -i 's/mail.add_x_header = On/mail.add_x_header = Off/g' /usr/local/lsws/lsphp54/etc/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp55/etc/php.ini
sed -i 's/mail.add_x_header = On/mail.add_x_header = Off/g' /usr/local/lsws/lsphp55/etc/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp56/etc/php.ini
sed -i 's/mail.add_x_header = On/mail.add_x_header = Off/g' /usr/local/lsws/lsphp56/etc/php.ini
fi

if [[ $OS = "ubuntu" ]] ; then
apt-get install libmagickwand-dev pkg-config build-essential -y

mkdir /usr/local/lsws/cyberpanel-tmp
cd /usr/local/lsws/cyberpanel-tmp
wget https://pecl.php.net/get/timezonedb-2019.1.tgz
tar xzvf timezonedb-2019.1.tgz
cd timezonedb-2019.1
/usr/local/lsws/lsphp70/bin/phpize
./configure --with-php-config=/usr/local/lsws/lsphp70/bin/php-config7.0
make
make install
echo "extension=timezonedb.so" >> /usr/local/lsws/lsphp70/etc/php/7.0/mods-available/20-timezone.ini
make clean

/usr/local/lsws/lsphp71/bin/phpize7.1
./configure --with-php-config=/usr/local/lsws/lsphp71/bin/php-config7.1
make
make install
echo "extension=timezonedb.so" >> /usr/local/lsws/lsphp71/etc/php/7.1/mods-available/20-timezone.ini
make clean

/usr/local/lsws/lsphp72/bin/phpize7.2
./configure --with-php-config=/usr/local/lsws/lsphp72/bin/php-config7.2
make
make install
echo "extension=timezonedb.so" >> /usr/local/lsws/lsphp72/etc/php/7.2/mods-available/20-timezone.ini
make clean

/usr/local/lsws/lsphp73/bin/phpize7.3
./configure --with-php-config=/usr/local/lsws/lsphp73/bin/php-config7.3
make
make install
echo "extension=timezonedb.so" >> /usr/local/lsws/lsphp73/etc/php/7.3/mods-available/20-timezone.ini
make clean

sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp70/etc/php/7.0/litespeed/php.ini
sed -i 's/mail.add_x_header = On/mail.add_x_header = Off/g' /usr/local/lsws/lsphp70/etc/php/7.0/litespeed/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp71/etc/php/7.1/litespeed/php.ini
sed -i 's/mail.add_x_header = On/mail.add_x_header = Off/g' /usr/local/lsws/lsphp71/etc/php/7.1/litespeed/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp72/etc/php/7.2/litespeed/php.ini
sed -i 's/mail.add_x_header = On/mail.add_x_header = Off/g' /usr/local/lsws/lsphp72/etc/php/7.2/litespeed/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp73/etc/php/7.3/litespeed/php.ini
sed -i 's/mail.add_x_header = On/mail.add_x_header = Off/g' /usr/local/lsws/lsphp73/etc/php/7.3/litespeed/php.ini
rm -rf /usr/local/lsws/cyberpanel-tmp

fi

systemctl restart lsws
rm -rf /etc/profile.d/cyberpanel*
curl --silent -o /etc/profile.d/cyberpanel.sh https://cyberpanel.sh/?banner 2>/dev/null
chmod +x /etc/profile.d/cyberpanel.sh
RAM2=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
DISK2=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')
ELAPSED="$(($SECONDS / 3600)) hrs $((($SECONDS / 60) % 60)) min $(($SECONDS % 60)) sec"
MYSQLPASSWD=$(cat /etc/cyberpanel/mysqlPassword)
python /usr/local/CyberCP/plogical/adminPass.py --password $ADMIN_PASS
systemctl restart lscpd
echo "python /usr/local/CyberCP/plogical/adminPass.py --password \$@" > /usr/bin/adminPass
echo "systemctl restart lscpd" >> /usr/bin/adminPass
chmod +x /usr/bin/adminPass
if [[ $version = "ols" ]] ; then
word="OpenLiteSpeed"
fi
if [[ $size = "19" ]] ; then
word="LiteSpeed Enterprise"
fi
clear
echo "###################################################################"
echo "                CyberPanel Successfully Installed                  "
echo "                                                                   "
echo "                Current Disk usage : $DISK2                        "
echo "                                                                   "
echo "                Current RAM  usage : $RAM2                         "
echo "                                                                   "
echo "                Installation time  : $ELAPSED                      "
echo "                                                                   "
echo "                Visit: https://$server_ip:8090                     "
echo "                Panel username: admin                              "
echo "                Panel password: $ADMIN_PASS                            "
#echo "                Mysql username: root                               "
#echo "                Mysql password: $MYSQLPASSWD                       "
echo "                                                                   "
echo "            Please change your default admin password              "
echo "          If you need to reset your panel password, please run:    "
echo "        	adminPass YOUR_NEW_PASSWORD     					   "
echo "                                                                   "
echo "          If you change mysql password, please  modify file in     "
echo -e "         \e[31m/etc/cyberpanel/mysqlPassword\e[39m with new password as well   "
echo "                                                                   "
echo "              Website : https://www.cyberpanel.net                 "
echo "              Forums  : https://forums.cyberpanel.net              "
echo "              Wikipage: https://docs.cyberpanel.net                "
echo "                                                                   "
echo -e "            Enjoy your accelerated Internet by                  "
echo -e "                CyberPanel & $word					                     "
echo "###################################################################"
exit		
else
echo -e "\nSomething went wrong..."
fi
}

set_mariadb() {
if [[ $MariaDB = "101" ]] ; then
echo "MariaDB 10.1 will be installed"
elif [[ $MariaDB = "101" ]] ; then
cd mysql
sed -i 's/\/10.0\//\/10.1\//g' MariaDB.repo
cd -
echo "MariaDB 10.1 will be installed"
elif [[ $MariaDB = "101" ]] ; then
cd mysql
sed -i 's/\/10.0\//\/10.1\//g' MariaDB.repo
cd -
echo "MariaDB 10.1 will be installed"
else
echo "Seems something went wrong?"
exit
fi
}

source_replace() {
if [[ $OS = "ubuntu" ]] ; then
	if [[ $download_server = "lax.cyberpanel.sh" ]] ; then
	echo "89.208.248.38 rpms.litespeedtech.com" >> /etc/hosts
	echo -e "Mirror server set..."
fi
	if [[ $download_server = "sgp.cyberpanel.sh" ]] ; then
	echo "47.88.237.203 rpms.litespeedtech.com" >> /etc/hosts
	echo -e "Mirror server set..."
fi
	if [[ $download_server = "fra.cyberpanel.sh" ]] ; then
	echo "51.68.59.108 rpms.litespeedtech.com" >> /etc/hosts
	echo -e "Mirror server set..."
fi
else	
echo "89.208.248.38 rpms.litespeedtech.com" >> /etc/hosts
echo -e "Mirror server set..."
fi


if [[ $OS = "centos" ]] ; then
cd mysql
sed -i 's|http://yum.mariadb.org/10.0/centos7-amd64|https://'$download_server'/mariadb/10.1/|g' MariaDB.repo
sed -i 's|http://yum.mariadb.org/10.1/centos7-amd64|https://'$download_server'/mariadb/10.1/|g' MariaDB.repo
sed -i 's|\[mariadb\]|\[mariadb-mirror\]|g' MariaDB.repo
cd -
echo -e "Mirror server set..."
fi

if [[ $OS = "centos" ]] ; then
	if [[ $download_server = "lax.cyberpanel.sh" ]] ; then
	echo "89.208.248.38 mirror.cyberpanel.net" >> /etc/hosts
	echo -e "Mirror server set..."
fi
	if [[ $download_server = "sgp.cyberpanel.sh" ]] ; then
	echo "47.88.237.203 mirror.cyberpanel.net" >> /etc/hosts
	echo -e "Mirror server set..."
fi
	if [[ $download_server = "fra.cyberpanel.sh" ]] ; then
	echo "51.68.59.108 mirror.cyberpanel.net" >> /etc/hosts
	echo -e "Mirror server set..."
fi
else	
echo "89.208.248.38 rpms.litespeedtech.com" >> /etc/hosts
echo -e "Mirror server set..."
fi


cat << EOF > mirror.py
#!/usr/bin/python
# -*- coding: UTF-8 -*-
import sys
import subprocess
import os
import shlex
with open('install.py', 'r') as file :
  filedata = file.read()
filedata = filedata.replace('http://', "https://")
filedata = filedata.replace('wget https://rpms.litespeedtech.com/debian/', "wget --no-check-certificate https://rpms.litespeedtech.com/debian/")
filedata = filedata.replace('wget https://cyberpanel.net/CyberPanel.', "wget https://$download_server/CyberPanel.")
filedata = filedata.replace('https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip', "https://$download_server/misc/rainloop-community-latest.zip")
filedata = filedata.replace('https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.zip', "https://$download_server/misc/phpMyAdmin-4.8.2-all-languages.zip")
filedata = filedata.replace('cmd.append("rpm")', "command = 'curl -o /etc/yum.repos.d/litespeed.repo https://$download_server/litespeed/litespeed.repo'")
filedata = filedata.replace('cmd.append("-ivh")', "cmd = shlex.split(command)")
filedata = filedata.replace('cmd.append("https://rpms.litespeedtech.com/centos/litespeed-repo-1.1-1.el7.noarch.rpm")', "")
with open('install.py', 'w') as file:
  file.write(filedata)
with open('installCyberPanel.py', 'r') as file :
	filedata = file.read()
filedata = filedata.replace('https://repo.powerdns.com/repo-files/centos-auth-master.repo', "https://$download_server/powerdns/powerdns.repo")
with open('installCyberPanel.py', 'w') as file:
  file.write(filedata)
EOF
python mirror.py
}

start_install() {

download_server=lax.cyberpanel.sh

server_test

if [[ $fastest_server == $server1 ]] ; then
	download_server=$server1
elif [[ $fastest_server == $server2 ]] ; then
	download_server=$server2
elif [[ $fastest_server == $server3 ]] ; then
	download_server=$server3
else
echo "Seems something went wrong..."
fi

SECONDS=0

if [ ! -e "/etc/cyberpanel/machineIP" ]; then

if [[ $OS = "centos" ]] ; then
yum install bc wget which curl -y
fi

#server_ip="$(wget -qO- http://whatismyip.akamai.com/)"
server_ip="$(curl https://cyberpanel.sh/?ip)"
wget https://$download_server/install.tar.gz

if [[ $OS = "ubuntu" ]] ; then
apt-get clean all
apt-get update -y
apt-get install -y curl python python-minimal python-setuptools bc

if [ -e "/usr/sbin/aliyun-service" ]; then
	if [[ $mirror = "1" ]] ; then
echo "" > /etc/apt/sources.list
#163源
cat << 'EOF' > /etc/apt/sources.list
deb http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF
pip config set global.index-url https://mirrors.163.com/pypi/simple

# 清华源
#deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
#deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
#deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
#deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
#pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
apt-get clean all
apt-get update -y
else
echo "" > /etc/apt/sources.list
cat << 'EOF' > /etc/apt/sources.list
deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse
EOF
pip config set global.index-url https://pypi.org/simple
apt-get clean all
apt-get update -y
fi
fi
fi

if [[ $OS = "centos" ]] ; then
rpm --import https://$download_server/mariadb/RPM-GPG-KEY-MariaDB
rpm --import https://$download_server/litespeed/RPM-GPG-KEY-litespeed
rpm --import https://$download_server/powerdns/CBC8B383-pub.asc
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
yum autoremove epel-release -y
rm -f /etc/yum.repos.d/epel.repo
rm -f /etc/yum.repos.d/epel.repo.rpmsave
yum install epel-release -y
yum clean all
yum update -y
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
fi

tar xzvf install.tar.gz
cd install
sed -i 's|cyberpanel.sh|'$download_server'|g' install.py

sed -i 's|https://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64//postfix3-3.2.4-1.gf.el7.x86_64.rpm|https://'$download_server'/misc/postfix3-3.2.4-1.gf.el7.x86_64.rpm|g' install.py
sed -i 's|https://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64//postfix3-mysql-3.2.4-1.gf.el7.x86_64.rpm|https://'$download_server'/misc/postfix3-mysql-3.2.4-1.gf.el7.x86_64.rpm|g' install.py
sed -i 's|http://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64//postfix3-3.2.4-1.gf.el7.x86_64.rpm|https://'$download_server'/misc/postfix3-3.2.4-1.gf.el7.x86_64.rpm|g' install.py
sed -i 's|http://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64//postfix3-mysql-3.2.4-1.gf.el7.x86_64.rpm|https://'$download_server'/misc/postfix3-mysql-3.2.4-1.gf.el7.x86_64.rpm|g' install.py

sed -i 's|mirror.cyberpanel.net/pip|'$download_server'/pip|g' install.py
sed -i 's|mirror.cyberpanel.net/urllib|'$download_server'/urllib|g' install.py
sed -i 's|mirror.cyberpanel.net/requests|'$download_server'/requests|g' install.py
chmod +x install.py

if [[ $mirror = "1" ]] ; then
source_replace
fi

if [[ $OS = "centos" ]] ; then
set_mariadb

if [ -e "/usr/sbin/aliyun-service" ]; then
yum install python-pip -y
yum install libcurl-devel -y
pip install setuptools==40.8.0
pip install https://$download_server/pip/certbot-0.21.1.tar.gz
fi
fi
echo -e "Preparing..."
echo -e "Installation will start in 10 seconds, if you wish to stop please press CTRL + C"
sleep 10
if [[ $size = "19" ]] ; then
echo "server IP is '$server_ip'"
python install.py $server_ip $serial_no $license_key $minimal
after_install
fi

if [[ $version = "ols" ]] ; then
	echo "server IP is '$server_ip'"
python install.py $server_ip $minimal
after_install
fi

else
echo "You already have CyberPanel installed, exiting..."
exit 1
fi

}

manual_input3() {

#echo -e "\nInstall minimal service for CyberPanel? This will skip PowerDNS, Postfix and Dovecot."
#printf "%s" "Minimal installation [y/N]: "
#read TMP_YN
#if [ `expr "x$TMP_YN" : 'x[Yy]'` -gt 1 ]; then
#min=1
#minimal="--minimal 1"
#fi

echo -e "\nPlease choose to use default admin password \e[31m1234567\e[39m, randomly generate one \e[31m(recommended)\e[39m or specify the admin password?"
printf "%s" "Choose [d]fault, [r]andom or [s]et password: [d/r/s] "
read TMP_YN

if [ -z "$TMP_YN" ] ; then
echo -e "\nAdmin password will be set as 1234567\n"
ADMIN_PASS=1234567
elif [ `expr "x$TMP_YN" : 'x[Dd]'` -gt 1 ]; then
echo -e "\nAdmin password will be set as 1234567\n"
ADMIN_PASS=1234567
elif [ `expr "x$TMP_YN" : 'x[Rr]'` -gt 1 ]; then
ADMIN_PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16 ; echo '')
echo -e "\nAdmin password will be provided once installation completed...\n"
elif [ `expr "x$TMP_YN" : 'x[Ss]'` -gt 1 ]; then
	echo -e "\nPlease enter your password:"
	printf "%s" ""
	read TMP_YN
	if [ -z "$TMP_YN" ] ; then
  echo -e "\nPlease do not use empty string...\n"
	exit 4
	fi
	if [ ${#TMP_YN} -lt 8 ] ; then
	echo -e "\nPassword lenth less than 8 digital, please choose a more complicated password.\n"
	exit 4
	fi
	TMP_YN1=$TMP_YN
	echo -e "\nPlease repeat your password:\n"
	printf "%s" ""
	read TMP_YN
	if [ -z "$TMP_YN" ] ; then
  echo -e "\nPlease do not use empty string...\n"
	exit 4
	fi
	TMP_YN2=$TMP_YN
	if [ $TMP_YN1 = $TMP_YN2 ] ; then
		ADMIN_PASS=$TMP_YN1
	else
	echo -e "\nRepeated password didn't match , please check...\n"
	exit 4
fi
else
echo -e "\nAdmin password will be set as 1234567\n"
ADMIN_PASS=1234567
fi

#echo -e "\nInstalling from official server or mirror server?\n\nMirror server network is optimized for \e[31mAsia Pacific region\e[39m...\nIf you experience very slow download speed during installation, please try use mirror server on clean system..."
#printf "%s" "Use mirror server [y/N]: "
#read TMP_YN
#if [ `expr "x$TMP_YN" : 'x[Yy]'` -gt 1 ]; then
mirror=1
#fi

echo -e "\nReplace JS/CSS files to JS Delivr?\nThis may improve panel loading speed in \e[31mAsia Pacific region\e[39m... "
printf "%s" "Please select [y/N]: "
read TMP_YN
if [ `expr "x$TMP_YN" : 'x[Yy]'` -gt 1 ]; then
cdn_replace=1
fi


echo -e "\nInstall Memcached extension for PHP?"
printf "%s" "Please select [y/N]: "
read TMP_YN
if [ `expr "x$TMP_YN" : 'x[Yy]'` -gt 1 ]; then
addons_php_memcached=1
fi

echo -e "\nInstall LiteSpeed Memcached?"
printf "%s" "Please select [y/N]: "
read TMP_YN
if [ `expr "x$TMP_YN" : 'x[Yy]'` -gt 1 ]; then
addons_lsmcd=1
fi

if [ "$addons_lsmcd" != "1" ]; then
echo -e "\nInstall Memcached?"
printf "%s" "Please select [y/N]: "
read TMP_YN
if [ `expr "x$TMP_YN" : 'x[Yy]'` -gt 1 ]; then
addons_memcached=1
fi
fi

echo -e "\nInstall Redis extension for PHP?"
printf "%s" "Please select [y/N]: "
read TMP_YN
if [ `expr "x$TMP_YN" : 'x[Yy]'` -gt 1 ]; then
addons_php_redis=1
fi


echo -e "\nInstall Redis?"
printf "%s" "Please select [y/N]: "
read TMP_YN
if [ `expr "x$TMP_YN" : 'x[Yy]'` -gt 1 ]; then
addons_redis=1
fi
start_install
}

license_input() {
version="ent"
printf "%s" "Please input your serial number for LiteSpeed WebServer Enterprise:"
read license_key
if [ -z "$license_key" ] ; then
echo -e "\nPlease provide license key\n"
exit 4
fi

echo -e "The serial number you input is: \e[31m$license_key\e[39m"
printf "%s"  "Please verify it is correct. [y/N]"
read TMP_YN
if [ -z "$TMP_YN" ] ; then
echo -e "\nPlease type \e[31my\e[39m\n"
exit 4
fi

size=${#license_key}

if [[ $size = "19" ]] ; then
serial_no="--ent ent --serial "
MariaDB="101"
manual_input3
else
echo -e "\nLicense key seems incorrect, please verify\n"
echo -e "\nIf you are copying/pasting, please make sure you didn't paste blank space...\n"
exit 1
fi
}

manual_input2() {
RAM=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
DISK=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')
clear
echo -e "		CyberPanel Installer v2.0

  RAM check : $RAM 
  
  Disk check : $DISK (Minimal \e[31m10GB\e[39m free space)

  1. Install CyberPanel with \e[31mOpenLiteSpeed\e[39m.
  
  2. Install Cyberpanel with \e[31mLiteSpeed Enterprise\e[39m.
  
  3. Exit.
  
  "
read -p "Please enter the number[1-3]: " num
echo ""
case "$num" in
	1)
	version="ols"
	MariaDB="101"
	manual_input3
	;;
	2)
	license_input
	;;
	3)
	exit
	;;
	*)
	echo -e "${Error} please enter the right number [1-3]"
	;;
esac
}

enable_php_error() {
echo -e "IMPORTANT: This will \e[31menable\e[39m PHP error log for all domains in your server. 
           PHP error log will be \e[31m/home/SITE_DOMAIN/public_html/php_errors.log\e[39m
           This will restart OpenLiteSpeed and LSPHP process(es).
           Please confirm to proceed by typing \e[31mYes\e[39m with capital \e[31mY\e[39m!\n"
        printf "%s" "Are you sure what you are doing here? "  
        read YES_NO
        if [ "x$YES_NO" != "xYes" ]; then
                echo "Sorry, wrong answer! Type 'Yes' with capital 'Y', try again!"
        else
sed -i 's|;error_log = php_errors.log|error_log = php_errors.log|g' /usr/local/lsws/lsphp54/etc/php.ini
sed -i 's|;error_log = php_errors.log|error_log = php_errors.log|g' /usr/local/lsws/lsphp55/etc/php.ini
sed -i 's|;error_log = php_errors.log|error_log = php_errors.log|g' /usr/local/lsws/lsphp56/etc/php.ini
sed -i 's|;error_log = php_errors.log|error_log = php_errors.log|g' /usr/local/lsws/lsphp70/etc/php.ini
sed -i 's|;error_log = php_errors.log|error_log = php_errors.log|g' /usr/local/lsws/lsphp71/etc/php.ini
sed -i 's|;error_log = php_errors.log|error_log = php_errors.log|g' /usr/local/lsws/lsphp72/etc/php.ini
sed -i 's|;error_log = php_errors.log|error_log = php_errors.log|g' /usr/local/lsws/lsphp73/etc/php.ini
sed -i 's|error_reporting = E_ALL &amp; ~E_DEPRECATED &amp; ~E_STRICT|error_reporting = E_ALL|g' /usr/local/lsws/lsphp54/etc/php.ini
sed -i 's|error_reporting = E_ALL &amp; ~E_DEPRECATED &amp; ~E_STRICT|error_reporting = E_ALL|g' /usr/local/lsws/lsphp55/etc/php.ini
sed -i 's|error_reporting = E_ALL &amp; ~E_DEPRECATED &amp; ~E_STRICT|error_reporting = E_ALL|g' /usr/local/lsws/lsphp56/etc/php.ini
sed -i 's|error_reporting = E_ALL &amp; ~E_DEPRECATED &amp; ~E_STRICT|error_reporting = E_ALL|g' /usr/local/lsws/lsphp70/etc/php.ini
sed -i 's|error_reporting = E_ALL &amp; ~E_DEPRECATED &amp; ~E_STRICT|error_reporting = E_ALL|g' /usr/local/lsws/lsphp71/etc/php.ini
sed -i 's|error_reporting = E_ALL &amp; ~E_DEPRECATED &amp; ~E_STRICT|error_reporting = E_ALL|g' /usr/local/lsws/lsphp72/etc/php.ini
sed -i 's|error_reporting = E_ALL &amp; ~E_DEPRECATED &amp; ~E_STRICT|error_reporting = E_ALL|g' /usr/local/lsws/lsphp73/etc/php.ini
systemctl restart lsws
killall lsphp
echo -e "\n\n\nPHP error log enabled...\n\n\n"
php_error_log
        fi
}

disable_php_error() {
echo -e "IMPORTANT: This will \e[31mdisable\e[39m PHP error log for all domains in your server. 
           This will restart OpenLiteSpeed and LSPHP process(es).
           Please confirm to proceed by typing \e[31mYes\e[39m with capital \e[31mY\e[39m!\n"
        printf "%s" "Are you sure what you are doing here? "  
        read YES_NO
        if [ "x$YES_NO" != "xYes" ]; then
                echo "Sorry, wrong answer! Type 'Yes' with capital 'Y', try again!"
        else
sed -i 's|error_log = php_errors.log|;error_log = php_errors.log|g' /usr/local/lsws/lsphp54/etc/php.ini
sed -i 's|error_log = php_errors.log|;error_log = php_errors.log|g' /usr/local/lsws/lsphp55/etc/php.ini
sed -i 's|error_log = php_errors.log|;error_log = php_errors.log|g' /usr/local/lsws/lsphp56/etc/php.ini
sed -i 's|error_log = php_errors.log|;error_log = php_errors.log|g' /usr/local/lsws/lsphp70/etc/php.ini
sed -i 's|error_log = php_errors.log|;error_log = php_errors.log|g' /usr/local/lsws/lsphp71/etc/php.ini
sed -i 's|error_log = php_errors.log|;error_log = php_errors.log|g' /usr/local/lsws/lsphp72/etc/php.ini
systemctl restart lsws
echo -e "\n\n\nPHP error log disabled...\n\n\n"
php_error_log
        fi
}

clean_php_error() {
echo -e "IMPORTANT: This will remove all \e[31m/home/SITE_DOMAIN/public_html/php_error.log\e[39m.
           Please confirm to proceed by typing \e[31mYes\e[39m with capital \e[31mY\e[39m!\n"
        printf "%s" "Are you sure what you are doing here? "  
        read YES_NO
        if [ "x$YES_NO" != "xYes" ]; then
                echo "Sorry, wrong answer! Type 'Yes' with capital 'Y', try again!"
        else
rm -f /home/*/public_html/php_errors.log
echo -e "\n\n\nAll php_errors.log files have been removed...\n\n\n"
php_error_log
        fi
}

php_error_log() {
if [ ! -e "/etc/cyberpanel/machineIP" ]; then
echo -e "\nYou don't have CyberPanel installed...\n"
exit
else
echo -e "\n\n\nBy default, PHP error log is not enabled, you can easily enbale ot disable it for debug.
	1. Enable PHP error log.
	2. Disable PHP error log.
	3. Clean all PHP error log. 
	4. Return to main page.
	5. Exit.
  "
echo && read -p "Please enter the number[1-5]: " num
case "$num" in
	1)
	enable_php_error
	;;
	2)
	disable_php_error
	;;
	3)
	clean_php_error
	;;
	4)
	manual_input
	;;
	5)
	exit
	;;
	*)
	echo -e "${Error} please enter the right number [1-5]"
	;;
esac
fi	
}

manual_addons3() {
	if [[ $addons_php_memcached = "1" ]]; then
		install_php_memcached
	fi
	if [[ $addons_lsmcd = "1" ]]; then
		if systemctl is-active --quiet lsmcd; then
			echo "You have already install LiteSpeed Memcached..."
		else
			if systemctl is-active --quiet memcached; then
				echo "You have already install Memcached..."
			else
				install_lsmcd
	fi
	fi
	fi
	if [[ $addons_memcached = "1" ]]; then
				if systemctl is-active --quiet lsmcd; then
			echo "You have already install LiteSpeed Memcached..."
		else
			if systemctl is-active --quiet memcached; then
				echo "You have already install Memcached..."
			else
				install_memcached
		fi
	fi
  fi
  if [[ $addons_php_redis = "1" ]]; then
				install_php_redis
	fi
  if [[ $addons_redis = "1" ]]; then
  	if systemctl is-active --quiet redis; then
  		echo "You have already installed Redis..."
  	else
			install_redis
fi
	fi
	
  if [[ $cdn_replace = "1" ]]; then
	cdn_replace
fi

exit
}

manual_addons2() {
if [ ! -e "/etc/cyberpanel/machineIP" ]; then
echo -e "\nYou don't have CyberPanel installed...\n"
exit
fi

if [[ $OS = centos ]] ; then

echo -e "		CyberPanel Addons v2.0
	1. Replace JS/CSS links to jsdelivr (Recommended for Asia Pacific region. CentOS only...)
	2. Install LiteSpeed Memcached.
	3. Install Memcached.
	4. Install PHP extension for Memcached.
	5. Install Redis.
	6. Install PHP extension for Redis.
	7. Enable/Disable PHP error log.
	8. Return to main page.
	9. Exit
  "
 
echo && read -p "Please enter the number[1-9]: " num
case "$num" in
	1)
	cdn_replace=1
	manual_addons3
	;;
	2)
	addons_lsmcd=1
	manual_addons3
	;;
	3)
	addons_memcached=1
	manual_addons3
	;;
	4)
	addons_php_memcached=1
	manual_addons3
	;;
	5)
	addons_redis=1
	manual_addons3
	;;
	6)
	addons_php_redis=1
	manual_addons3
	;;
	7)
	php_error_log
	;;
	8)
	manual_input
	;;
	9)
	exit
	;;
	*)
	echo -e "${Error} please enter the right number [1-9]"
	;;
esac
fi

if [[ $OS = ubuntu ]] ; then

echo -e "		CyberPanel Addons v2.0
	1. Enable/Disable PHP error log.
	2. Return to main page.
	3. Exit
  "
 
echo && read -p "Please enter the number[1-3]: " num
case "$num" in
	1)
	php_error_log
	;;
	2)
	manual_input
	;;
	3)
	exit
	;;
	*)
	echo -e "${Error} please enter the right number [1-9]"
	;;
esac
fi
}

manual_addons() {
if [ -d /usr/local/CyberCP ]; then
		echo -e "\nCyberPanel detected...\n"
		manual_addons2
else
echo -e "\nCyberPanel is not detected, aborting..."
exit 1
fi
}
manual_input() {
#this part ask user to choose install cyberpanel or addons.
echo -e "		CyberPanel Installer v2.0

  1. Install CyberPanel.
  
  2. Install Addons.
  
  3. Exit.
  
  "
read -p "Please enter the number[1-3]: " num
echo ""
case "$num" in
	1)
	manual_input2
	;;
	2)
	manual_addons
	;;
	3)
	exit
	;;
	*)
	echo -e "${Error} please enter the right number [1-3]"
	;;
esac
}

install() {
# define variables to default value in case argument is not supplied.
if [[ $MariaDB -eq 0 ]] ; then
		MariaDB=101
else
  if [[ $MariaDB == 101 ]] ; then
  	MariaDB=101
  elif [[ $MariaDB == 101 ]] ; then
  	MariaDB=101
  elif [[ $MariaDB == 101 ]] ; then
  	MariaDB=101
  else
	echo -e "\nUnknown paramater for MariaDB version"
	echo -e "\nPlease run \e[31m./cyberpanel.sh help\e[39m to see help information\n"
	MariaBD=101
	fi
fi
if [[ $mirror -eq 0 ]] ; then
		mirror=0
elif [[ $mirror == 1 ]] ; then
	mirror=1
	echo "set to use mirror server"
else
	echo -e "\nUnknown paramater for mirror server usage"
	echo -e "\nPlease run \e[31m./cyberpanel.sh help\e[39m to see help information\n"
	mirror=0
fi
if [[ $cdn_replace -eq 0 ]] ; then
		cdn_replace=0
elif [[ $cdn_replace == 1 ]] ; then
	cdn_replace=1
	echo "set to cdn replace"
else
	echo -e "\nUnknown paramater for CDN replacement"
	echo -e "\nPlease run \e[31m./cyberpanel.sh help\e[39m to see help information\n"
	cdn_replace=0
fi

if [ -z "$password" ] ; then
ADMIN_PASS=1234567
elif [[ $password == d ]] ; then
	ADMIN_PASS=1234567
	echo "use default password"
elif [[ $password == r ]] ; then
	ADMIN_PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16 ; echo '')
	echo "use random password"
else
	if [ ${#password} -lt 8 ] ; then
		echo "password is less than 8 digital, please use a more secure password."
	exit 4
	fi
	ADMIN_PASS=$password
	echo "use user specified password"
fi

if [[ $addons -eq 0 ]] ; then
		addons=0
elif [[ $addons == 1 ]] ; then
	addons=1
	addons_php_memcached=1
	addons_memcached=1
	addons_php_redis=1
	addons_redis=1
	echo "set to addons"
else
	echo -e "\nUnknown paramater for addons"
	echo -e "\nPlease run \e[31m./cyberpanel.sh help\e[39m to see help information\n"
	addons=0
fi
start_install
}

preinstall() {
size=${#version} 
if [[ $min = 1 ]] ; then
echo -e "\nInstaller will proceed with minimal configuration...\n"
echo -e "\nWaiting for 10 seconds, if you want to cancel, please press CTRL + C\n"
min=1
minimal="--minimal 1"
sleep 10
install
#check version variable size, if it's 19 then it's serial number...
elif [[ $default_set == 1 ]] ; then
#if argument is set to default, directly starts to installation with default configuration.
echo -e "\nInstaller will proceed with default configuration...\n"
echo -e "\nWaiting for 10 seconds, if you want to cancel, please press CTRL + C\n"
sleep 10
install
elif [[ $size == 19 ]] ; then
	serial_number=$version
	version="ent"
	serial_no="--ent ent --serial $serial_number"
install
#remove ols value from version varible just in case.
elif [[ $version == ols ]] ; then
	version="ols"
install
elif [ $# -eq 0 ] ; then
#in case of no argument or incorrect argument, go to manual.
manual_input
fi
}

check_root() {
#check root user.
echo -e "\nChecking root privileges...\n"
if [[ $(id -u) != 0 ]]  > /dev/null; then
    echo -e "You must use root account to do this"
    echo -e "sudo won't work."
    exit 1
else
echo -e "\nYou are runing on root...\n"
fi
}

check_OS() {
echo -e "\nChecking OS...\n"
if cat /etc/*release | grep CentOS  > /dev/null; then
# check if it's centos
	if cat /etc/redhat-release | grep 7.  > /dev/null; then
		#check if it's centos7
		echo -e "\nDetecting CentOS 7.X...\n"
		OS="centos"
	fi
elif cat /etc/*release | grep ID=ubuntu  > /dev/null; then
# check if it's ubuntu
	if cat /etc/*release | grep 18  > /dev/null; then
		#check if it's ubuntu 18
		echo -e "\nDetecting Ubuntu 18.x...\n"
		OS="ubuntu"
	fi
elif cat /etc/*release | grep CloudLinux  > /dev/null; then
# check if it's CloudLinux 7
	if cat /etc/redhat-release | grep 7.  > /dev/null; then
		#check if it's CloudLinux 7
		echo -e "\nDetecting CloudLinux 7.X...\n"
		OS="centos"
	fi
else
#return if not centos 7 nor ubuntu18
echo -e "\nUnable to detect your OS...\n"
echo -e "\nCyberPanel is supported on Ubuntu 18.x, CentOS 7.x and CloudLinux 7.x...\n"
exit 1
fi
}

show_help() {
echo -e "\nCyberPanel Installer Script Help\n"
echo -e "\nUsage: wget https://cyberpanel.sh/cyberpanel.sh"
echo -e "\nchmod +x cyberpanel.sh"
echo -e "\n./cyberpanel.sh -v ols/SERIAL_NUMBER -c 1 -a 1"
echo -e "\n -v: choose to install CyberPanel OpenLiteSpeed or CyberPanel Enterprise, available options are \e[31mols\e[39m and \e[31mSERIAL_NUMBER\e[39m, default ols"
echo -e "\n Please be aware, this serial number must be obtained from LiteSpeed Store."
echo -e "\n And if this serial number has been used before, it must be released/migrated in Store first, otherwise it will fail to start."
echo -e "\n -c: replace static JS/font files to JSdeliver.com, 1 for replace, 0 for not to replace, default 0"
echo -e "\n -a: install addons: memcached, redis, PHP extension for memcached and redis, 1 for install addons, 0 for not to install, default 0, only applicable for CentOS system."
echo -e "'n -p: set password of new installation, [d] for default 1234567, [r] for randomly generated 16 digital password, any other value besdies [d] and [r] will be accept as password, default use 1234567."
echo -e "\n Example:"
echo -e "\n ./cyberpanel.sh -v ols -p "
echo -e "\n This will install CyberPanel OpenLiteSpeed and randomly generate the password."
echo -e "\n ./cyberpanel.sh default"
echo -e "\n This will install everything default , which is OpenLiteSpeed, MariaDB 10.1 and nothing more\n"
#echo -e "\n ./cyberpanel.sh minimal"
#echo -e "\n This is same as default, but will skip PowerDNS, Postfix and Dovecot."
exit 1
}

check_panel() {
#check for cpanel...
if [ -d /usr/local/cpanel ]; then
		echo -e "\ncPanel detected...exit...\n"
		exit 1
fi
#check for plesk...
if [ -d /opt/plesk ]; then
		echo -e "\nPlesk detected...exit...\n"
		exit 1
fi
echo -e "\nPre-flight check completed...\n"
}

check_process() {
#check if apache is running, httpd on centos, apache2 on ubuntu
if systemctl is-active --quiet httpd; then
	systemctl disable httpd
	systemctl stop httpd
	echo -e "\nhttpd process detected, disabling...\n"
fi
if systemctl is-active --quiet apache2; then
	systemctl disable apache2
	systemctl stop apache2
	echo -e "\napache2 process detected, disabling...\n"
fi
#check if named DNS is running.
if systemctl is-active --quiet named; then
  systemctl stop named
  systemctl disable named
  	echo -e "\nnamed process detected, disabling...\n"
fi
#check if exim is running.
if systemctl is-active --quiet exim; then
	systemctl stop exim
	systemctl disable exim
		echo -e "\nexim process detected, disabling...\n"
fi
echo -e "\nProcess check completed...\n"
}

#this feature is made as per Tishu's suggestion.
#if argument is not define as followed, it will ignored and proceed as without any
if [ $# -eq 0 ] ; then
    echo -e "\nNo argument detected...\n"
else
	if [[ $1 == "help" ]] ; then
	show_help
	elif [[ $1 == "default" ]] ; then
	echo -e "\nThis will start default installation...\n"
	default_set=1
	version="ols"
	elif [[ $1 == "minimal" ]] ; then
		echo -e "\nThis will start minimal installation...\n"
		min=1
		version=ols
else
while getopts ":v:c:a:p:" opt
do
    case $opt in
        v)
        version=$OPTARG
        ;;
        c)
        cdn_replace=$OPTARG
        ;;
        a)
        addons=$OPTARG
        ;;
        p)
        password=$OPTARG
        ;;
        ?)
        echo -e "\nUnknown argument...\n"
        echo -e "\nPlease run \e[31m./cyberpanel.sh help\e[39m to see help information\n"
        exit 1;;
    esac
	done
	fi
fi

#if ! grep -q cyberpanel.sh /etc/hosts; then
#echo "89.208.248.38 cyberpanel.sh" >> /etc/hosts
#fi

check_root
#check if running as root
check_OS
#check OS to determinate what to do
check_panel
#check if cyberpanel,cpanel or plesk is installed on this server
check_process
#check if certain process like exim/postfix/httpd are running that occupying port that causes installation fail.
preinstall
#asking user to set variables
