#!/bin/sh
#! /bin/sh
#Author : Zhang Zhigang  
# Date : 2016-07-01 13:50
# Des : The scripts is deploy
# Use : sh 
#
#项目名称，一般是war包的名称，例如xxx.war，则PRO_NAME="xxx"
PRO_NAME=""

#shell 文件所在目录
BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#tomcat 根目录
TOMCAT_HOME="$(dirname ${BIN_DIR})"

#tomcat 进程名称，一般是ps -ef |grep xxx 中的xxx
PRG="$(basename ${TOMCAT_HOME})"

DATE=`date +%Y%m%d%H%M%S`

if [ "$PRO_NAME" = "" ]; then
    echo "ERROR:未配置项目名称，请配置 PRO_NAME 参数值!!!"
    exit 0
fi

#kill tomcat 进程
ps -ef |grep "$PRG" | grep "jdk" | awk '{print "kill -9 " $2}' | sh

#生成一个备份目录
if [ ! -d "$TOMCAT_HOME/bak" ]; then
    mkdir $TOMCAT_HOME/bak
fi

#部署新war包，同时将旧war包备份并删除旧的程序文件
if [ -f "$TOMCAT_HOME/$PRO_NAME.war" ]; then
    if [ -f "$TOMCAT_HOME/webapps/$PRO_NAME.war" ]; then
        mv $TOMCAT_HOME/webapps/$PRO_NAME.war $TOMCAT_HOME/bak/${PRO_NAME}_$DATE.war
    fi
    rm -rf $TOMCAT_HOME/webapps/$PRO_NAME
    mv $TOMCAT_HOME/$PRO_NAME.war $TOMCAT_HOME/webapps/
fi

#启动tomcat
nohup $TOMCAT_HOME/bin/startup.sh > $TOMCAT_HOME/logs/catalina.out &

#打印启动日志
tail -f $TOMCAT_HOME/logs/catalina.out
