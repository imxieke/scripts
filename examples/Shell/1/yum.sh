cd /etc/yum.repos.d/
echo "卡卡-更新yum";
mv CentOS-Base.repo CentOS-Base.repo.bak
wget http://mirrors.aliyun.com/repo/Centos-6.repo
mv Centos-6.repo CentOS-Base.repo
yum update
yum clean all
yum makecache
clear
echo "更新yum成功了！BY卡卡";