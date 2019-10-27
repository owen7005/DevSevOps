#clean_log.sh
#创建清除日志的脚本
#!/bin/bash
max=`df -h |awk 'NR==4''{print $5 }'| cut -d% -f1`
if [ "$max" -gt 75 ];then
   
    echo " " >/usr/tomcat/tomcat_portal_web_8000/logs/catalina.out
    echo " " >/usr/tomcat/tomcat_portal_web_8089/logs/catalina.out
fi


#创建计划任务，每1小时运行脚本1次
$ crontab -l
0 * * * * /bin/sh /data/clean_log.sh


#######################################################################
#!/bin/bash  
#clearLog.sh    
Dir1=/usr/local/nginx/logs/*  
devInfo=($(df -l | awk '{print $1}'))     #日志所处的磁盘  
perInfo=($(df -l | awk '{print int($5)}')) #磁盘使用率  
  
for i in `seq 0 ${#perInfo[@]}`;  
do   
   if [[ ${devInfo[i]} = '/dev/xvda1' ]] && [[ ${perInfo[i]} -ge 80 ]];  
   then  
        
     for file in $nginxDir;  
     do  
         exist=`echo $file | awk '{if(match($0,/\.log/)) print "yes"}'`;  
         if [[ -f $file ]] && [[ ${exist} = yes ]];  
         then  
           echo '' > $file;  
           echo $(date) $file "clear log ok!" >> /var/log/clear.log ;  
         fi;  
     done  
   fi;  
     
   
done 