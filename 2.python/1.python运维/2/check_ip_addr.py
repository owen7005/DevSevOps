#!/usr/bin/python
# -*- coding:utf-8 -*-

import urllib2
import re
import sys 
import os
 
def check(ipaddr):
    '''检测ip地址归属地
    '''
    try:
        for i in ipaddr:
            url = 'http://www.ip138.com/ips138.asp?ip=%s&action=2' % i 
            request = urllib2.Request(url)
            response = urllib2.urlopen(request)
            #此处必须将html内容保存在一个变量中，如果在正则表达式中将string值写为 response.read()是无法得到正确结果的
            page = response.read()
            #解决shell环境中文乱码
            pageContent = unicode(page,'gb2312').encode('utf-8')
            ip = re.findall(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}',pageContent)
            #print "IP Address:",ip[0]
 
            #Get IP Address Location
            result = re.findall(r'(<li>.*?</li>)',pageContent)
            location = result[0].split('<li>')[1].split('</li>')[0]
            print '%s    %s' % (ip[0],location)
    except:
        print '*'*100
        print "IP %s is illegal!" % i 
    return ""
 
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print 'Syntax error!'
        print 'Example: python check_IP.py ipFile OR python check_IP.py ipadd1 [ipadd2] ......'
    else:
        ipaddr = []
        #如果是文件，就读取IP放入ipaddr中；如果是一个或多个ip地址，则解析参数放入ipaddr中
        if os.path.isfile(sys.argv[1]):
            filename = sys.argv[1]
            with open(filename) as f:
                for line in f:
                    ipaddr.append(line.strip('\n'))
            check(ipaddr)
        else:
            for i in range(1,len(sys.argv)):
                ipaddr.append(sys.argv[i])
            check(ipaddr)
