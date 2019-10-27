#!/bin/bash

#显示当前日期和时间
echo `date +%Y-%m-%d-%H:%M:%S`

#查看哪个IP地址连接的最多
netstat -an | grep ESTABLISHED | awk '{print $5}'|awk -F: '{print $1}' | sort | uniq -c

#awk不排序删除重复行
awk '!x[$0]++' filename 
#x只是一个数据参数的名字，是一个map，做指定的逻辑判断，如果逻辑判断成立，则执行指定的命令；不成立，直接跳过这一行

#查看最常使用的10个unix命令
awk '{print $1}' ~/.bash_history | sort | uniq -c | sort -rn | head -n 10
#sort中的-r是降序,_-n是按照数值排序(默认比较字符,10<2)

#逆序查看文件
cat 1.txt | awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }'

#查看第3到6行
awk 'NR >=3 && NR <=6' filename 

#crontab文件的一些示例
30 21 * * * /usr/local/etc/rc.d/lighttpd restart #每晚9.30重启apache
45 4 1,10,22 * * /usr/local/etc/rc.d/lighttpd restart #每月的1,10,22日的4:45重启apache
10 1 * * 6,0  /usr/local/etc/rc.d/lighttpd restart  #每周六、日的1:10重启apache
0,30 18-23 * * *  /usr/local/etc/rc.d/lighttpd restart #表示在每天18.00至23.00之间每隔30分钟重启apache
* 23-7/1 * * *  /usr/local/etc/rc.d/lighttpd restart #晚上11点到早上7点之间，每隔一小时重启apache

#删除某路径下N天前的特定文件
find /usr/local/backups -mtime +10 -name "*.*" -exec rm -rf {} \;



