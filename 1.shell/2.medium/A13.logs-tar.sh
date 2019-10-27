#!/bin/bash
#tanbin  2016-01-21
LOG_DIR="/data/credit-api-8081/logs"
LOG_FILE="catalina"
DATE=`date -d "7 days ago" "+%Y-%m-%d"`
####
cd $LOG_DIR
File=`find -name "*.$DATE.*"|grep -v "tar.gz"`
for logfile in $File;do
tar -zcf ./log_bak/$logfile.tar.gz $logfile

if [ $? -eq 0 ];then
   rm -rf $logfile
   echo "Tar file is success"
else
   echo " Tar file is failed"
   exit 1
fi
done
##
cd $LOG_DIR/credit-api
File2=`find -name "*.$DATE"|grep -v "tar.gz"`
for apilog in $File2;do
tar zcf ./log_bak/$apilog.tar.gz $apilog

if [ $? -eq 0 ];then
   rm -rf $apilog
   echo "Tar apilog is success"
else
   echo "Tar apilog is failed"
   exit 1
fi
done
