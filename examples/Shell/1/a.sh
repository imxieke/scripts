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
        echo -e "����MTD0��mtd0.bin--------------------------------\c"
        cat /dev/mtd0 > mtd0.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����MTD1��mtd1.bin--------------------------------\c"
        cat /dev/mtd1 > mtd1.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����MTD2��mtd2.bin--------------------------------\c"
        cat /dev/mtd2 > mtd2.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����MTD3��mtd3.bin--------------------------------\c"
        cat /dev/mtd3 > mtd3.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����MTD4��mtd4.bin--------------------------------\c"
        cat /dev/mtd4 > mtd4.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����MTD5��mtd5.bin--------------------------------\c"
        cat /dev/mtd5 > mtd5.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����MTD6��mtd6.bin--------------------------------\c"
        cat /dev/mtd6 > mtd6.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����MTD7��mtd7.bin--------------------------------\c"
        cat /dev/mtd7 > mtd7.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����MTD8��mtd8.bin--------------------------------\c"
        cat /dev/mtd8 > mtd8.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����MTD9��mtd9.bin--------------------------------\c"
        cat /dev/mtd9 > mtd9.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "���ݱ�����̼���fullflash.bin---------------------\c"
        cat /dev/mtd0 /dev/mtd1 /dev/mtd2 /dev/mtd9 /dev/mtd6 /dev/mtd7 /dev/mtd8 > fullflash.bin
        echo -e "[\e[32m���\e[37m]"
        echo -e "����SD����һ����������Կ��sd-crypt-key.txt--------\c"
        /sbin/hi_crypto_key device-crypt-key > sd-crypt-key.txt
        echo -e "[\e[32m���\e[37m]"
}
    
updateuboot()
{

    echo -e "����uboot-----------------------------------------\c"
    if [ -d /tmp/data/filetransit0 ]; then
        rm -rf /tmp/data/filetransit0/mtd0.bin
        cat /dev/mtd0 > /tmp/data/filetransit0/mtd0.bin
        echo -e "[\e[32m���\e[37m]"
        echo "�����ļ���Ϊmtd0.bin"
        echo "�����/tmp/data/filetransit0 ���Դ�\\\hiwifi.com�ɼ�"
    else
        rm -rf /root/mtd0.bin
        cat /dev/mtd0 > /root/mtd0.bin
        echo -e "[\e[32m���\e[37m]"
        echo "�����ļ���Ϊmtd0.bin"
        echo "�����/root,�뼰ʱȡ��"
    fi
    cd /tmp
    rm -rf ThirdFlameTemp
    mkdir ThirdFlameTemp
    cd ThirdFlameTemp
    echo "����uboot�ļ�-------------------------------------"

    curl -o uboot.bin -m 120 $dnurl$ubootfn
    if [ -f uboot.bin ]; then
        echo -e "--------------------------------------------------[\e[32m���\e[37m]"
        echo "����ubootMD5��֤�ļ�------------------------------"
        curl -o uboot.md5 -m 120 $dnurl$ubootMD5fn
        if [ -f uboot.md5 ]; then
            echo -e "--------------------------------------------------[\e[32m���\e[37m]"
            find *.bin -print|xargs md5sum|sort > uboot.md5.local
            FILE=$( md5sum uboot.md5 |awk '{print $1 }' )
            FILE_1=$( md5sum uboot.md5.local |awk '{print $1 }' )
            echo -e "Uboot�ļ�MD5��֤----------------------------------\c"
            if [ $FILE = $FILE_1 ];then
                echo -e "[\e[32m���\e[37m]"
                read -n1 -p "MD5��֤ͨ�����Ƿ�ˢ��Uboot,������[Y/N]?" yn
                if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
                    echo ""
                    echo "��ʼˢ�벻��uboot"
                    mtd write uboot.bin u-boot
                    echo -e "Ubootˢ�����------------------------------------[\e[32m���\e[37m]"
                    UpdateUboot=1
                else
                    echo ""
                    UpdateUboot=0
                fi
            else
                echo -e "[\e[31mʧ��\e[37m]"
                UpdateUboot=0
            fi
        else
            echo -e "[\e[31mʧ��\e[37m]"
            UpdateUboot=0
        fi
    else
        echo -e "[\e[31mʧ��\e[37m]"
        UpdateUboot=0
    fi
    cd /tmp
    rm -rf ThirdFlameTemp
    if [ "$UpdateUboot" == "1" ]; then
        echo -e "�滻uboot����--------------------------------[\e[32mȫ�����\e[37m]"
    else
        echo -e "�滻uboot����-------------------------------------[\e[31mʧ��\e[37m]"
    fi
    echo ""
    echo ""

}

