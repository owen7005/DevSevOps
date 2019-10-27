#!/bin/sh
#Author : https://github.com/owen7005
# Date : 2016-07-01 13:50
#清理日志
max=`df -h |awk 'NR==4''{print $5 }'| cut -d% -f1`
if [ "$max" -gt 75 ];then
    echo " " > /data/tomcat/logs/catalina.out
    find /data/tomcat/logs/ -type f -name "*.log" -mtime +5 | xargs rm -rf
    find /data/tomcat/logs/ -type f -name "localhost_*.txt" -mtime +7 |xargs rm -rf
fi