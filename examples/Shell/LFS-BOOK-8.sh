#!/bin/bash
#
# 通过对比 ping 响应时间，找到本机最快的上传ip
# Travis@fir.im
#
# 使用方法：
# sh -c "$(curl -sSL https://gist.githubusercontent.com/trawor/5dda140dee86836b8e60/raw/turbo-qiniu.sh)"

echo "# 这个脚本理论上可以帮你获取任意域名的最快速的IP"
echo "# 获取IP列表的服务由 17ce.com 提供, 非常感谢有这么好的免费服务!"
echo "# 有使用问题请联系 tw@fir.im (我相信你肯定没有问题的)\n\n"


DOMAIN="up.qbox.me"


echo "# 这里以七牛上传服务器为例, 部分地区七牛上传速度慢的问题，只用于本机，\033[1;91m请勿用于生产环境\033[0m"
echo "> 获取 \033[1;91m${DOMAIN}\033[0m IP 列表, 请等待5秒 ..."


function refresh_host()
{
  IP="$1"
  TARGET_PATH="/etc/hosts"
  TEMP_PATH=".temp_hosts"
  sed "/$DOMAIN/d" $TARGET_PATH > $TEMP_PATH 
  echo "${IP}   ${DOMAIN}" >> $TEMP_PATH
  
  echo "\n允许使用sudo，自动帮你更新host"
  echo "#### 你也可以用任意文本编辑器打开 \033[1;91m/etc/hosts\033[0m 在文件中加一行(如果已经设置，只需要改掉IP就可以了):\n\n\t${FINAL_IP} $DOMAIN\n"
  sudo mv ${TEMP_PATH} ${TARGET_PATH}
}

TID_URL="http://www.17ce.com/apis/ping?user=yiqice%40qq.com&code=8ff8b3kl94gEtZdRWAaBD4Jnmw9AdoiOnBYY9lwukYiPq4Q&url=${DOMAIN}&curl=&rt=1&nocache=1&host=&referer=&cookie=&agent=&speed=&pingcount=1&pingsize=&area%5B%5D=1&isp%5B%5D=0&isp%5B%5D=1&isp%5B%5D=2&isp%5B%5D=6&isp%5B%5D=7&isp%5B%5D=8&isp%5B%5D=4"

TID=`curl -sSL "${TID_URL}" | awk '{match($0, /tid":"([^"]+)/) ; print substr($0, RSTART+6, RLENGTH-6) }'`

sleep 5

DATA_URL="http://www.17ce.com/apis/ajaxfresh?callback=JSON&num=0&tid=${TID}"
DATA=`curl -sSL $DATA_URL` 
IPS=`echo $DATA | tr ',"' "\n" | grep -E '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$' | sort | uniq`
IPS="$DOMAIN
$IPS"

echo "> 已获取IP列表:\n$IPS"

for ip in $IPS
do
    # 只 ping 一次
    P=`ping -c 1 $ip | grep "icmp"`
    # 读取 IP 和 延迟
    read IP T<<< $( echo ${P} |  awk '{split($0,a,/[ |=|:]/); print a[4]" "a[11]}')
    TIME=${T%%.*}


    # 没有ping通，忽略
    if [[ -z "$TIME" ]] ; then

      # 防止本地不通，给个默认值
      if [[ -z "$LOCAL_TIME" ]] ; then
        LOCAL_TIME=1000
        PING_TIME=1000
      fi

      continue
    fi

    # 本地的数值
    if [[ -z "$FINAL_IP" ]] ; then
      LOCAL_IP=$IP
      FINAL_IP=$IP

      LOCAL_TIME=$TIME
      PING_TIME=$TIME

      continue
    fi

    # 小于5毫秒 就直接用
    if (( 5 >= ${TIME} )) ; then
      PING_TIME=$TIME
      FINAL_IP=$IP
      break
    fi

    # 对比用时并得到更快的IP
    if (( ${TIME} < ${PING_TIME} )) ; then
      PING_TIME=$TIME
      FINAL_IP=$IP

      echo "  ✓ 找到更快的IP：$IP , 延迟：$PING_TIME 毫秒"
    fi


done



# 从 17ce.com 抓的七牛上传IP列表
if [ "${LOCAL_IP}" == "${FINAL_IP}" ] ; then
  echo "\n✓ 本地IP($LOCAL_IP) 已经是最快的了（只有 \033[1;91m${LOCAL_TIME}\033[0m 毫秒），如果还感觉不够快，请自检人品 :)"
else
  refresh_host "${FINAL_IP}"
  echo "#### 打完收工，去 \033[4;31mfir.im\033[0m 重新上传应用感受一下速度吧 :)\n"
fi