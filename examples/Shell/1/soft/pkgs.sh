#!/usr/bin/env bash
# Author: Xiekers <imxieke@qq.com>
# Time: Saturday Nov 12,2016

##############################################################################
####### 		 Code list:							##########################
#Docker golang nodejs ohmyzsh proxychains-ng speedtest-cli
##############################################################################

case $! in

    base-u )
		echo "Ubuntu OS Base Tools && Software"
		sudo add-apt-repository ppa:git-core/ppa && \
		sudo apt-get install -y curl wget unzip git screen autoconf apt-transport-https \
		python-software-properties software-properties-common && \
        echo `git --version`
		;;

	base-c )
		echo "Centos OS Base Tools && Software"
		yum install -y curl wget unzip screen curl-devel expat-devel gettext-devel openssl-devel zlib-devel && \
        wget https://github.com/git/git/archive/master.zip && unzip master.zip && \
        cd git-master && make && make install && make clean && ln -s /usr/local/bin/git /usr/bin/git && \ 
        echo `git --version`
		;;

	compile )
      	sudo apt-get install autoconf
        wget http://zlib.net/zlib-1.2.8.tar.gz && tar -xzvf zlib-1.2.8.tar.gz
        ./configure && make && make install && make clean
         ;;

	docker )
		curl -sSL https://get.daocloud.io/docker | sh
		;;

	docker-os )
		curl -sSL https://get.docker.com/ | sh
		;;

	golang )
		cd /opt && wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz && \
		cd go && mkdir -p ~/go && \
		echo 'export GOROOT=/opt/go' >> $HOME/.bashrc && \
		echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc && \
		echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $HOME/.bashrc && \
		source $HOME/.bashrc && go version && \
		echo "Golang install success!"
		;;

	nginx )
    	sudo add-apt-repository ppa:nginx/stable
        sudo apt-get update && sudo apt-get -y install nginx
        ;;

    nginx-c )
        wget https://coding.net/u/imxieke/p/Code/git/raw/master/attchment/nginx.repo && mv nginx.repo /etc/yum.repos.d/nginx.repo
        yum update && yum install nginx -y 
        ;;

	nodejs )
		sudo apt-get install -y build-essential
		sudo curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
		sudo apt-get install -y nodejs
		;;

	ohmyzsh-cn )
		sudo apt install curl git -y && \
		sh -c "$(curl -fsSL https://coding.net/u/imxieke/p/oh-my-zsh/git/raw/master/tools/install.sh)"
		;;

	ohmyzsh-os )
		sudo apt install curl git -y && \
		sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
		;;

	proxychains-ng )
		pkg_name="proxychains-ng-4.11.tar.bz2"
		echo "start install proxychains-ng-4"
		wget https://dl.xieke.org/pkgs/src/$pkg_name && \
		tar -jxvf $pkg_name && cd proxychains-ng-4.11 && \
		mkdir -p ~/.proxychains && \ 
		wget https://dl.xieke.org/conf/proxychains.conf -O ~/.proxychains/proxychains.conf && \
		./configure --prefix=/usr --sysconfdir=/etc && \
		make && make install && \

		echo "proxychains-ng-4 install success"
		echo "please Change configuration file ~/.proxychains/proxychains.conf"
		;;

	speedtest-cli )
		cd ~ && mkdir temp && cd temp && \
		wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py && \
		chmod +x speedtest-cli
		;;

        update )
            echo "Warning: The operation Will update the Script!"
            cd $(pwd) && mv $(pwd)/install.sh $(pwd)/install.bak &&  wget https://coding.net/u/imxieke/p/Script/git/raw/master/install.sh
            rm $(pwd)/install.sh
            echo "update Sucress!"
            ;;
            
        help )
            echo "Usage: bash pkg.sh update| help "
            echo "Default OS is ubuntu,centos = package name + "-c", debian=d"
                ;;
        
        about )
            echo "###############################################"
            echo "# Warning:The Script Suitable ubuntu!			#"
            echo "# Author: Xiekers <im@xieke.org>     			#"
            echo "# update time: Sunday Aug 21 2016 2:37        #"
            echo "###############################################"
            ;;	

esac
