#!/usr/bin/env bash
PUBKEY="ABF5BD827BD9BF62"
DEPENDS="gpg grep awk curl wget "
WORKDIR="/tmp/lnmp-apt"

for pkg in ${DEPENDS}; do
	if [[ -z $(command -v ${pkg}) ]]; then
		# echo "Package: '" ${pkg} "' Not Found, Please continue after installation "
		echo "Package: '" ${pkg} "' Not Found"
		echo "Start Install" {pkg}

		if [[ ${pkg} == 'awk' ]]; then
			apt install -y gawk
		elif [[ ${pkg} == "gpg" ]]; then
			apt install -y gnupg
		else
			apt install -y ${pkg}
		fi
	fi
done

mkdir -p ${WORKDIR}
alias wget="wget --continue --no-check-certificate"

ARCH=$(uname -m)
CODENAME=$(grep UBUNTU_CODENAME /etc/os-release  | awk -F '=' '{print $2}')

pkg_nginx()
{
	if [[ ! -z $(grep nginx /etc/apt/sources.list ) ]]; then
		echo "Nginx Sources has Add to /etc/apt/sources.list"
	fi

	if [[ -f '/etc/apt/sources.list.d/nginx.list' ]]; then
		echo "Nginx Sources has Add to /etc/apt/sources.list.d/nginx.list"
	fi

	KEY="https://nginx.org/keys/nginx_signing.key"
	cd ${WORKDIR}
	curl -s  https://nginx.org/keys/nginx_signing.key | apt-key add
	echo "deb http://nginx.org/packages/ubuntu/ ${CODENAME} nginx" > /etc/apt/sources.list.d/nginx.list
	echo "deb-src http://nginx.org/packages/ubuntu/ ${CODENAME} nginx" > /etc/apt/sources.list.d/nginx.list

	# apt update 
	# apt install -y nginx

	# if [[ -z $(command -v nginx) ]]; then
		# echo "Package: 'nginx' Not Found, Please continue after installation "
	# fi
}

pkg_mongodb()
{
	# Add Package Key
	KEY_3_0="9ECBEC467F0CEB10"
	KEY="9DA31620334BD75D9DCB49F368818C72E52529D4" # 4.0 latest 2018
	SUPPORT_OS="trusty xenial bionic "
	if [ ${CODENAME} != 'trusty' ] && [ ${CODENAME} != 'xenial' ] && [ ${CODENAME} != 'bionic' ] ; then
		echo "UnSupport Platform Or System Version, Avaiable for trusty, xenial bionic  "
		exit 1
	fi

	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv ${KEY}
	echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu ${CODENAME}/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list
	
	# Hold Package 
	# echo "mongodb-org hold" | sudo dpkg --set-selections
	# echo "mongodb-org-server hold" | sudo dpkg --set-selections
	# echo "mongodb-org-shell hold" | sudo dpkg --set-selections
	# echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
	# echo "mongodb-org-tools hold" | sudo dpkg --set-selections
}

pkg_redis()
{
	KEY="B9316A7BC7917B12"
}

pkg_mongodb

pkg_install()
{
	apt update 
	apt install -y nginx
}
