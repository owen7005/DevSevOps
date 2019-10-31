#!/usr/bin/python
# 查询nginx 短时间内访问太多的IP，建议nginx记录过滤掉图片、js、css等

__author__ = 'jincon'

import os;
import string;

lines_ = os.popen("tail -n 1000 /home/wwwlogs/www.jincon.cc_nginx.log  |awk -F' ' '{print $1}'|sort|uniq -c|sort -n").read();
lines = lines_.split("\n");

for line in lines:
	if line != '':
		line = line.strip();
		lineArr = line.split(" ");
		if int(lineArr[0])>50:
			print lineArr[1]+"=="+lineArr[0];


print "ok";
