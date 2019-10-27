#!/bin/bash
#Author : Zhang Zhigang  
# Date : 2016-07-01 13:50
# Des : The scripts is
# 零点切割Tomcat日志

YESTERDAY_TIME=$(date -d "yesterday" +%F)
TOMCAT_LIST="tomcat-pc-8080 tomcat-pc-8081 tomcat-m-8090"
LOG_FILE="catalina.out"

for TOMCAT in $TOMCAT_LIST; do
    LOG_DIR=/data/project/$TOMCAT/logs
    LOG_MONTH_DIR=$LOG_DIR/$(date +"%Y-%m")

    [ ! -d $LOG_MONTH_DIR ] && mkdir -p $LOG_MONTH_DIR
    cp $LOG_DIR/$LOG_FILE $LOG_MONTH_DIR/${LOG_FILE/out/$YESTERDAY_TIME.log}
    >$LOG_DIR/$LOG_FILE
done