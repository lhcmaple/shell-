#!/bin/bash

clear
if [[ $# -lt 2 ]]
then
    echo 'usage: ./auto_connect.sh account password'
    exit
fi

if ! test -f request
then
    echo '文件request不在!!!'
    exit
fi

#用户名 密码 数据
account=$1
password=$2
data="DDDDD=${account}&upass=${password}&R1=0&R2=&R6=0&para=00&0MKKey=123456"

#服务器地址
server="192.168.254.220"

#第10秒连接一次
while true
do
    cat request|sed "s/__LENGTH/${#data}/;s/__ACCOUNT/$account/;s/__PASSWORD/$password/"|ncat --ssl $server 443 >/dev/null
    while ping -c 5 49.234.234.238 >/dev/null
    do
        clear
        echo '--------------------------'
        echo "网络连通"
        echo '--------------------------'
        sleep 10
    done
    clear
    echo '--------------------------'
    echo "网络断开"
    echo '--------------------------'
done