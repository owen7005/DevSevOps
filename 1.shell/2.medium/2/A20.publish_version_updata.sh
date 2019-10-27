#!/bin/sh
# Author :
# Date : 2016-04-15 19:50
# Des : The scripts is updata publish version
# Use : sh publish_version_updata.sh fsd_api_online

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
LOG="/data/log/publish_version_updata/publish_$DATE.log" #log路径
RSYNC_SERVER="10.25.4.254"
#YFB_SERVER="10.47.100.19"

LOG_SALT() #定义/usr/bin/salt调用rsync更新时候的LOG
{
	if [ $? -eq 0 ];then
                COLER GREEN NO "########## $PROJECT publish rsync updata is ok ###########" | tee -a $LOG
        else
                COLER RED NO "########## $PROJECT publish rsync updata is error ###########" | tee -a $LOG
        fi
}

LOG_INFO() #定义更新项目日志
{
	COLER GREEN NO "#######################*************###########################" | tee -a $LOG
	COLER GREEN NO "$DATE: Now updata $PROJECT"  | tee -a $LOG
}

case $PROJECT in
	fsd_api_pre) #Credit_api项目
	LOG_INFO
	cd $CODE_JAVA/fsd_api_online
        tar -zcf ROOT_$DATE.tar.gz ROOT
	rm -rf ROOT && unzip -q ROOT.war -d ROOT #解压war包
        /usr/bin/salt "Fsd_api01_test" cmd.run "/bin/sh /root/scripts/killjava.sh" #杀进程
        sleep 5
	/usr/bin/salt "Fsd_api01_test" cmd.run "rsync -avzP --delete --exclude=system.properties --exclude=site.properties --exclude=jdbc.properties --exclude=redis.properties --exclude=zmxy.properties --exclude-from=/data/bak/exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_api_online/ROOT /data/credit-api-8081/webapps/" | tee -a $LOG #/usr/bin/salt对all_java_api组调用rsync命令
        /usr/bin/salt "Fsd_api01_test" cmd.run "cd /data/credit-api-8081/ && rm -rf work"
        /usr/bin/salt "Fsd_api01_test" cmd.run "cd /data/credit-api-8081/webapps/ROOT/friends && sed -i "s%http://test-op.fangsdai.com:81/%http://pre-op.fangsdai.com/%g" xsflsxj.html" |tee -a $LOG #将配置替换为pre环境
	nohup /usr/bin/salt "Fsd_api01_test" cmd.run "source /etc/profile && cd /data/credit-api-8081/bin && ./startup.sh" &#启动tomcat
        sleep 1m
        pkill -f Fsd_api01_test
	LOG_SALT #LOG_SALT函数
	;;

	fsd_api_online) #Credit_api项目
	LOG_INFO
	cd $CODE_JAVA/fsd_api_online
        /usr/bin/salt "Fsd-api01" cmd.run "/bin/sh /root/scripts/killjava.sh" #杀进程
        sleep 30
	/usr/bin/salt "Fsd-api01" cmd.run "rsync -avzP --delete --exclude-from=/data/bak/exclude.txt /data/credit-api-8081/webapps/ root@$RSYNC_SERVER::publish_version/code_java/fsd_api_online/rollback" | tee -a $LOG #/usr/bin/salt对api生产进行备份，以便回退
	/usr/bin/salt "Fsd-api01" cmd.run "rsync -avzP --delete --exclude=system.properties --exclude=site.properties --exclude=jdbc.properties --exclude=redis.properties --exclude=zmxy.properties --exclude-from=/data/bak/exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_api_online/ROOT /data/credit-api-8081/webapps/" | tee -a $LOG #/usr/bin/salt对all_java_api组调用rsync命令
        /usr/bin/salt "Fsd-api01" cmd.run "cd /data/credit-api-8081/ && rm -rf work" #清理tomcat缓存目录，避免加载了旧的类
        /usr/bin/salt "Fsd-api01" cmd.run "cd /data/credit-api-8081/webapps/ROOT/friends && sed -i "s%https://pre-op.fangsdai.com/%https://op.fangsdai.com/%g" xsflsxj.html" |tee -a $LOG #将
	nohup /usr/bin/salt "Fsd-api01" cmd.run "source /etc/profile && cd /data/credit-api-8081/bin && ./startup.sh" & #启动tomcat
        sleep 1m
	pkill -f Fsd-api01
	LOG_SALT #LOG_SALT函数
	;;

        fsd_api02_online) #Credit_api项目
        LOG_INFO
        cd $CODE_JAVA/fsd_api_online
        /usr/bin/salt "Fsd-api02" cmd.run "/bin/sh /root/scripts/killjava.sh" #杀进程
        sleep 30
        /usr/bin/salt "Fsd-api02" cmd.run "rsync -avzP --delete --exclude=system.properties --exclude=site.properties --exclude=jdbc.properties --exclude=redis.properties --exclude=zmxy.properties --exclude-from=/data/bak/exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_api_online/ROOT /data/credit-api-8081/webapps/" | tee -a $LOG #/usr/bin/salt对all_java_api组调用rsync命令
        /usr/bin/salt "Fsd-api02" cmd.run "cd /data/credit-api-8081/ && rm -rf work"
        /usr/bin/salt "Fsd-api02" cmd.run "cd /data/credit-api-8081/webapps/ROOT/friends && sed -i "s%https://pre-op.fangsdai.com/%https://op.fangsdai.com/%g" xsflsxj.html" |tee -a $LOG #将
        nohup /usr/bin/salt "Fsd-api02" cmd.run "source /etc/profile && cd /data/credit-api-8081/bin && ./startup.sh" &#启动tomcat
        sleep 3
	pkill -f Fsd-api02
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_mg01_pre) #Credit_web项目
        LOG_INFO
        cd $CODE_JAVA/fsd_web_online
        tar -zcf ROOT_$DATE.tar.gz ROOT
        rm -rf ROOT && unzip -q ROOT.war -d ROOT #解压war包
        nohup /usr/bin/salt "Fsd_mg01_test" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./shutdown.sh" &#停tomcat
        sleep 30
        pkill -f Fsd_mg01_test
        /usr/bin/salt "Fsd_mg01_test" cmd.run "pkill -f credit-web-8080" #杀进程
        sleep 5
        /usr/bin/salt "Fsd_mg01_test" cmd.run "rsync -avzP --delete --exclude=spring.xml --exclude=caprice.properties --exclude=system.properties --exclude=spring-task.xml --exclude=versions.txt --exclude=xianfeng.properties --exclude=redis.properties root@$RSYNC_SERVER::publish_version/code_java/fsd_web_online/ROOT/ /data/credit-web-8080/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_mg组调用rsync命令
        /usr/bin/salt "Fsd-mg01_test" cmd.run "cd /data/credit-web-8080/ && rm -rf work" #清理tomcat缓存目录
        nohup /usr/bin/salt "Fsd_mg01_test" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./startup.sh" &#启动tomcat
        sleep 5
        pkill -f Fsd_mg01_test
        sleep 1m
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_mg01_online) #Credit_web项目
        LOG_INFO
        cd $CODE_JAVA/fsd_web_online
        nohup /usr/bin/salt "Fsd-mg01" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./shutdown.sh" &#停tomcat
        sleep 30
        pkill -f Fsd-mg01
        /usr/bin/salt "Fsd-mg01" cmd.run "pkill -f credit-web-8080" #杀进程
        /usr/bin/salt "Fsd-mg01" cmd.run "rsync -avzP --delete /data/credit-web-8080/webapps/ROOT root@$RSYNC_SERVER::publish_version/code_java/fsd_web_online/rollback/" | tee -a $LOG #将mg01生产代码备份，以便后续回退
        sleep 5
        /usr/bin/salt "Fsd-mg01" cmd.run "rsync -avzP --delete --exclude=redis.properties --exclude=spring.xml --exclude=caprice.properties --exclude=system.properties --exclude=spring-task.xml --exclude=versions.txt --exclude=xianfeng.properties --exclude-from=/data/bak/exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_web_online/ROOT/ /data/credit-web-8080/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_mg组调用rsync命令
        /usr/bin/salt "Fsd-mg01" cmd.run "cd /data/credit-web-8080/ && rm -rf work" #清理tomcat缓存目录
        nohup /usr/bin/salt "Fsd-mg01" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./startup.sh" &#启动tomcat
        sleep 5
        pkill -f Fsd-mg01
        sleep 1m
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_mg02_online) #Credit_web项目
        LOG_INFO
        cd $CODE_JAVA/fsd_web_online
        nohup /usr/bin/salt "Fsd-mg02" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./shutdown.sh" &#停tomcat
        sleep 30
        pkill -f Fsd-mg02
        /usr/bin/salt "Fsd-mg02" cmd.run "pkill -f credit-web-8080" #杀进程
        /usr/bin/salt "Fsd-mg02" cmd.run "rsync -avzP --delete /data/credit-web-8080/webapps/ROOT/ root@$RSYNC_SERVER::publish_version/code_java/fsd_web_online/rollback/timerROOT/" | tee -a $LOG #将mg01生产代码备份，以便后续回退
        sleep 5
        /usr/bin/salt "Fsd-mg02" cmd.run "rsync -avzP --delete --exclude=redis.properties --exclude=spring.xml --exclude=caprice.properties --exclude=system.properties --exclude=spring-task.xml --exclude=versions.txt --exclude=xianfeng.properties --exclude-from=/data/bak/exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_web_online/ROOT/ /data/credit-web-8080/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_mg组调用rsync命令
        /usr/bin/salt "Fsd-mg02" cmd.run "cd /data/credit-web-8080/ && rm -rf work" #清理tomcat缓存目录
        nohup /usr/bin/salt "Fsd-mg02" cmd.run "source /etc/profile && cd /data/credit-web-8080/bin && ./startup.sh" &#启动tomcat
        sleep 5
        pkill -f Fsd-mg02
        LOG_SALT #LOG_SALT函数
	sleep 10
        ;;


        fsd_pic01_pre) #Credit_pic项目
        LOG_INFO
        cd $CODE_JAVA/fsd_file_online
        tar zcf ROOT_$DATE.tar.gz ROOT
        rm -rf ROOT && unzip -q ROOT.war -d ROOT #解压war包
        /usr/bin/salt "Fsd-pic01-test" cmd.run "pkill -f credit-file-8080" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic01-test" cmd.run "rsync -avz --delete --exclude=filepath.properties --exclude=redis.properties --exclude=log4j.xml root@$RSYNC_SERVER::publish_version/code_java/fsd_file_online/ROOT/ /data/credit-file-8080/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_pic组调用rsync命令
        /usr/bin/salt "Fsd-pic01_test" cmd.run "cd /data/credit-file-8080/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic01-test" cmd.run "source /etc/profile && cd /data/credit-file-8080/bin && ./startup.sh" &#启动tomcat
        sleep 1m
        pkill -f Fsd-pic01-test
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_pic01_online) #Credit_pic项目
        LOG_INFO
        cd $CODE_JAVA/fsd_file_online
        nohup /usr/bin/salt "Fsd-pic01" cmd.run "source /etc/profile && cd /data/credit-file-8080/bin && ./shutdown.sh" &#停tomcat
        sleep 30
        pkill -f Fsd-pic01
        /usr/bin/salt "Fsd-pic01" cmd.run "pkill -f credit-file-8080" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic01" cmd.run "rsync -avz --delete --exclude=filepath.properties --exclude=redis.properties root@$RSYNC_SERVER::publish_version/code_java/fsd_file_online/ROOT/ /data/credit-file-8080/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_pic组调用rsync命令
        /usr/bin/salt "Fsd-pic01" cmd.run "cd /data/credit-file-8080/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic01" cmd.run "source /etc/profile && cd /data/credit-file-8080/bin && ./startup.sh" &#启动tomcat
        sleep 1m
        pkill -f Fsd-pic01
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_pic02_online) #Credit_pic项目
        LOG_INFO
        cd $CODE_JAVA/fsd_file_online
        nohup /usr/bin/salt "Fsd-pic02" cmd.run "source /etc/profile && cd /data/credit-file-8080/bin && ./shutdown.sh" &#停tomcat
        sleep 30
        pkill -f Fsd-pic02
        /usr/bin/salt "Fsd-pic02" cmd.run "pkill -f credit-file-8080" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic02" cmd.run "rsync -avz --delete --exclude=filepath.properties --exclude=redis.properties root@$RSYNC_SERVER::publish_version/code_java/fsd_file_online/ROOT/ /data/credit-file-8080/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_pic组调用rsync命令
        /usr/bin/salt "Fsd-pic02" cmd.run "cd /data/credit-file-8080/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic02" cmd.run "source /etc/profile && cd /data/credit-file-8080/bin && ./startup.sh" &#启动tomcat
        sleep 3
        pkill -f Fsd-pic02
        LOG_SALT #LOG_SALT函数
        ;;


        fsd_sms01_pre) #Credit_sms短信项目
        LOG_INFO
        cd $CODE_JAVA/fsd_sms_online
        tar zcf ROOT_$DATE.tar.gz ROOT
        rm -rf ROOT && unzip -q ROOT.war -d ROOT #解压war包
        /usr/bin/salt "Fsd-pic01-test" cmd.run "pkill -f credit-sms-8680" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic01-test" cmd.run "rsync -avz --delete --exclude=config.properties --exclude=spring.xml --exclude=spring-timer.xml root@$RSYNC_SERVER::publish_version/code_java/fsd_sms_online/ROOT/ /data/credit-sms-8680/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_sms组调用rsync命令
        /usr/bin/salt "Fsd-pic01-test" cmd.run "cd /data/credit-sms-8680/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic01-test" cmd.run "source /etc/profile && cd /data/credit-sms-8680/bin && ./startup.sh" &#启动tomcat
        sleep 10
        pkill -f Fsd-pic01-test
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_sms01_online) #Credit_sms短信项目
        LOG_INFO
        cd $CODE_JAVA/fsd_sms_online
        /usr/bin/salt "Fsd-pic01" cmd.run "pkill -f credit-sms-8680" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic01" cmd.run "rsync -avz --delete --exclude=config.properties --exclude=spring.xml --exclude=spring-timer.xml root@$RSYNC_SERVER::publish_version/code_java/fsd_sms_online/ROOT/ /data/credit-sms-8680/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_sms组调用rsync命令
        /usr/bin/salt "Fsd-pic01" cmd.run "cd /data/credit-sms-8680/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic01" cmd.run "source /etc/profile && cd /data/credit-sms-8680/bin && ./startup.sh" &#启动tomcat
        sleep 40
        pkill -f Fsd-pic01
        LOG_SALT #LOG_SALT函数
        ;;
        
        fsd_sms02_online) #Credit_sms短信项目
        LOG_INFO
        cd $CODE_JAVA/fsd_sms_online
        /usr/bin/salt "Fsd-pic02" cmd.run "pkill -f credit-sms-8680" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic02" cmd.run "rsync -avz --delete --exclude=config.properties --exclude=spring.xml --exclude=spring-timer.xml root@$RSYNC_SERVER::publish_version/code_java/fsd_sms_online/ROOT/ /data/credit-sms-8680/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_sms组调用rsync命令
        /usr/bin/salt "Fsd-pic02" cmd.run "cd /data/credit-sms-8680/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic02" cmd.run "source /etc/profile && cd /data/credit-sms-8680/bin && ./startup.sh" &#启动tomcat
        sleep 10
        pkill -f Fsd-pic02
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_operating01_pre) #Credit_operating渠道管理后台
        LOG_INFO
        cd $CODE_JAVA/fsd_operating_online
        tar zcf ROOT_$DATE.tar.gz ROOT
        rm -rf ROOT && unzip -q ROOT.war -d ROOT #解压war包
        /usr/bin/salt "Fsd-pic01-test" cmd.run "pkill -f credit-operating-8780" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic01-test" cmd.run "rsync -avz --delete --exclude=config.properties --exclude=system.properties --exclude-from=/data/bak/oper.exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_operating_online/ROOT/ /data/credit-operating-8780/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_operating组调用rsync命令
        /usr/bin/salt "Fsd-pic01-test" cmd.run "cd /data/credit-operating-8780/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic01-test" cmd.run "source /etc/profile && cd /data/credit-operating-8780/bin && ./startup.sh" & #启动tomcat
        sleep 10
        pkill -f Fsd-pic01-test
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_operating01_online) #Credit_operating渠道管理后台
        LOG_INFO
        cd $CODE_JAVA/fsd_operating_online
        /usr/bin/salt "Fsd-pic01" cmd.run "pkill -f credit-operating-8780" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic01" cmd.run "rsync -avz --delete --exclude=config.properties --exclude=system.properties --exclude=spring.xml --exclude-from=/data/bak/oper.exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_operating_online/ROOT/ /data/credit-operating-8780/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_operating组调用rsync命令
        /usr/bin/salt "Fsd-pic01" cmd.run "cd /data/credit-operating-8780/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic01" cmd.run "source /etc/profile && cd /data/credit-operating-8780/bin && ./startup.sh" &#启动tomcat
        sleep 1m
        pkill -f Fsd-pic01
        LOG_SALT #LOG_SALT函数
        ;;
        
        fsd_operating02_online) #Credit_operating渠道管理后台
        LOG_INFO
        cd $CODE_JAVA/fsd_operating_online
        /usr/bin/salt "Fsd-pic02" cmd.run "pkill -f credit-operating-8780" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic02" cmd.run "rsync -avz --delete --exclude=config.properties --exclude=system.properties --exclude=spring.xml --exclude-from=/data/bak/oper.exclude.txt root@$RSYNC_SERVER::publish_version/code_java/fsd_operating_online/ROOT/ /data/credit-operating-8780/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_operating组调用rsync命令
        /usr/bin/salt "Fsd-pic02" cmd.run "cd /data/credit-operating-8780/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic02" cmd.run "source /etc/profile && cd /data/credit-operating-8780/bin && ./startup.sh" &#启动tomcat
        sleep 10
        pkill -f Fsd-pic02
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_salesman01_pre) #Credit_salesman H5渠道管理后台
        LOG_INFO
        cd $CODE_JAVA/fsd_salesman_online
        tar zcf ROOT_$DATE.tar.gz ROOT
        rm -rf ROOT && unzip -q ROOT.war -d ROOT #解压war包
        /usr/bin/salt "Fsd-pic01-test" cmd.run "pkill -f credit-salesman-8880" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic01-test" cmd.run "rsync -avz --delete --exclude=config.properties --exclude=system.properties root@$RSYNC_SERVER::publish_version/code_java/fsd_salesman_online/ROOT/ /data/credit-salesman-8880/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_salesman组调用rsync命令
        /usr/bin/salt "Fsd-pic01-test" cmd.run "cd /data/credit-salesman-8880/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic01-test" cmd.run "source /etc/profile && cd /data/credit-salesman-8880/bin && ./startup.sh" & #启动tomcat
        sleep 10
        pkill -f Fsd-pic01-test
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_salesman01_online) #Credit_salesman H5渠道管理后台
        LOG_INFO
        cd $CODE_JAVA/fsd_salesman_online
        /usr/bin/salt "Fsd-pic01" cmd.run "pkill -f credit-salesman-8880" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic01" cmd.run "rsync -avz --delete --exclude=config.properties --exclude=system.properties root@$RSYNC_SERVER::publish_version/code_java/fsd_salesman_online/ROOT/ /data/credit-salesman-8880/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_salesman组调用rsync命令
        /usr/bin/salt "Fsd-pic01" cmd.run "cd /data/credit-salesman-8880/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic01" cmd.run "source /etc/profile && cd /data/credit-salesman-8880/bin && ./startup.sh" &#启动tomcat
        sleep 1m
        pkill -f Fsd-pic01
        LOG_SALT #LOG_SALT函数
        ;;

        fsd_salesman02_online) #Credit_salesman H5渠道管理后台
        LOG_INFO
        cd $CODE_JAVA/fsd_salesman_online
        /usr/bin/salt "Fsd-pic02" cmd.run "pkill -f credit-salesman-8880" #杀进程
        sleep 10
        /usr/bin/salt "Fsd-pic02" cmd.run "rsync -avz --delete --exclude=config.properties --exclude=system.properties root@$RSYNC_SERVER::publish_version/code_java/fsd_salesman_online/ROOT/ /data/credit-salesman-8880/webapps/ROOT/" | tee -a $LOG #/usr/bin/salt对all_java_salesman组调用rsync命令
        /usr/bin/salt "Fsd-pic02" cmd.run "cd /data/credit-salesman-8880/ && rm -rf work"
        nohup /usr/bin/salt "Fsd-pic02" cmd.run "source /etc/profile && cd /data/credit-salesman-8880/bin && ./startup.sh" &#启动tomcat
        sleep 1m
        pkill -f Fsd-pic02
        LOG_SALT #LOG_SALT函数
        ;;

	fsd_www_pre) #官网静态页面
	LOG_INFO
        cd $CODE_JS/
        tar -zcf fsd_www_online_$DATE.tar.gz fsd_www_online
	/usr/bin/salt -N "test_www" cmd.run "rsync -avz --delete --exclude=FangSuDai root@$RSYNC_SERVER::publish_version/code_js/fsd_www_online/ /data/www/credit-www/" | tee -a $LOG #/usr/bin/salt对all_www组调用rsync命令
	LOG_SALT #LOG_SALT函数
	/usr/bin/salt -N "test_www" cmd.run "chown nginx.nginx /data/www/ -R"
	;;

	fsd_www) #官网静态页面
	LOG_INFO
	/usr/bin/salt -N "all_www" cmd.run "rsync -avz --delete --exclude=FangSuDai root@$RSYNC_SERVER::publish_version/code_js/fsd_www_online/ /data/www/credit-www/" | tee -a $LOG #/usr/bin/salt对all_www组调用rsync命令
	LOG_SALT #LOG_SALT函数
	/usr/bin/salt -N "all_www" cmd.run "chown nginx.nginx /data/www/ -R"
	;;


	fsd_web_pre) #房速贷php官网
	LOG_INFO
        cd $CODE_PHP/
        tar -zcf fsd_phpweb_online_$DATE.tar.gz fsd_phpweb_online
        rsync -avz --delete /tmp/target/fsd-phpweb/ /data/publish_version/code_php/fsd_phpweb_online/
	/usr/bin/salt -N "test_www" cmd.run "rsync -avz --delete --exclude=FangSuDai --exclude=.git --exclude=.gitignore root@$RSYNC_SERVER::publish_version/code_php/fsd_phpweb_online/ /data/www/credit-web/" | tee -a $LOG #/usr/bin/salt对all_www组调用rsync命令
	LOG_SALT #LOG_SALT函数
	/usr/bin/salt -N "test_www" cmd.run "chown nginx.nginx /data/www/ -R && cd /data/www/credit-web/Application && mkdir Runtime && chown -R nginx.nginx Runtime && chmod -R 777 Runtime"
	;;

	fsd_web_online) #房速贷php官网
	LOG_INFO
	/usr/bin/salt -N "all_www" cmd.run "rsync -avz --delete --exclude=FangSuDai root@$RSYNC_SERVER::publish_version/code_php/fsd_phpweb_online/ /data/www/credit-web/" | tee -a $LOG #/usr/bin/salt对all_www组调用rsync命令
	LOG_SALT #LOG_SALT函数
        /usr/bin/salt -N "all_www" cmd.run "chown nginx.nginx /data/www/ -R && cd /data/www/credit-web/Application && mkdir Runtime && chown -R nginx.nginx Runtime && chmod -R 777 Runtime"
	;;


        fsd_mobile_pre) #官网h5静态页面
        LOG_INFO
        cd $CODE_JS/
        tar -zcf fsd_mobile_online_$DATE.tar.gz fsd_mobile_online
        /usr/bin/salt -N "test_www" cmd.run "rsync -avz --delete root@$RSYNC_SERVER::publish_version/code_js/fsd_mobile_online/ /data/www/credit-h5/" | tee -a $LOG #/usr/bin/salt对all_www组调用rsync命令
        LOG_SALT #LOG_SALT函数
        /usr/bin/salt -N "test_www" cmd.run "chown nginx.nginx /data/www/ -R"
        ;;

        fsd_mobile) #官网H5静态页面
        LOG_INFO
        /usr/bin/salt -N "all_www" cmd.run "rsync -avz --delete root@$RSYNC_SERVER::publish_version/code_js/fsd_mobile_online/ /data/www/credit-h5/" | tee -a $LOG #/usr/bin/salt对all_www组调用rsync命令
        LOG_SALT #LOG_SALT函数
        /usr/bin/salt -N "all_www" cmd.run "chown nginx.nginx /data/www/ -R"
        ;;


        fsd_smh5_pre) #官网h5静态页面转向第三方公司
        LOG_INFO
        cd $CODE_JS/
        tar -zcf fsd_smh5_online_$DATE.tar.gz fsd_smh5_online
        yes|cp -r /tmp/target/smh5/* /data/publish_version/code_js/fsd_smh5_online/
        /usr/bin/salt -N "test_www" cmd.run "rsync -avz --delete root@$RSYNC_SERVER::publish_version/code_js/fsd_smh5_online/ /data/www/credit-smh5/" | tee -a $LOG #/usr/bin/salt对all_www组调用rsync命令
        LOG_SALT #LOG_SALT函数
        /usr/bin/salt -N "test_www" cmd.run "chown nginx.nginx /data/www/ -R"
        ;;

        fsd_smh5) #官网H5静态页面转向第三方公司
        LOG_INFO
        /usr/bin/salt -N "all_www" cmd.run "rsync -avz --delete root@$RSYNC_SERVER::publish_version/code_js/fsd_smh5_online/ /data/www/credit-smh5/" | tee -a $LOG #/usr/bin/salt对all_www组调用rsync命令
        LOG_SALT #LOG_SALT函数
        /usr/bin/salt -N "all_www" cmd.run "chown nginx.nginx /data/www/ -R"
        ;;


        fsd_php_pre) #管理后台php页面
        LOG_INFO
        cd $CODE_PHP/
        tar -zcf fsd_php_online_$DATE.tar.gz fsd_php_online
        /usr/bin/salt -N "fsd_pic_test" cmd.run "rsync -avz --delete --progress --exclude=Document --exclude=tmp --exclude=config.php root@$RSYNC_SERVER::publish_version/code_php/fsd_php_online/ /data/www/credit/" | tee -a $LOG #/usr/bin/salt对Fsd_pic组调用rsync命令
        LOG_SALT #LOG_SALT函数
        /usr/bin/salt -N "fsd_pic_test" cmd.run "chown nginx.nginx /data/www/ -R && cd /data/www/credit/tmp && rm -rf *"
        /usr/bin/salt "nginx233" cmd.run "/bin/sh /root/bin/ngcache_del.sh"
        ;;

        fsd_php_online) #管理后台php页面
        LOG_INFO
        /usr/bin/salt -N "fsd_pic_online" cmd.run "rsync -avz --delete --progress --exclude=Document --exclude=tmp --exclude=config.php root@$RSYNC_SERVER::publish_version/code_php/fsd_php_online/ /data/www/credit/" | tee -a $LOG #/usr/bin/salt对Fsd_pic组调>用rsync命令
        LOG_SALT #LOG_SALT函数
        /usr/bin/salt -N "fsd_pic_online" cmd.run "chown nginx.nginx /data/www/ -R && cd /data/www/credit/tmp && rm -rf *"
#        /usr/bin/salt -N "fsd_pic_online" cmd.run "cd /data/www/credit/tmp && rm -rf *"
        ;;


        fsd_app_pre) #api站点app代码
        LOG_INFO
        cd $CODE_JS/
        tar -zcf fsd_app_online_$DATE.tar.gz --exclude=*.apk fsd_app_online
        /usr/bin/salt -N "fsd_app_test" cmd.run "rsync -avz --delete --progress --exclude=FangSuDai.plist root@$RSYNC_SERVER::publish_version/code_js/fsd_app_online/ /data/credit-api-8081/webapps/ROOT/app/" | tee -a $LOG #/usr/bin/salt对Fsd_api_app组调用rsync命令
        /usr/bin/salt -N "fsd_app_test" cmd.run "cd /data/credit-api-8081/webapps/ROOT/app && sed -i "s%https://api.fangsdai.com/%https://pre-api.fangsdai.com/%g" index.html" |tee -a $LOG #将配置替换为pre环境
        LOG_SALT #LOG_SALT函数
        #/usr/bin/salt "nginx233" cmd.run "/bin/sh /root/bin/ngcache_del.sh"
        ;;

        fsd_app_online) #api站点app代码
        LOG_INFO
        /usr/bin/salt -N "fsd_app_online" cmd.run "rsync -avz --delete --progress --exclude=FangSuDai.plist root@$RSYNC_SERVER::publish_version/code_js/fsd_app_online/ /data/credit-api-8081/webapps/ROOT/app/" | tee -a $LOG #/usr/bin/salt对Fsd_api_app组调>用rsync命令
        LOG_SALT #LOG_SALT函数
        ;;

        hdmf_wx1_online) #海贷魔方微信
        LOG_INFO
        cd $CODE_JAVA/hdmf_weixin_online
        /usr/bin/salt "Hdmf-wx01" cmd.run "pkill -f apache-tomcat-7.0.68-haidai" #杀进程
        sleep 10
        /usr/bin/salt "Hdmf-wx01" cmd.run "rsync -avzP --delete /mnt/apache-tomcat-7.0.68-haidai/webapps/haidai_weixin_1.0/ root@$RSYNC_SERVER::publish_version/code_java/hdmf_weixin_online/rollback/weixin-01/" | tee -a $LOG #将wx01生产代码备份，以便后续回退
        /usr/bin/salt "Hdmf-wx01" cmd.run "rsync -avz --delete --exclude=logs --exclude=config root@$RSYNC_SERVER::publish_version/code_java/hdmf_weixin_online/haidai_weixin_1.0/ /mnt/apache-tomcat-7.0.68-haidai/webapps/haidai_weixin_1.0/" | tee -a $LOG #/usr/bin/salt对all_java_hdmf_weixin组调用rsync命令
        /usr/bin/salt "Hdmf-wx01" cmd.run "cd /mnt/apache-tomcat-7.0.68-haidai && rm -rf work"
        nohup /usr/bin/salt "Hdmf-wx01" cmd.run "source /etc/profile && cd /mnt/apache-tomcat-7.0.68-haidai/bin && ./startup.sh" &#启动tomcat
        sleep 30
        pkill -f Hdmf-wx01
        LOG_SALT #LOG_SALT函数
        ;;

        hdmf_wx2_online) #海贷魔方微信
        LOG_INFO
        cd $CODE_JAVA/hdmf_weixin_online
        /usr/bin/salt "Hdmf-wx02" cmd.run "pkill -f apache-tomcat-7.0.68-haidai" #杀进程
        sleep 10
        /usr/bin/salt "Hdmf-wx02" cmd.run "rsync -avzP --delete /mnt/apache-tomcat-7.0.68-haidai/webapps/haidai_weixin_1.0/ root@$RSYNC_SERVER::publish_version/code_java/hdmf_weixin_online/rollback/weixin-02/" | tee -a $LOG #将wx02生产代码备份，以便后续回退
        /usr/bin/salt "Hdmf-wx02" cmd.run "rsync -avz --delete --exclude=logs --exclude=config root@$RSYNC_SERVER::publish_version/code_java/hdmf_weixin_online/haidai_weixin_1.0/ /mnt/apache-tomcat-7.0.68-haidai/webapps/haidai_weixin_1.0/" | tee -a $LOG #/usr/bin/salt对all_java_hdmf_weixin组调用rsync命令
        /usr/bin/salt "Hdmf-wx02" cmd.run "cd /mnt/apache-tomcat-7.0.68-haidai && rm -rf work"
	/usr/bin/salt "Hdmf-wx02" cmd.run "sed -i 's/openSync = 1/openSync = 0/' /mnt/apache-tomcat-7.0.68-haidai/webapps/haidai_weixin_1.0/WEB-INF/classes/config/config.properties"
        nohup /usr/bin/salt "Hdmf-wx02" cmd.run "source /etc/profile && cd /mnt/apache-tomcat-7.0.68-haidai/bin && ./startup.sh" &#启动tomcat
        sleep 30
        pkill -f Hdmf-wx02
        LOG_SALT #LOG_SALT函数
        ;;

        hdmf_mg1_online) #海贷魔方微信后台
        LOG_INFO
        cd $CODE_JAVA/hdmf_mg_online
        /usr/bin/salt "Hdmf-wx01" cmd.run "pkill -f apache-tomcat-7.0.68-manager" #杀进程
        sleep 10
        /usr/bin/salt "Hdmf-wx01" cmd.run "rsync -avzP --delete /mnt/apache-tomcat-7.0.68-manager/webapps/haidai_manager_1.0/ root@$RSYNC_SERVER::publish_version/code_java/hdmf_mg_online/rollback/mg-01/" | tee -a $LOG #将mg01生产代码备份，以便后续回退
        /usr/bin/salt "Hdmf-wx01" cmd.run "rsync -avz --delete --exclude=logs --exclude=config root@$RSYNC_SERVER::publish_version/code_java/hdmf_mg_online/haidai_manager_1.0/ /mnt/apache-tomcat-7.0.68-manager/webapps/haidai_manager_1.0/" | tee -a $LOG #/usr/bin/salt对all_java_hdmf_manager组调用rsync命令
        /usr/bin/salt "Hdmf-wx01" cmd.run "cd /mnt/apache-tomcat-7.0.68-manager && rm -rf work"
        nohup /usr/bin/salt "Hdmf-wx01" cmd.run "source /etc/profile && cd /mnt/apache-tomcat-7.0.68-manager/bin && ./startup.sh" &#启动tomcat
        sleep 30
        pkill -f Hdmf-wx01
        LOG_SALT #LOG_SALT函数
        ;;

        hdmf_mg2_online) #海贷魔方微信后台
        LOG_INFO
        cd $CODE_JAVA/hdmf_mg_online
        /usr/bin/salt "Hdmf-wx02" cmd.run "pkill -f apache-tomcat-7.0.68-manager" #杀进程
        sleep 10
        /usr/bin/salt "Hdmf-wx02" cmd.run "rsync -avzP --delete /mnt/apache-tomcat-7.0.68-manager/webapps/haidai_manager_1.0/ root@$RSYNC_SERVER::publish_version/code_java/hdmf_mg_online/rollback/mg-02/" | tee -a $LOG #将mg02生产代码备份，以便后续回退
        /usr/bin/salt "Hdmf-wx02" cmd.run "rsync -avz --delete --exclude=logs --exclude=config root@$RSYNC_SERVER::publish_version/code_java/hdmf_mg_online/haidai_manager_1.0/ /mnt/apache-tomcat-7.0.68-manager/webapps/haidai_manager_1.0/" | tee -a $LOG #/usr/bin/salt对all_java_hdmf_manager组调用rsync命令
        /usr/bin/salt "Hdmf-wx02" cmd.run "cd /mnt/apache-tomcat-7.0.68-manager && rm -rf work"
        nohup /usr/bin/salt "Hdmf-wx02" cmd.run "source /etc/profile && cd /mnt/apache-tomcat-7.0.68-manager/bin && ./startup.sh" &#启动tomcat
        sleep 30
        pkill -f Hdmf-wx02
        LOG_SALT #LOG_SALT函数
        ;;

	*)
        	COLER RED NO " ############################################################################"
        	COLER GREEN NO " ### Des:  请先更新预发布环境,在更新全部环境,脚本功能为更新正式境版本!!!  ###"
        	COLER GREEN NO " ### Des: sh       脚本名               项目                              ###"
       		COLER GREEN NO " ### Des:          以下项目为java项目                                     ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_api_pre                        ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_api_online                     ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_api02_online                   ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_mg01_pre                       ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_mg01_online                    ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_mg02_online                    ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_pic01_pre                       ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_pic01_online                    ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_pic02_online                    ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_sms01_pre                       ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_sms01_online                    ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_sms02_online                    ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_operating01_pre                 ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_operating01_online              ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_operating02_online              ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_salesman01_pre                 ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_salesman01_online              ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_salesman02_online              ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_www_pre                        ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_www_online                      ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_web_pre                        ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_web_online                      ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_mobile_pre                     ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_mobile                         ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_smh5_pre                     ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_smh5                         ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_php_online                      ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_app_pre                        ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh fsd_app_online                       ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh hdmf_wx1_online                       ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh hdmf_wx2_online                       ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh hdmf_mg1_online                       ###"
        	COLER RED NO " ### Use: sh publish_version_updata.sh hdmf_mg2_online                       ###"
        	COLER RED NO " ############################################################################"
        	exit 0
	;;

esac
#pkill -f nohup
