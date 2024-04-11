#!/bin/sh
dnurl="http://www.xuanlove.download/hiwifi/"
ssredirfn="ss-redir.tar.gz"
adbybyfn="7620n.tar.gz"
undeadubootfn="uboot/hc5661-undeaduboot-141124.bin"
undeadubootMD5fn="uboot/undeaduboot.md5"
lintelubootfn="1"
lintelubootMD5fn="2"
bakall()
{
        echo -e "备份MTD0到mtd0.bin--------------------------------\c"
        cat /dev/mtd0 > mtd0.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份MTD1到mtd1.bin--------------------------------\c"
        cat /dev/mtd1 > mtd1.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份MTD2到mtd2.bin--------------------------------\c"
        cat /dev/mtd2 > mtd2.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份MTD3到mtd3.bin--------------------------------\c"
        cat /dev/mtd3 > mtd3.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份MTD4到mtd4.bin--------------------------------\c"
        cat /dev/mtd4 > mtd4.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份MTD5到mtd5.bin--------------------------------\c"
        cat /dev/mtd5 > mtd5.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份MTD6到mtd6.bin--------------------------------\c"
        cat /dev/mtd6 > mtd6.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份MTD7到mtd7.bin--------------------------------\c"
        cat /dev/mtd7 > mtd7.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份MTD8到mtd8.bin--------------------------------\c"
        cat /dev/mtd8 > mtd8.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份MTD9到mtd9.bin--------------------------------\c"
        cat /dev/mtd9 > mtd9.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份编程器固件到fullflash.bin---------------------\c"
        cat /dev/mtd0 /dev/mtd1 /dev/mtd2 /dev/mtd9 /dev/mtd6 /dev/mtd7 /dev/mtd8 > fullflash.bin
        echo -e "[\e[32m完成\e[37m]"
        echo -e "备份SD卡第一分区加密秘钥到sd-crypt-key.txt--------\c"
        /sbin/hi_crypto_key device-crypt-key > sd-crypt-key.txt
        echo -e "[\e[32m完成\e[37m]"
}
    
updateuboot()
{

    echo -e "备份uboot-----------------------------------------\c"
    if [ -d /tmp/data/filetransit0 ]; then
        rm -rf /tmp/data/filetransit0/mtd0.bin
        cat /dev/mtd0 > /tmp/data/filetransit0/mtd0.bin
        echo -e "[\e[32m完成\e[37m]"
        echo "备份文件名为mtd0.bin"
        echo "存放在/tmp/data/filetransit0 电脑打开\\\hiwifi.com可见"
    else
        rm -rf /root/mtd0.bin
        cat /dev/mtd0 > /root/mtd0.bin
        echo -e "[\e[32m完成\e[37m]"
        echo "备份文件名为mtd0.bin"
        echo "存放在/root,请及时取走"
    fi
    cd /tmp
    rm -rf ThirdFlameTemp
    mkdir ThirdFlameTemp
    cd ThirdFlameTemp
    echo "下载uboot文件-------------------------------------"

    curl -o uboot.bin -m 120 $dnurl$ubootfn
    if [ -f uboot.bin ]; then
        echo -e "--------------------------------------------------[\e[32m完成\e[37m]"
        echo "下载ubootMD5验证文件------------------------------"
        curl -o uboot.md5 -m 120 $dnurl$ubootMD5fn
        if [ -f uboot.md5 ]; then
            echo -e "--------------------------------------------------[\e[32m完成\e[37m]"
            find *.bin -print|xargs md5sum|sort > uboot.md5.local
            FILE=$( md5sum uboot.md5 |awk '{print $1 }' )
            FILE_1=$( md5sum uboot.md5.local |awk '{print $1 }' )
            echo -e "Uboot文件MD5验证----------------------------------\c"
            if [ $FILE = $FILE_1 ];then
                echo -e "[\e[32m完成\e[37m]"
                read -n1 -p "MD5验证通过，是否刷入Uboot,请输入[Y/N]?" yn
                if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
                    echo ""
                    echo "开始刷入不死uboot"
                    mtd write uboot.bin u-boot
                    echo -e "Uboot刷入完成------------------------------------[\e[32m完成\e[37m]"
                    UpdateUboot=1
                else
                    echo ""
                    UpdateUboot=0
                fi
            else
                echo -e "[\e[31m失败\e[37m]"
                UpdateUboot=0
            fi
        else
            echo -e "[\e[31m失败\e[37m]"
            UpdateUboot=0
        fi
    else
        echo -e "[\e[31m失败\e[37m]"
        UpdateUboot=0
    fi
    cd /tmp
    rm -rf ThirdFlameTemp
    if [ "$UpdateUboot" == "1" ]; then
        echo -e "替换uboot操作--------------------------------[\e[32m全部完成\e[37m]"
    else
        echo -e "替换uboot操作-------------------------------------[\e[31m失败\e[37m]"
    fi
    echo ""
    echo ""

}

