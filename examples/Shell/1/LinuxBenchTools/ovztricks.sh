bench() {
  cpu=$( awk -F': +' '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
  cores=$( awk '/cpu MHz/ {cores++} END {print cores}' /proc/cpuinfo )
  freq=$( awk -F': +' '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
  echo "    CPU Model : $cpu"
  echo "        Cores : $cores"
  echo "    Frequency : $freq MHz"

  if [ $OPENVZ ]; then
    ram=$( awk '/vmguarpages/ {garantee=$4*4/1024} /privvmpages/ {burst=$4*4/1024} END {printf "%d/%d",garantee,burst}' /proc/user_beancounters )
  else
    ram=$( free -m | awk 'NR==2 {print $2}' )
  fi
  swap=$( free -m | awk 'NR==4 {print $2}' )
  echo "          Ram : $ram MB"
  echo "         Swap : $swap MB"

  echo "             ---"

  echo -n "       Uptime : "
  uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; gsub(/^ +|, *$/,""); print}'
  echo -n "    I/O speed : "
  ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F', ' '{io=$NF} END {print io}'
  echo -n "     CacheFly : "
  wget -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 " " $4} END {gsub(/\(|\)/,"",speed); print speed}'

  echo "             ---"

# You can add or delete as much as you want!
  echo -n " Softlayer DC : "
  wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 " " $4} END {gsub(/\(|\)/,"",speed); print speed}'
  echo -n " Softlayer CA : "
  wget -O /dev/null http://speedtest.sjc01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 " " $4} END {gsub(/\(|\)/,"",speed); print speed}'
  echo -n " Softlayer SG : "
  wget -O /dev/null http://speedtest.sng01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 " " $4} END {gsub(/\(|\)/,"",speed); print speed}'
  echo -n "    Linode CA : "
  wget -O /dev/null http://fremont1.linode.com/100MB-fremont.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 " " $4} END {gsub(/\(|\)/,"",speed); print speed}'
  echo -n "    Linode UK : "
  wget -O /dev/null http://london1.linode.com/100MB-london.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 " " $4} END {gsub(/\(|\)/,"",speed); print speed}'
  echo -n "    Linode JP : "
  wget -O /dev/null http://tokyo1.linode.com/100MB-tokyo.bin  2>&1 | awk '/\/dev\/null/ {speed=$3 " " $4} END {gsub(/\(|\)/,"",speed); print speed}'
  echo -n "       OVH FR : "
  wget -O /dev/null http://proof.ovh.net/files/100Mb.dat 2>&1 | awk '/\/dev\/null/ {speed=$3 " " $4} END {gsub(/\(|\)/,"",speed); print speed}'

}