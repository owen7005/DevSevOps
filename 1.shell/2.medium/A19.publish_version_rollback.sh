#!/bin/sh
# Author :
# Date : 2016-04-15 19:50
# Des : The scripts is rollback publish version
# Use : sh publish_version_rollback.sh fsd_api_rollback
# 项目回退
DATE=`date +%Y%m%d_%H%M` #日期
NO="\033[0m" #退出
RED="\033[31m" #红色
GREEN="\033[32m" #绿色

COLER () #颜色函数
{
    eval echo -e "\$${1}'${3}' \$${2}" && return 0
}

PROJECT=$1 #项目
CODE_JS="/data/publish_version/code_js/" #js根目录
CODE_JAVA="/data/publish_version/code_java/" #java根目录
CODE_PHP="/data/publish_version/code_php/" #php根目录
#chown www.www $CODE_JAVA -R
LOG="/data/log/publish_version_rollback/publish_$DATE.log" #log路径
RSYNC_SERVER="10.25.4.254"

LOG_SALT() #定义/usr/bin/salt调用rsync更新时候的LOG
{
	if [ $? -eq 0 ];then
                COLER GREEN NO "########## $PROJECT publish rsync rollback is ok ###########" | tee -a $LOG
        else
                COLER RED NO "########## $PROJECT publish rsync rollback is error ###########" | tee -a $LOG
        fi
}

LOG_INFO() #定义更新项目日志
{
	COLER GREEN NO "#######################*************###########################" | tee -a $LOG
	COLER GREEN NO "$DATE: Now updata $PROJECT"  | tee -a $LOG
}

case $PROJECT in
	fsd_api01_rollback) #Credit_api项目回退
	LOG_INFO
	cd $CODE_JAVA/fsd_api_online
        /usr/bin/salt "Fsd-api01" cmd.run "/bin/sh /root/scripts/killjava.sh" #杀进程
        sleep 30
	/usr/bin/salt "Fsd-api01" cmd.run "rsync -avzP --delete --exclude-from=/data/bak/exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_api_online/rollback/ROOT/ /data/credit-api-8081/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_api组调用rsync命令
        /usr/bin/salt "Fsd-api01" cmd.run "cd /data/credit-api-8081/ && rm -rf work" #清理tomcat缓存目录
	nohup /usr/bin/salt "Fsd-api01" cmd.run "source /etc/profile && cd /data/credit-api-8081/bin && ./startup.sh" & #启动tomcat
        sleep 1m
	pkill -f Fsd-api01
	LOG_SALT #LOG_SALT函数
	;;

        fsd_api02_rollback) #Credit_api项目回退
        LOG_INFO
        cd $CODE_JAVA/fsd_api_online
        /usr/bin/salt "Fsd-api02" cmd.run "/bin/sh /root/scripts/killjava.sh" #杀进程
        sleep 30
        /usr/bin/salt "Fsd-api02" cmd.run "rsync -avzP --delete --exclude-from=/data/bak/exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_api_online/rollback/ROOT/ /data/credit-api-8081/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_api组调用rsync命令
        /usr/bin/salt "Fsd-api02" cmd.run "cd /data/credit-api-8081/ && rm -rf work" #清理tomcat缓存目录
        nohup /usr/bin/salt "Fsd-api02" cmd.run "source /etc/profile && cd /data/credit-api-8081/bin && ./startup.sh" &#启动tomcat
        sleep 3
	pkill -f Fsd-api02
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_mg01_rollback) #Credit_web项目回退
        LOG_INFO
        cd $CODE_JAVA/fsd_web_online
        nohup /usr/bin/salt "Fsd-mg01" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./shutdown.sh" &#停tomcat
        sleep 30
        pkill -f Fsd-mg01
        /usr/bin/salt "Fsd-mg01" cmd.run "pkill -f credit-web-8080" #杀进程
        sleep 5
        /usr/bin/salt "Fsd-mg01" cmd.run "rsync -avzP --delete root@$RSYNC_SERVER::publish_version/code_java/fsd_web_online/rollback/ROOT/ /data/credit-web-8080/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_mg组调用rsync命令
        /usr/bin/salt "Fsd-mg01" cmd.run "cd /data/credit-web-8080/ && rm -rf work" #清理tomcat缓存目录
        nohup /usr/bin/salt "Fsd-mg01" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./startup.sh" &#启动tomcat
        sleep 5
        pkill -f Fsd-mg01
        sleep 1m
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_mg02_rollback) #Credit_web项目回退
        LOG_INFO
        cd $CODE_JAVA/fsd_web_online
        nohup /usr/bin/salt "Fsd-mg02" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./shutdown.sh" &#停tomcat
        sleep 30
        pkill -f Fsd-mg02
        /usr/bin/salt "Fsd-mg02" cmd.run "pkill -f credit-web-8080" #杀进程
        sleep 5
        /usr/bin/salt "Fsd-mg02" cmd.run "rsync -avzP --delete root@$RSYNC_SERVER::publish_version/code_java/fsd_web_online/rollback/timerROOT/ /data/credit-web-8080/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_mg组调用rsync命令
        /usr/bin/salt "Fsd-mg02" cmd.run "cd /data/credit-web-8080/ && rm -rf work" #清理tomcat缓存目录
        nohup /usr/bin/salt "Fsd-mg02" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./startup.sh" &#启动tomcat
        sleep 5
        pkill -f Fsd-mg02
        LOG_SALT #LOG_SALT函数
	sleep 10
        ;;

	*)
        	COLER RED NO " ############################################################################"
        	COLER GREEN NO " ### Des:  请先更新预发布环境,在更新全部环境,脚本功能为更新正式境版本!!!  ###"
        	COLER GREEN NO " ### Des: sh       脚本名               项目                              ###"
       		COLER GREEN NO " ### Des:          以下项目为java项目回退                                ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_api01_rollback                  ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_api02_rollback                  ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_mg01_rollback                   ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_mg02_rollback                   ###"
        	COLER RED NO " ############################################################################"
        	exit 0
	;;

esac
#pkill -f nohup