remove_ss(){
        echo "开始卸载番茄利器插件"
        echo -e "停止相关进程--------------------------------------\c"
        /etc/init.d/ss-redir stop 1>/dev/null 2>&1
        /etc/init.d/ss-redir disable 1>/dev/null 2>&1
	/etc/init.d/ss.sh stop 1>/dev/null 2>&1
	/etc/init.d/ss.sh disable 1>/dev/null 2>&1
        /etc/init.d/pdnsd stop 1>/dev/null 2>&1
        rm -rf /etc/dnsmasq.d/* 1>/dev/null 2>&1
        /etc/init.d/dnsmasq restart 1>/dev/null 2>&1
        echo -e "[\e[32m完成\e[37m]"
        echo -e "删除相关文件--------------------------------------\c"
        rm -rf /etc/init.d/ss-redir
	rm -rf /etc/init.d/ss.sh
        rm -rf /usr/bin/ss-redir
        rm -rf /etc/SSdiyDNS.conf
        rm -rf /etc/THPdnsd-part.conf
        rm -rf /etc/ThirdFlameDNS.conf
        rm -rf /etc/antixxxdns.conf
        rm -rf /usr/lib/lua/luci/view/app/th/shadowsocks.htm
        rm -rf /usr/lib/lua/luci/controller/app/th.lua
        rm -rf /lib/upgrade/keep.d/ss-redir
        rm -rf /usr/lib/lua/luci/controller/app/vendor.lua
        rm -rf /usr/lib/lua/luci/view/app/vendor/ss.htm
        rm -rf /usr/lib/lua/luci/view/app/vendor/ss_ajax.htm
        rm -rf /usr/bin/vendor
        echo -e "[\e[32m完成\e[37m]"
	echo -e "清除IPTABLES规则----------------------------------\c"
	iptables -t nat -D PREROUTING -p udp -j dnsmask-PREROUTING 2>/dev/null
        iptables -t nat -F dnsmask-PREROUTING 2>/dev/null
        iptables -t nat -X dnsmask-PREROUTING 2>/dev/null
	
	iptables -t nat -D PREROUTING -i br-lan -j ssgoabroad 2>/dev/null
    	iptables -t nat -F ssgoabroad 2>/dev/null
    	iptables -t nat -X ssgoabroad 2>/dev/null
    	iptables -t nat -D PREROUTING -i ppp+ -j ssgoabroad-ppp 2>/dev/null
    	iptables -t nat -F ssgoabroad-ppp 2>/dev/null
    	iptables -t nat -X ssgoabroad-ppp 2>/dev/null
    	iptables -t nat -D OUTPUT -p tcp -j ssgoabroad-OUTPUT 2>/dev/null
       	iptables -t nat -F ssgoabroad-OUTPUT 2>/dev/null
    	iptables -t nat -X ssgoabroad-OUTPUT 2>/dev/null
	echo -e "[\e[32m完成\e[37m]"
        echo -e "还原系统文件--------------------------------------\c"
        if [ -f /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm.bak ]; then
            rm -rf /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm
            mv /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm.bak /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm
        fi
        echo -e "[\e[32m完成\e[37m]"
        echo -n "修正配置界面--------------------------------------"
        sed -i 's/height:629/height:590/g' /usr/lib/lua/luci/view/admin_web/home.htm;
        sed -i 's/.setup_box{ margin-left: 169px; height: 496px;/.setup_box{ margin-left: 169px; height: 460px;/g' /www/turbo-static/turbo/web/css/style.css;
        echo -e "[\e[32m完成\e[37m]"
        echo -n "清除LUCI缓存--------------------------------------"
        rm -rf /tmp/luci-indexcache
        echo -e "[\e[32m完成\e[37m]"
        read -n1 -p "是否删除配置文件,请输入[Y/N]?" yn
        echo ""
        if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
            echo -n "删除配置文件--------------------------------------"
            rm -rf /etc/config/ss-redir
	    rm -rf /tmp/white_domain_list.conf
            echo -e "[\e[32m完成\e[37m]"
	else
	    mkdir -p /usr/bin/vendor/config
        fi
        echo -e "卸载番茄利器插件-----------------[\e[32m全部完成\e[37m]"

}



rm -rf alphatoolset.sh
rm -rf $0
selectnum=""
until [ "$selectnum" == "0" ]
do
echo "*********************************************************"
echo "                                                         "
echo "                                                         "
echo "                     -----公  告-----                    "
echo "                                                         "
echo "                                                         "
echo "            联系方式  www.shadowsocks.online/bbs         "
echo "                                                         "
echo "            团 购 网   www.tuanss.cc                     "
echo "                                                         "
echo "*********************************************************"
echo "                                                         "
echo "请选择需要的操作"
echo "1、安装番茄利器插件"
echo "2、卸载番茄利器插件"
echo "0、退出" 
read -n1 -p "请选择需要进行的操作[1-2、0]?" selectnum
echo ""
echo "---------------------------------------------------------"
case $selectnum in

     2)
	remove_ss
        ;;
        
             5) 
     		read -n1 -p "开始将官方Uboot替换不死Uboot，是否继续,请输入[Y/N]?" yn
        echo ""
        if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
      		  ubootfn=$undeadubootfn
						ubootMD5fn=$undeadubootMD5fn
				    updateuboot
				else
				    echo -e "\e[31m未进行替换uboot操作\e[37m"
        fi
        ;;
     6)
        echo "开始备份可备份的一切"
        if [ -d /tmp/data/filetransit0 ]; then
                cd /tmp/data/filetransit0/
                bakall
                echo -e "备份可备份的一切----------------------------[\e[32m全部完成\e[37m]"
                echo "备份文件名为mtd0.bin-mtd9.bin、sd-crypt-key.txt"
                echo "存放在/tmp/data/filetransit0 电脑打开\\\hiwifi.com可见"
                echo "本次备份的编程器固件fullflash.bin由mtd0 1 2 9 6 7 8 顺序组成，可直接通过不死uboot刷入。"
        else
                echo "未找到 /tmp/data/filetransit0目录，未插入SD卡或未安装《局域网文件中转站》插件"
                echo "请插入SD卡并安装《局域网文件中转站》插件后，重新备份"
                echo -e "备份能够备份的一切--------------------------------[\e[31m失败\e[37m]"
        fi
        echo ""
        ;;
     3)
        echo "开始安装ADbyby插件"
        cd /tmp
        rm -rf ThirdFlameTemp
        mkdir ThirdFlameTemp
        cd ThirdFlameTemp
        echo -e "下载所需要的文件----------------------------------\c"
	curl -o 7620n.tar.gz -m 120 $dnurl$adbybyfn
        if [ -f 7620n.tar.gz ]; then
	    echo -e "--------------------------------------------------[\e[32m完成\e[37m]"
            echo "开始安装，安装的文件有:"
            tar -C / -xzvf 7620n.tar.gz
			chmod +x /usr/bin/adbyby/show-state
			chmod +x /usr/bin/adbyby/start-adbyby
			chmod +x /usr/bin/adbyby/stop-adbyby
			chmod +x /etc/init.d/adbyby
			ln -s /etc/init.d/adbyby S80adbyby
            read -n1 -p "安装完成，是否启动ADbyby,请输入[Y/N]?" yn
            echo ""
            if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
            	/etc/init.d/adbyby start
                echo -e "ADbyby启动完成-----------------------------------[完成]"
            fi
            
            echo -e "安装ADbyby插件--------------------------------[全部完成]"
        else
	    echo -e "--------------------------------------------------[\e[31m失败\e[37m]"
	    echo -e "安装ADbyby插件------------------------------------[\e[31m失败\e[37m]"
	fi
	echo ""
        echo ""
        cd /tmp
        rm -rf ThirdFlameTemp
        ;;

     4)
        echo "开始卸载ADbyby插件"
        echo -e "停止相关进程--------------------------------------\c"
        /etc/init.d/adbyby stop 1>/dev/null 2>&1
        /etc/init.d/adbyby disable 1>/dev/null 2>&1
        echo "[完成]"
        echo -e "删除相关文件--------------------------------------\c"
        rm -rf /etc/init.d/adbyby
        rm -rf /usr/bin/adbyby
        echo "[完成]"
        echo -e "卸载ADbyby插件---------------------------------[全部完成]"
        ;;
     0)
        echo "退出"
        ;;
     
        1)
        echo "开始安装番茄利器插件"
        cd /tmp
        rm -rf ThirdFlameTemp
        mkdir ThirdFlameTemp
        cd ThirdFlameTemp
	if [ -f /etc/config/ss-redir ]; then
	    uci_get_configfn_version=`uci get ss-redir.ssgoabroad.config_file_version 2>/dev/null`
	    if [ "$?" == "0" ] && [ "$uci_get_configfn_version" == "2.6.3" ]; then
	    	cp -a /etc/config/ss-redir /etc/config/ss-redir.2.6.3.bak
	    	echo -e "备份配置文件--------------------------------------[\e[32m完成\e[37m]"
	    else
		echo -e "备份配置文件--------------------------------------[\e[31m失败\e[37m]"
                echo "失败原因：配置文件与当前安装版本不兼容"
	    fi
	fi
        echo -n "备份系统文件----------------------"
        if [ -f /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm.bak ]; then
            echo -e "[\e[31m失败、备份文件已存在\e[37m]"
        else
            cp -a /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm.bak
            echo -e "----------------[\e[32m完成\e[37m]"
        fi

        echo "下载所需要的文件---------------------------------"
        curl -o ss-redir.tar.gz -m 120 $dnurl$ssredirfn
     		if [ -f ss-redir.tar.gz ]; then
            echo -e "--------------------------------------------------[\e[32m完成\e[37m]"
            echo "开始安装，正在安装的文件:"
            tar -C / -xvzf ss-redir.tar.gz
            if [ "$?" == "0" ]; then
            		echo -e "修改系统文件--------------------------------------[\e[32m完成\e[37m]"
				echo -n "修正配置界面--------------------------------------"
				sed -i 's/height:590/height:620/g' /usr/lib/lua/luci/view/admin_web/home.htm;
				sed -i 's/.setup_box{ margin-left: 169px; height: 460px;/.setup_box{ margin-left: 169px; height: 496px;/g' /www/turbo-static/turbo/web/css/style.css;	
			        echo -e "[\e[32m完成\e[37m]"
				echo -n "清除LUCI缓存--------------------------------------"
                                rm -rf /tmp/luci-indexcache
                                echo -e "[\e[32m完成\e[37m]"
                                chmod +x /etc/init.d/*
                                chmod +x /usr/bin/ss-redir
				/etc/init.d/pdnsd disable
				if [ -f /etc/config/ss-redir.2.6.3.bak ]; then
				    echo -n "恢复配置文件--------------------------------------"
				    cp -a /etc/config/ss-redir.2.6.3.bak /etc/config/ss-redir
				    rm -rf /etc/config/ss-redir.2.6.3.bak
				    echo -e "[\e[32m完成\e[37m]"
				fi
				echo -e "番茄利器插件---------------------[\e[32m全部完成\e[37m]"
	
				rm -rf /usr/local/ss-redir.tar.gz
				rm -rf /tmp/ss-redir.tar.gz
				rm -rf /tmp/data/ss-redir.tar.gz		          	
            else
            		echo -e "修改系统文件--------------------------------------[\e[31m失败\e[37m]"
            		echo -e "番茄利器插件-------------------------[\e[31m失败\e[37m]"
            fi
        else
            echo -e "[\e[31m失败\e[37m]"
            echo -e "番茄利器插件-------------------------[\e[31m失败\e[37m]"
        fi
        cd /tmp
        rm -rf ThirdFlameTemp
        echo ""
        echo ""






	
        ;;
	*)
        echo "输入错误"
esac
done
exit 0 
