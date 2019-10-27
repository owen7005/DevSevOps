#!/bin/bash
#Author : https://github.com/owen7005
# Date : 2016-07-01 13:50
# Des : The scripts is check fsd tomcat start
# Use : sh check-tomcatstart.sh
#
DATE=`date +%Y-%m-%d` #日期
PROJECT=$1 #项目

function usage(){

cat << INFO

  usage:   ./`basename $0`  type

  example: ./`basename $0`  mg

  example: ./`basename $0`  api

  example: ./`basename $0`  sms

  example: ./`basename $0`  op

  example: ./`basename $0`  all

INFO
exit 1

}

if [ $# -ne 1 ];then
  usage
fi

function mg(){
	echo "============================================================Next mg startup log============================================================"
	salt "Fsd-mg01" cmd.run 'cat /data/credit-web-8080/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
	salt "Fsd-mg02" cmd.run 'cat /data/credit-web-8080/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
}

function api(){
	echo "============================================================Next api startup log============================================================"
	salt "Fsd-api01" cmd.run 'cat /data/credit-api-8081/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
	salt "Fsd-api02" cmd.run 'cat /data/credit-api-8081/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
}

function pic(){
	echo "============================================================Next pic startup log============================================================"
	salt "Fsd-pic01" cmd.run 'cat /data/credit-file-8080/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
	salt "Fsd-pic02" cmd.run 'cat /data/credit-file-8080/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
}

function sms(){
	echo "============================================================Next sms startup log============================================================"
	salt "Fsd-pic01" cmd.run 'cat /data/credit-sms-8680/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
	salt "Fsd-pic02" cmd.run 'cat /data/credit-sms-8680/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
}

function op(){
	echo "============================================================Next op startup log============================================================"
	salt "Fsd-pic01" cmd.run 'cat /data/credit-operating-8780/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
	salt "Fsd-pic02" cmd.run 'cat /data/credit-operating-8780/logs/catalina.`date +%Y-%m-%d`.out |grep -A 10 "org.apache.catalina.startup.HostConfig deployDirectory"'
}

case $PROJECT in
	mg) #信贷后台
	mg
	;;
	api) #信贷api
	api
	;;
	pic) #信贷图片
	pic
	;;
	sms) #信贷短信
	sms
	;;
	op) #信贷运营后台
	op
	;;
	all) #信贷以上所有项目
	mg
	api
	pic
	sms
	op
	;;
	*)
	usage
	;;
esac
