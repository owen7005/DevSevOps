#! /bin/sh
#Author : https://github.com/owen7005
# Date : 2016-07-01 13:50
# Des : The scripts is kill java
# Use : sh killjava.sh
source /etc/profile
pid=`ps -ef|grep /data/credit-api-8081/bin/bootstrap.jar|grep -v grep|awk -F" " '{print $2}'`
if [ -n $pid ];then
        kill -9 $pid
fi
