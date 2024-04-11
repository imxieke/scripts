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
    
#!/bin/sh
cd /tmp
echo "*********************************************************"
echo "*                                                       *"
echo "*                                                       *"
echo "*                                                       *"
echo "*             ShadowSocks插件安装器                     *"
echo "*            安装前请关闭极路由自带SSH/VPN功能          *"
echo "*         只测试过极路由9009-9018版本，其他自测         *"
echo "*             技术支持QQ：1456089826                    *"
echo "*             团购SSQQ群：  458880947                  *"
echo "*********************************************************"
echo "                                                         "
echo "请选择需要的操作（按下对应数字后回车确认）"
echo "1：SS插件服务（安装/更新/卸载/配置备份或恢复）"
echo "2：安装adblock广告过滤功能(测试版 安装需卸载旧版本)"
echo "3：卸载adblock广告过滤功能"
echo "4：安装adblock广告过滤功能(旧版本)"
echo "5：卸载adblock广告过滤功能(旧版本)"
echo "6：安装breed（支持包括HC5761A在内的所有版本）"
echo "7：备份可以备份的一切（需安装局域网共享中转站插件）"

echo "0:退出"
read num



if [ "${num}" == "1" ]
then
cd /tmp
rm -rf *.sh
wget http://www.xuanlove.download/hiwifi/ss.sh
chmod -R 777 ss.sh
sh ss.sh
fi


if [ "${num}" == "2" ]
then
cd /tmp
rm -rf *.sh
wget http://www.xinbiaoge.com/hiwifi/adbyby/new/adbyby_new.sh
chmod 777 adbyby_new.sh
sh adbyby_new.sh
fi

if [ "${num}" == "3" ]
then
cd /tmp
rm -rf *.sh
wget http://www.xinbiaoge.com/hiwifi/adbyby/new/unadbyby_new.sh
chmod 777 unadbyby_new.sh
sh unadbyby_new.sh
fi


if [ "${num}" == "4" ]
then
cd /tmp
rm -rf *.sh
wget http://www.xinbiaoge.com/hiwifi/adbyby/old/adbyby.sh
chmod 777 adbyby.sh
sh adbyby.sh
fi

if [ "${num}" == "5" ]
then
cd /tmp
rm -rf *.sh
wget http://www.xinbiaoge.com/hiwifi/adbyby/old/adbyby_sd.sh
chmod 777 adbyby_sd.sh
sh adbyby_sd.sh
fi


if [ "${num}" == "6" ]
then
cd /tmp
rm -rf *.sh
wget http://b1456089826.oss-cn-beijing.aliyuncs.com/breed/autobreed.sh
chmod 777 autobreed.sh
sh autobreed.sh
fi

if [ "${num}" == "7" ]
then
echo "开始备份可备份的一切"
cd /tmp/data/filetransit0/
rm -rf *.bin
bakall
echo "备份完成"			
echo "备份文件名为mtd0.bin-mtd9.bin、sd-crypt-key.txt"
echo "本次备份的编程器固件fullflash.bin由mtd0 1 2 9 6 7 8 顺序组成，可直接通过不死uboot刷入。"
echo "在浏览器打开\\hiwifi.com\你局域网共享中转站插件设置的文件夹里面的文件就是备份文件"
fi



if [ "${num}" == "0" ]
then
exit
fi
