#!/bin/bash
#sudo apt-get install libclass-dbi-mysql-perl 
#backup mysql database;
#author：jincon  请安装好mysqlhotcopy

dateDIR=`date +"%y-%m-%d"`
mkdir -p /data1/$dateDIR
user="root"
password="password"
for i in `/usr/local/mysql/bin/mysql -u$user -p$password -e "show databases" | grep -v "Database"`
do
  if [ $i = "ftpusers" ];then
	continue
  elif [ $i = "information_schema" ];then
  	continue
  elif [ $i = "performance_schema" ];then
	continue
  elif [ $i = "mysql" ];then
	continue
  fi
  /usr/local/mysql/bin/mysqlhotcopy -u $user -p $password --addtodest $i /data1/$dateDIR
done

cd /data1/$dateDIR
zip -r phpcmsv9.zip phpcmsv9/
echo 'phpcmsv9 is ziped ok'


#
#scp -P 22 -r /home/test/ root@192.168.191.200:/home/test/

rm -rf phpcmsv9/
