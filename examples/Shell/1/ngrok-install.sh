#!/bin/bash
# ngrok one-click install shell
echo "Ngrok one-click install shell"
sudo apt-get install build-essential golang mercurial git
mkdir ~/.go && cd ~
export GOROOT=/usr/local/go
export GOPATH=~/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
git clone https://github.com/tutumcloud/ngrok.git ngrok
cd ngrok
#生成并替换源码里默认的证书，注意域名要修改为你自己的，这里是一个虚拟的测试域名
NGROK_DOMAIN="ngrok.mydomain.com"
openssl genrsa -out base.key 2048
openssl req -new -x509 -nodes -key base.key -days 10000 -subj "/CN=$NGROK_DOMAIN" -out base.pem
openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
openssl x509 -req -in server.csr -CA base.pem -CAkey base.key -CAcreateserial -days 10000 -out server.crt
cp base.pem assets/client/tls/ngrokroot.crt
#开始编译，服务端客户端会基于证书来加密通讯，保证了安全性
sudo make release-server release-client
# 如果一切正常，ngrok/bin 目录下应该有 ngrok、ngrokd 两个可执行文件，ngrokd 是服务端文件，ngrok 是 Linux 的客户端
ls -al ./bin