#!/bin/bash
#Author : https://github.com/owen7005
# Date : 2016-07-01 13:50
# Des : The scripts is
#备份数据库

backup_dir='../data/backup/'

if [ ! -d $backup_dir ];then
    mkdir $backup_dir
fi

mysqldump -uroot -h127.0.0.1 -p jumpserver -P3307 > ${backup_dir}/jumpserver_$(date +'%Y-%m-%d_%H:%M:%S').sql
