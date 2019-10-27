#!/usr/bin/evn bash
#Ncrm error log alarm (sale,ocdc,service)
SALE_LOG_PATH="/opt/docker_file/crm_prd/fjscrm_src/tmp/sale/Logs/"
OCDC_LOG_PATH="/opt/docker_file/crm_prd/fjscrm_src/tmp/ocdc/Logs/"
SERVICE_LOG_PATH="/opt/docker_file/crm_prd/fjscrm_src/tmp/service/Logs/"
SERVICE_LOG_PATH="/opt/docker_file/crm_prd/fjscrm_src/tmp/report/Logs/"
SERVICE_LOG_PATH="/opt/docker_file/crm_prd/fjscrm_src/tmp/base/Logs/"
SERVICE_LOG_PATH="/opt/docker_file/crm_prd/fjscrm_src/tmp/smd/Logs/"
DATE=`date +%y_%m_%d`
PROJECT=$1 #哪个项目报错

case $PROJECT in
     Sale)
         cd $SALE_LOG_PATH
         find ./ -name $DATE.log |grep -v Common |grep -v Home |xargs tail -n 1000 |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/saleerror.log
         #cat ./Api/$DATE.log |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/saleerror.log
         #cat ./Home/$DATE.log |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/saleerror.log
         if [ "$?" == "1" ]; then
    	        echo "$PROJECT is no ERROR!,洗洗睡吧!"
            else
                echo "$PROJECT is ERROR,尽快查看日志并通知开发处理！" |mail -s "CRM Sale is ERROR!" dengxiao@fangjinsuo.com;344472855@qq.com;xuhuijie@fangjinsuo.com
                #uuencode saleerror.log |mail -s "CRM Sale is ERROR!" 549651664@qq.com < /tmp/saleerror.log
         fi
     ;;

     Ocdc)
         cd $OCDC_LOG_PATH
         find ./ -name $DATE.log |grep -v Common |xargs tail -n 1000 |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/ocdcerror.log
         #cat ./Api/$DATE.log |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/ocdcerror.log
         if [ "$?" == "1" ]; then
    	        echo "$PROJECT is no ERROR!,洗洗睡吧!"
            else
                echo "$PROJECT is ERROR,尽快查看日志并通知开发处理！" |mail -s "CRM Ocdc is ERROR!" dengxiao@fangjinsuo.com;344472855@qq.com;xuhuijie@fangjinsuo.com;549651664@qq.com
         fi
     ;;

     Service)
         cd $SERVICE_LOG_PATH
         find ./ -name $DATE.log |grep -v Common |xargs tail -n 1000 |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/serviceerror.log
         #cat ./Api/$DATE.log |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/serviceerror.log
         if [ "$?" == "1" ]; then
    	        echo "$PROJECT is no ERROR!,洗洗睡吧!"
            else
                echo "$PROJECT is ERROR,尽快查看日志并通知开发处理！" |mail -s "CRM Service is ERROR!" dengxiao@fangjinsuo.com;344472855@qq.com;xuhuijie@fangjinsuo.com
         fi
     ;;

     Report)
         cd $SERVICE_LOG_PATH
         find ./ -name $DATE.log |grep -v Common |xargs tail -n 1000 |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/reporterror.log
         if [ "$?" == "1" ]; then
    	        echo "$PROJECT is no ERROR!,洗洗睡吧!"
            else
                echo "$PROJECT is ERROR,尽快查看日志并通知开发处理！" |mail -s "CRM Report is ERROR!" dengxiao@fangjinsuo.com;344472855@qq.com;xuhuijie@fangjinsuo.com
         fi
     ;;

     Base)
         cd $SERVICE_LOG_PATH
         find ./ -name $DATE.log |grep -v Common |xargs tail -n 1000 |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/baseerror.log
         if [ "$?" == "1" ]; then
    	        echo "$PROJECT is no ERROR!,洗洗睡吧!"
            else
                echo "$PROJECT is ERROR,尽快查看日志并通知开发处理！" |mail -s "CRM Base is ERROR!" dengxiao@fangjinsuo.com;344472855@qq.com;xuhuijie@fangjinsuo.com
         fi
     ;;

     Smd)
         cd $SERVICE_LOG_PATH
         find ./ -name $DATE.log |grep -v Common |xargs tail -n 1000 |grep ERR |grep -A 1 "ERR" |grep -v grep >/tmp/smderror.log
         if [ "$?" == "1" ]; then
    	        echo "$PROJECT is no ERROR!,洗洗睡吧!"
            else
                echo "$PROJECT is ERROR,尽快查看日志并通知开发处理！" |mail -s "CRM Smd is ERROR!" dengxiao@fangjinsuo.com;344472855@qq.com;xuhuijie@fangjinsuo.com
         fi
     ;;

     *)
     ;;
esac