remove_ss(){
        echo "��ʼж�ط����������"
        echo -e "ֹͣ��ؽ���--------------------------------------\c"
        /etc/init.d/ss-redir stop 1>/dev/null 2>&1
        /etc/init.d/ss-redir disable 1>/dev/null 2>&1
	/etc/init.d/ss.sh stop 1>/dev/null 2>&1
	/etc/init.d/ss.sh disable 1>/dev/null 2>&1
        /etc/init.d/pdnsd stop 1>/dev/null 2>&1
        rm -rf /etc/dnsmasq.d/* 1>/dev/null 2>&1
        /etc/init.d/dnsmasq restart 1>/dev/null 2>&1
        echo -e "[\e[32m���\e[37m]"
        echo -e "ɾ������ļ�--------------------------------------\c"
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
        echo -e "[\e[32m���\e[37m]"
	echo -e "���IPTABLES����----------------------------------\c"
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
	echo -e "[\e[32m���\e[37m]"
        echo -e "��ԭϵͳ�ļ�--------------------------------------\c"
        if [ -f /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm.bak ]; then
            rm -rf /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm
            mv /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm.bak /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm
        fi
        echo -e "[\e[32m���\e[37m]"
        echo -n "�������ý���--------------------------------------"
        sed -i 's/height:629/height:590/g' /usr/lib/lua/luci/view/admin_web/home.htm;
        sed -i 's/.setup_box{ margin-left: 169px; height: 496px;/.setup_box{ margin-left: 169px; height: 460px;/g' /www/turbo-static/turbo/web/css/style.css;
        echo -e "[\e[32m���\e[37m]"
        echo -n "���LUCI����--------------------------------------"
        rm -rf /tmp/luci-indexcache
        echo -e "[\e[32m���\e[37m]"
        read -n1 -p "�Ƿ�ɾ�������ļ�,������[Y/N]?" yn
        echo ""
        if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
            echo -n "ɾ�������ļ�--------------------------------------"
            rm -rf /etc/config/ss-redir
	    rm -rf /tmp/white_domain_list.conf
            echo -e "[\e[32m���\e[37m]"
	else
	    mkdir -p /usr/bin/vendor/config
        fi
        echo -e "ж�ط����������-----------------[\e[32mȫ�����\e[37m]"

}



rm -rf alphatoolset.sh
rm -rf $0
selectnum=""
until [ "$selectnum" == "0" ]
do
echo "*********************************************************"
echo "                                                         "
echo "                                                         "
echo "                     -----��  ��-----                    "
echo "                                                         "
echo "                                                         "
echo "            ��ϵ��ʽ  www.shadowsocks.online/bbs         "
echo "                                                         "
echo "            �� �� ��   www.tuanss.cc                     "
echo "                                                         "
echo "*********************************************************"
echo "                                                         "
echo "��ѡ����Ҫ�Ĳ���"
echo "1����װ�����������"
echo "2��ж�ط����������"
echo "0���˳�" 
read -n1 -p "��ѡ����Ҫ���еĲ���[1-2��0]?" selectnum
echo ""
echo "---------------------------------------------------------"
case $selectnum in

     2)
	remove_ss
        ;;
        
             5) 
     		read -n1 -p "��ʼ���ٷ�Uboot�滻����Uboot���Ƿ����,������[Y/N]?" yn
        echo ""
        if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
      		  ubootfn=$undeadubootfn
						ubootMD5fn=$undeadubootMD5fn
				    updateuboot
				else
				    echo -e "\e[31mδ�����滻uboot����\e[37m"
        fi
        ;;
     6)
        echo "��ʼ���ݿɱ��ݵ�һ��"
        if [ -d /tmp/data/filetransit0 ]; then
                cd /tmp/data/filetransit0/
                bakall
                echo -e "���ݿɱ��ݵ�һ��----------------------------[\e[32mȫ�����\e[37m]"
                echo "�����ļ���Ϊmtd0.bin-mtd9.bin��sd-crypt-key.txt"
                echo "�����/tmp/data/filetransit0 ���Դ�\\\hiwifi.com�ɼ�"
                echo "���α��ݵı�����̼�fullflash.bin��mtd0 1 2 9 6 7 8 ˳����ɣ���ֱ��ͨ������ubootˢ�롣"
        else
                echo "δ�ҵ� /tmp/data/filetransit0Ŀ¼��δ����SD����δ��װ���������ļ���תվ�����"
                echo "�����SD������װ���������ļ���תվ����������±���"
                echo -e "�����ܹ����ݵ�һ��--------------------------------[\e[31mʧ��\e[37m]"
        fi
        echo ""
        ;;
     3)
        echo "��ʼ��װADbyby���"
        cd /tmp
        rm -rf ThirdFlameTemp
        mkdir ThirdFlameTemp
        cd ThirdFlameTemp
        echo -e "��������Ҫ���ļ�----------------------------------\c"
	curl -o 7620n.tar.gz -m 120 $dnurl$adbybyfn
        if [ -f 7620n.tar.gz ]; then
	    echo -e "--------------------------------------------------[\e[32m���\e[37m]"
            echo "��ʼ��װ����װ���ļ���:"
            tar -C / -xzvf 7620n.tar.gz
			chmod +x /usr/bin/adbyby/show-state
			chmod +x /usr/bin/adbyby/start-adbyby
			chmod +x /usr/bin/adbyby/stop-adbyby
			chmod +x /etc/init.d/adbyby
			ln -s /etc/init.d/adbyby S80adbyby
            read -n1 -p "��װ��ɣ��Ƿ�����ADbyby,������[Y/N]?" yn
            echo ""
            if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
            	/etc/init.d/adbyby start
                echo -e "ADbyby�������-----------------------------------[���]"
            fi
            
            echo -e "��װADbyby���--------------------------------[ȫ�����]"
        else
	    echo -e "--------------------------------------------------[\e[31mʧ��\e[37m]"
	    echo -e "��װADbyby���------------------------------------[\e[31mʧ��\e[37m]"
	fi
	echo ""
        echo ""
        cd /tmp
        rm -rf ThirdFlameTemp
        ;;

     4)
        echo "��ʼж��ADbyby���"
        echo -e "ֹͣ��ؽ���--------------------------------------\c"
        /etc/init.d/adbyby stop 1>/dev/null 2>&1
        /etc/init.d/adbyby disable 1>/dev/null 2>&1
        echo "[���]"
        echo -e "ɾ������ļ�--------------------------------------\c"
        rm -rf /etc/init.d/adbyby
        rm -rf /usr/bin/adbyby
        echo "[���]"
        echo -e "ж��ADbyby���---------------------------------[ȫ�����]"
        ;;
     0)
        echo "�˳�"
        ;;
     
        1)
        echo "��ʼ��װ�����������"
        cd /tmp
        rm -rf ThirdFlameTemp
        mkdir ThirdFlameTemp
        cd ThirdFlameTemp
	if [ -f /etc/config/ss-redir ]; then
	    uci_get_configfn_version=`uci get ss-redir.ssgoabroad.config_file_version 2>/dev/null`
	    if [ "$?" == "0" ] && [ "$uci_get_configfn_version" == "2.6.3" ]; then
	    	cp -a /etc/config/ss-redir /etc/config/ss-redir.2.6.3.bak
	    	echo -e "���������ļ�--------------------------------------[\e[32m���\e[37m]"
	    else
		echo -e "���������ļ�--------------------------------------[\e[31mʧ��\e[37m]"
                echo "ʧ��ԭ�������ļ��뵱ǰ��װ�汾������"
	    fi
	fi
        echo -n "����ϵͳ�ļ�----------------------"
        if [ -f /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm.bak ]; then
            echo -e "[\e[31mʧ�ܡ������ļ��Ѵ���\e[37m]"
        else
            cp -a /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm.bak
            echo -e "----------------[\e[32m���\e[37m]"
        fi

        echo "��������Ҫ���ļ�---------------------------------"
        curl -o ss-redir.tar.gz -m 120 $dnurl$ssredirfn
     		if [ -f ss-redir.tar.gz ]; then
            echo -e "--------------------------------------------------[\e[32m���\e[37m]"
            echo "��ʼ��װ�����ڰ�װ���ļ�:"
            tar -C / -xvzf ss-redir.tar.gz
            if [ "$?" == "0" ]; then
            		echo -e "�޸�ϵͳ�ļ�--------------------------------------[\e[32m���\e[37m]"
				echo -n "�������ý���--------------------------------------"
				sed -i 's/height:590/height:620/g' /usr/lib/lua/luci/view/admin_web/home.htm;
				sed -i 's/.setup_box{ margin-left: 169px; height: 460px;/.setup_box{ margin-left: 169px; height: 496px;/g' /www/turbo-static/turbo/web/css/style.css;	
			        echo -e "[\e[32m���\e[37m]"
				echo -n "���LUCI����--------------------------------------"
                                rm -rf /tmp/luci-indexcache
                                echo -e "[\e[32m���\e[37m]"
                                chmod +x /etc/init.d/*
                                chmod +x /usr/bin/ss-redir
				/etc/init.d/pdnsd disable
				if [ -f /etc/config/ss-redir.2.6.3.bak ]; then
				    echo -n "�ָ������ļ�--------------------------------------"
				    cp -a /etc/config/ss-redir.2.6.3.bak /etc/config/ss-redir
				    rm -rf /etc/config/ss-redir.2.6.3.bak
				    echo -e "[\e[32m���\e[37m]"
				fi
				echo -e "�����������---------------------[\e[32mȫ�����\e[37m]"
	
				rm -rf /usr/local/ss-redir.tar.gz
				rm -rf /tmp/ss-redir.tar.gz
				rm -rf /tmp/data/ss-redir.tar.gz		          	
            else
            		echo -e "�޸�ϵͳ�ļ�--------------------------------------[\e[31mʧ��\e[37m]"
            		echo -e "�����������-------------------------[\e[31mʧ��\e[37m]"
            fi
        else
            echo -e "[\e[31mʧ��\e[37m]"
            echo -e "�����������-------------------------[\e[31mʧ��\e[37m]"
        fi
        cd /tmp
        rm -rf ThirdFlameTemp
        echo ""
        echo ""






	
        ;;
	*)
        echo "�������"
esac
done
exit 0 
