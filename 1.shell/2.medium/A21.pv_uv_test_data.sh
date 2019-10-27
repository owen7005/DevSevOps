#!/bin/bash
HOST="192.168.1.110"
USER="root"
PASSWD="123456"
DB="devops_test"
mysql -h$HOST -u$USER -p$PASSWD $DB -e "tuncate web_access_count" &>/dev/null # 清空表
DATE=$(date +"%F %T")
ID=1
for i in {1..100}; do
    mysql -h$HOST -u$USER -p$PASSWD $DB -e "insert into web_access_count(id,insert_time,pv_number,uv_number) values ('$ID','$DATE','$RANDOM','$RANDOM')" &>/dev/null
    let ID++
    sleep 1
done
