

							if [ -f /usr/bin/vendor/config/bgss2016-03-19 ]; then
									echo "当前已经是最新版本，无需更新"
						
								else
									echo "发现新版本文件，开始更新！"
wget -O /usr/bin/vendor/config/bgss2016-03-19 http://biaogehiwifi.oss-cn-beijing.aliyuncs.com/bgnew
wget -O /usr/bin/vendor/config/bgss http://biaogehiwifi.oss-cn-beijing.aliyuncs.com/bgnew
rm -f /usr/bin/vendor/config/bgss2016-03-18 
rm -f /usr/bin/vendor/config/gfw_list.conf
wget -O /usr/bin/vendor/config/gfw_list.conf http://biaogehiwifi.oss-cn-beijing.aliyuncs.com/gfw_list.conf
rm -f /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm
wget -O /usr/lib/lua/luci/view/admin_web/menu/adv_menu.htm http://biaogehiwifi.oss-cn-beijing.aliyuncs.com/adv_menu.htm
rm -f /usr/lib/lua/luci/view/app/vendor/ss.htm
wget -O /usr/lib/lua/luci/view/app/vendor/ss.htm http://biaogehiwifi.oss-cn-beijing.aliyuncs.com/ss.htm
uci set ss-redir.ssgoabroad.ss_version=2016-03-19 && uci commit ss-redir
								fi
								
