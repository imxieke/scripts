bakall()
{
        echo -e "备份SS配置\c"
        cat /etc/config/ss-redir > biaogessback.bg
        echo -e "[\e[32m完成\e[37m]"
}
restoreall()
{
        echo -e "恢复SS配置\c"
		cat biaogessback.bg > /etc/config/ss-redir
		
        echo -e "[\e[32m完成\e[37m]"
}
if [ -f /usr/bin/vendor/config/bgss ]; then
cd /tmp
echo "*********************************************************"
echo "*                                                       *"
echo "*                                                       *"
echo "*                                                       *"
echo "*             SS配置备份/恢复器                         *"
echo "*            只支持最新2016-03-19及以上版本                   *"
echo "*             技术支持QQ：1456089826                    *"
echo "*             团购SSQQ群：  458880947                   *"
echo "*********************************************************"
echo "                                                         "
echo "请选择需要的操作（按下对应数字后回车确认）"
echo "1：SS配置备份"
echo "2：SS配置恢复"
echo "0:退出"
read num

if [ "${num}" == "1" ]
then

echo "-------------------------------警告！------------------------------------"
echo "      备份SS配置前需要安装‘局域网共享中转站插件’是否继续？                "
read -n1 -p "是否备份SS配置？请输入[Y/N]?" yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
echo "开始备份SS配置"
cd /tmp/data/filetransit0/
rm -rf *.bin
bakall
echo "备份完成"			
echo "备份文件名为biaogessback.bg"
echo "切记；备份的时候不要改名，否则无法恢复"
echo "在浏览器打开\\hiwifi.com\（你局域网共享中转站插件设置的文件夹）里面的文件就是备份文件"
echo "5秒后返回工具箱"
sleep 5
cd /tmp
rm -rf *.sh
wget http://www.xuanlove.download/hiwifi/sstool.sh
chmod 777 sstool.sh
sh sstool.sh
fi
fi
if [ "${num}" == "2" ]
then
echo "      恢复SS配置前需要将biaogessback.bg放到备份的目录否则无法恢复，是否继续  "
read -n1 -p "是否恢复SS配置？请输入[Y/N]?" yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
echo "开始恢复SS配置"
cd /tmp/data/filetransit0/
rm -rf *.bin
restoreall
echo "恢复完成"	
echo "5秒后返回工具箱"
sleep 5
cd /tmp
rm -rf *.sh
wget http://www.xuanlove.download/hiwifi/sstool.sh
chmod 777 sstool.sh
sh sstool.sh		
fi
fi
if [ "${num}" == "0" ]
then
cd /tmp
rm -rf *.sh
wget http://www.xuanlove.download/hiwifi/sstool.sh
chmod 777 sstool.sh
sh sstool.sh
fi
else
echo "SS配置备份/恢复器不支持您的版本，如果您安装了彪哥的SS请用更新器更新到最新版本再使用本工具"
echo "旧版SS不支持配置备份/恢复"
echo "5秒后返回工具箱"
sleep 5
cd /tmp
rm -rf *.sh
wget http://www.xuanlove.download/hiwifi/sstool.sh
chmod 777 sstool.sh
sh sstool.sh
fi
