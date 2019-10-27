#!/bin/bash
#Author : https://github.com/owen7005
# Date : 2016-07-01 13:50
# Use : sh check-tomcat-errorlog.sh
#
DATE=`date +%Y-%m-%d` #日期
salt "Fsd-mg01" cmd.run 'cat /data/credit-web-8080/logs/catalina.`date +%Y-%m-%d`.out |grep -A 1 -E "error|timed out"'
salt "Fsd-mg02" cmd.run 'cat /data/credit-web-8080/logs/catalina.`date +%Y-%m-%d`.out |grep -A 1 -E "error|timed out"'
echo "============================================================Next api error log============================================================"
salt "Fsd-api01" cmd.run 'cat /data/credit-api-8081/logs/catalina.`date +%Y-%m-%d`.out |grep -A 5 -E "error|timed out"'
salt "Fsd-api02" cmd.run 'cat /data/credit-api-8081/logs/catalina.`date +%Y-%m-%d`.out |grep -A 5 -E "error|timed out"'
echo "============================================================Next pic error log============================================================"
salt "Fsd-pic01" cmd.run 'cat /data/credit-file-8080/logs/catalina.`date +%Y-%m-%d`.out |grep -A 5 -E "error|timed out"'
salt "Fsd-pic02" cmd.run 'cat /data/credit-file-8080/logs/catalina.`date +%Y-%m-%d`.out |grep -A 5 -E "error|timed out"'
echo "============================================================Next sms error log============================================================"
salt "Fsd-pic01" cmd.run 'cat /data/credit-sms-8680/logs/catalina.out |grep -A 5 -E "error|timed out"'
salt "Fsd-pic02" cmd.run 'cat /data/credit-sms-8680/logs/catalina.out |grep -A 5 -E "error|timed out"'
echo "============================================================Next op error log============================================================"
salt "Fsd-pic01" cmd.run 'cat /data/credit-operating-8780/logs/catalina.`date +%Y-%m-%d`.out |grep -A 5 -E "error|timed out"'
salt "Fsd-pic02" cmd.run 'cat /data/credit-operating-8780/logs/catalina.`date +%Y-%m-%d`.out |grep -A 5 -E "error|timed out"'
