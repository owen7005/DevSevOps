#! /bin/sh
#logs_clenup.sh:Used to clean up logs
#00 02 * * * /usr/local/scripts/logs_clenup.sh
#Author : https://github.com/owen7005
#histor
#2017.8.17
# mkdir -p /usr/tomcat/tomcat_portal_web_8000/logsback
# mkdir -p /usr/tomcat/tomcat_portal_web_8089/logsback
########PATH########################################################
s1=/usr/tomcat/tomcat_service_admin_8084/logs/
s2=/usr/tomcat/tomcat_portal_console_8080/logs/ 
bak_dirs1=/usr/tomcat/tomcat_service_admin_8084/logs8084back
bak_dirs2=/usr/tomcat/tomcat_portal_console_8080/logs8080back
date=`date +%Y%m%d`

#打包压缩备份8000的日志bak_dirs1
cd $s1 && tar -zcvf $date.tgz *.log  *.txt
mv *.tgz $bak_dirs1

#打包文件压缩备份到8089的日志bak_dirs2 
cd $s2 && tar -zcvf $date.tgz *.log *.txt
mv *.tgz $bak_dirs2
sleep 3

#删除日志文件保留3天的日志
find   $s1 -type f -name  "*.txt"            -mtime +3 |xargs rm -rf
find   $s2 -type f -name  "*.txt"            -mtime +3 |xargs rm -rf
find   $s1 -type f -name  "*.log"            -mtime +3 | xargs rm -rf
find   $s2 -type f -name  "*.log"            -mtime +3 | xargs rm -rf


echo " " >/usr/tomcat/tomcat_service_admin_8084/logs/catalina.out
echo " " >/usr/tomcat/tomcat_portal_console_8080/logs/catalina.out
echo “Backup Process Done”