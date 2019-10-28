#!/usr/bin/env python
#coding=utf-8

#author jincon 2016-12-3

import sys
import os
#import socket, time, thread
import socket, time

import urllib2
import json

socket.setdefaulttimeout(3)

########################################################

#This function defined must before use it;
def execCommand(commond):
   print "The command is:" + commond
   os.system(commond)
   print "The command is exec finished!"

def socket_port(ip,port):
    """
    输入IP和端口号，扫描判断端口是否开放
    """
    try:
        if port>=65535:
            print u'端口扫描结束'
        s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result=s.connect_ex((ip,port))
        if result==0:
            lock.acquire()
            print  ip,u':',port,u'端口开放'
            lock.release()
        s.close()
    except:
        print u'端口扫描异常'

def ip_scan(ip):
    """
    输入IP，扫描IP的0-65534端口情况
    """
    try:
        print u'开始扫描 %s' % ip
        start_time=time.time()
        for i in range(0,65534):


            thread.start_new_thread(socket_port,(ip,int(i)))
        print u'扫描端口完成，总共用时 ：%.2f' %(time.time()-start_time)
        raw_input("Press Enter to Exit")
    except:
        print u'扫描ip出错'

def getContent(url):
    header={'User-Agent' : 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20100101 Firefox/14.0.1','Referer' : '******'}
    request=urllib2.Request(url,None,header)
    response=urllib2.urlopen(request)
    text=response.read()
    return text

def saveText(data,file='cache.txt'):
    fp = file(file,'w')
    fp.write(data)
    fp.close()

def taobaoip(ipadd='202.102.192.68'):
   url = 'http://ip.taobao.com/service/getIpInfo.php?ip=' + ipadd
   page = urllib2.urlopen(url)
   data = page.read()
   jsondata = json.loads(data)
   if jsondata[u'code'] == 0:
       print '----------淘宝IP----------'
       print '所在国家：' + jsondata[u'data'][u'country'].encode('utf-8')
       print '所在地区：' + jsondata[u'data'][u'area'].encode('utf-8')
       print '所在省份：' + jsondata[u'data'][u'region'].encode('utf-8')
       print '所在城市：' + jsondata[u'data'][u'city'].encode('utf-8')
       print '所用运营商：' + jsondata[u'data'][u'isp'].encode('utf-8')
   else:
       print '请检查IP'


########################################################


if len(sys.argv) < 2 or sys.argv[1] == '--h' or sys.argv[1] == '--help':
    print ' ************************************************** ';
    print ' '
    print 'Hello , thank you for you use jincon\'s yunwei tools ';
    print ' '
    print '1、drop '
    print '2、del '
    print '3、ddos '
    print '4、disk '
    print '5、scan '
    print '6、ip '
    print '7、nginx '
    print ' '
    print ' ************************************************** ';
    sys.exit()

if sys.argv[1] == '--v' or sys.argv[1] == '-v' :
    print "The newest version is : v 0.1"

if sys.argv[1] == 'drop' :
   par = "iptables -A INPUT -s %s -j DROP" % sys.argv[2]
   execCommand(par)

if sys.argv[1] == 'del' :
   par = "iptables -D INPUT %d" % sys.argv[2]
   execCommand(par)

if sys.argv[1] == 'ddos' :
   par = "netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n"
   execCommand(par)

if sys.argv[1] == 'disk' :
   if len(sys.argv) < 3 :
	    _par = './'
   else:
        _par = sys.argv[2]

   par = "du -sh %s" % _par
   execCommand(par)

if sys.argv[1] == 'scan' :
   lock=thread.allocate_lock()
   if len(sys.argv) < 3 :
   	       _par = '127.0.0.1'
   else:
           _par = sys.argv[2]
   ip_scan(_par)

if sys.argv[1] == 'ip' :
   taobaoip(sys.argv[2])

if sys.argv[1] == 'nginx' :
   if len(sys.argv) < 3 :
        print "请输入您的nginx日志目录，支持系统默认的格式"
        sys.exit()
   else:
        par = "tail -1000  %s  |awk -F'- -' '{print $1$4}'|sort|uniq -c|sort -n" % sys.argv[2]
        execCommand(par)
