#!/bin/sh
echo > nginx_count.log
echo '-----------------------------'>> nginx_count.log
echo'启动nginx流量统计脚本,统计时间为：' >>nginx_count.log
date +%F
date +%F >> nginx_count.log
echo '正在统计历史UV'
echo '历史UV' >> nginx_count.log
awk '{print $1}' /var/log/nginx/access.log|sort | uniq -c |wc -l >> nginx_count.log
echo '正在统计历史PV'
echo '提示PV' >> nginx_count.log
awk '{print $7}' /var/log/nginx/access.log|wc -l >> nginx_count.log
echo '正在统计访问最频繁的URL'
echo '访问最频繁的URL' >> nginx_count.log
awk '{print $7}' /var/log/nginx/access.log|sort | uniq -c |sort -n -k 1 -r|more >> nginx_count.log
echo '正在统计访问最频繁的IP'
echo '访问最频繁的IP'>> nginx_count.log
awk '{print $1}' /var/log/nginx/access.log|sort | uniq -c |sort -n -k 1 -r|more>> nginx_count.log
echo '正在统计当日PV'
echo '当日PV' >> nginx_count.log