#1.判断是否是一个目录
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : opsonly
# @Site    : 
# @File    : opsUse.py
# @Software: PyCharm
import os

dir = "/var/www/html/EnjoyCarApi/"
if os.path.isdir(dir):
    print('%s is a dir' % dir)
else:
    print('%s is not a dir' % dir)


#2.系统内存与磁盘检测
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-17 17:16
# @Author  : opsonly
# @Site    : 
# @File    : systemissue.py
# @Software: PyCharm

import psutil

def memissue():
    print('内存信息：')
    mem = psutil.virtual_memory()
    # 单位换算为MB
    memtotal = mem.total/1024/1024
    memused = mem.used/1024/1024
    membaifen = str(mem.used/mem.total*100) + '%'

    print('%.2fMB' % memused)
    print('%.2fMB' % memtotal)
    print(membaifen)

def cuplist():
    print('磁盘信息：')
    disk = psutil.disk_partitions()
    diskuse = psutil.disk_usage('/')
    #单位换算为GB
    diskused = diskuse.used / 1024 / 1024 / 1024
    disktotal = diskuse.total / 1024 / 1024 / 1024
    diskbaifen = diskused / disktotal * 100
    print('%.2fGB' % diskused)
    print('%.2fGB' % disktotal)
    print('%.2f' % diskbaifen)


memissue()
print('*******************')
cuplist()


#3.统计nginx日志前十ip访问量并以柱状图显示
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:49
# @Author  : opsonly
# @Site    : 
# @File    : nginx_ip.py
# @Software: PyCharm

import matplotlib.pyplot as plt
#
nginx_file = 'nginx2018-12-18_07:45:26'

ip = {}
# 筛选nginx日志文件中的ip
with open(nginx_file) as f:
    for i in f.readlines():
        s = i.strip().split()[0]
        lengh = len(ip.keys())

        # 统计每个ip的访问量以字典存储
        if s in ip.keys():
            ip[s] = ip[s] + 1
        else:
            ip[s] = 1


#以ip出现的次数排序返回对象为list
ip = sorted(ip.items(), key=lambda e:e[1], reverse=True)

#取列表前十
newip = ip[0:10:1]
tu = dict(newip)

x = []
y = []
for k in tu:
    x.append(k)
    y.append(tu[k])
plt.title('ip access')
plt.xlabel('ip address')
plt.ylabel('PV')

#x轴项的翻转角度
plt.xticks(rotation=70)

#显示每个柱状图的值
for a,b in zip(x,y):
    plt.text(a, b, '%.0f' % b, ha='center', va= 'bottom',fontsize=7)


plt.bar(x,y)
plt.legend()
plt.show()
test.png


#4.查看网段里有多少ip地址
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:31
# @Author  : opsonly
# @Site    : 
# @File    : ipTest.py
# @Software: PyCharm
import IPy

ip = IPy.IP('172.16.0.0/26')

print(ip.len())
for i in ip:
    print(i)



#5.gitlab钩子脚本，实现简单自动化操作
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 17:41
# @Author  : opsonly
# @Site    :
# @File    : gitlabCi.py
# @Software: PyCharm


from flask import Flask,request,render_template,make_response,Response
import json,os,re,requests
import subprocess

app = Flask(__name__)
null = ""
cmd = "/var/www/html/ladmin-devel/"
@app.route('/test',methods=['POST'])
def hello():
    json_dict = json.loads(request.data)

    name = json_dict['event_name']
    ref = json_dict['ref'][11:]
    project = json_dict['project']['name']

    if name == 'push' and ref == 'master':
        os.chdir(cmd)
        s = subprocess.getoutput('sudo -u nginx composer install')
        return Response(s)
    else:
        return Response('none')


if __name__ == '__main__':
    app.run(host='0.0.0.0',port=8080)


#6.解析一组域名的ip地址
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-20 10:21
# @Author  : opsonly
# @Site    : 
# @File    : dnsReloves.py
# @Software: PyCharm

import dns.resolver
from collections import defaultdict
hosts = ['baidu.com','weibo.com']
s = defaultdict(list)
def query(hosts):
    for host in hosts:
        ip = dns.resolver.query(host,"A")
        for i in ip:
            s[host].append(i)

    return s

for i in query(hosts):

    print(i,s[i])

#7.清除指定redis缓存
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-20 15:19
# @Author  : opsonly
# @Site    : 
# @File    : redisdel.py
# @Software: PyCharm

import redis


#选择连接的数据库
db = input('输入数据库:')
r = redis.Redis(host='127.0.0.1',port=6379,db=0)

#输入要匹配的键名
id = input('请输入要执匹配的字段：')
arg = '*' + id + '*'

n = r.keys(arg)
#查看匹配到键值
for i in n:
    print(i.decode('utf-8'))

#确定清除的键名
delid = input('输入要删除的键：')

print('清除缓存 %s 成功' % delid)


#8.下载阿里云RDS二进制日志
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-12 13:52
# @Author  : opsonly
# @Site    : 
# @File    : rds_binlog.py
# @Software: PyCharm

'''
查询阿里云rds binlog日志
'''

import base64,urllib.request
import hashlib
import hmac
import uuid,time,json,wget



class RDS_BINLOG_RELATE(object):

    def __init__(self):
        #阿里云的id和key
        self.access_id = '**********************'
        self.access_key = '**********************'

    #通过id和key来进行签名
    def signed(self):
        timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        header = {
            'Action': 'DescribeBinlogFiles',
            'DBInstanceId': 'rm-sdfasdfasdfa',
            'StartTime': '2018-07-11T15:00:00Z',
            'EndTime': timestamp,
            'Format': 'JSON',
            'Version': '2014-08-15',
            'AccessKeyId': self.access_id,
            'SignatureVersion': '1.0',
            'SignatureMethod': 'HMAC-SHA1',
            'SignatureNonce': str(uuid.uuid1()),
            'TimeStamp': timestamp,

        }

        #对请求头进行排序
        sortedD = sorted(header.items(), key=lambda x: x[0])
        url = 'https://rds.aliyuncs.com'
        canstring = ''

        #将请求参数以#连接
        for k, v in sortedD:
            canstring += '&' + self.percentEncode(k) + '=' + self.percentEncode(v)

        #对请求连接进行阿里云要的编码规则进行编码
        stiingToSign = 'GET&%2F&' + self.percentEncode(canstring[1:])

        bs = self.access_key + '&'
        bs = bytes(bs, encoding='utf8')
        stiingToSign = bytes(stiingToSign, encoding='utf8')
        h = hmac.new(bs, stiingToSign, hashlib.sha1)
        stiingToSign = base64.b64encode(h.digest()).strip()

        #将签名加入到请求头
        header['Signature'] = stiingToSign

        #返回url
        url = url + "/?" + urllib.parse.urlencode(header)
        return url

    #按照规则替换
    def percentEncode(self,store):
        encodeStr = store
        res = urllib.request.quote(encodeStr)
        res = res.replace('+', '%20')
        res = res.replace('*', '%2A')
        res = res.replace('%7E', '~')
        return str(res)

    #筛选出链接下载二进制日志文件
    def getBinLog(self):
        binlog_url = self.signed()
        req = urllib.request.urlopen(binlog_url)
        req = req.read().decode('utf8')
        res = json.loads(req)

        for i in res['Items']['BinLogFile']:
            wget.download(i['DownloadLink'])




s = RDS_BINLOG_RELATE()
s.getBinLog()


#9.下载服务器上的日志文件到本地
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-14 10:10
# @Author  : opsonly
# @Site    : 
# @File    : serverDownload.py
# @Software: PyCharm
import paramiko
import time


id_rsa = paramiko.RSAKey.from_private_key_file('/Users/opsonly/.ssh/id_rsa')
endtime = time.strftime("%Y-%m-%d_%H:%M:%S", time.gmtime())


ip_list = {
....#添加服务器，'hostname': 'ip',
}


# 获取lavavel项目日志
def lavael_log():

    la_remote_dir = sftp.listdir('/var/www/html/')
    for i in la_remote_dir:
        print(i,end=' ')
    print('\n')
    la_obj = input('选择项目：')
    date = input('请输入日期')

    remote_file = '/var/www/html/' + la_obj + '/storage/logs/laravel-2018-' + date + '.log'
    return remote_file

# 获取nginx访问日志
def nginx_log():
    ng_remote_dir = sftp.listdir('/data/log/')
    for i in ng_remote_dir:
        print(i,end=' ')
    ng_obj = input('选择项目：')
    ng_remote_file = '/data/log/' + ng_obj + '/access.log'
    return ng_remote_file

#选择需要连接的服务器




#遍历服务器列表
def server_list():
    for k in ip_list:
        print(k,end=' ')

    print('\n')

inType = input('laravel或nginx：')
php_localFile = 'laravel' + endtime
ng_localFile = 'nginx' + endtime


server_list()

server = input('请选择要连接的server：')
scp = paramiko.Transport((ip_list[server], 23548))
scp.connect(username='ucar', pkey=id_rsa)


sftp = paramiko.SFTPClient.from_transport(scp)


if inType == 'laravel':
    try:
        remote_file = lavael_log()

        sftp.get(remote_file, php_localFile)

        print('下载成功...')
    except:
        print('下载失败，文件不存在')

else:
    try:
        remote_file = nginx_log()
        sftp.get(remote_file, ng_localFile)
        print('下载成功...')
    except:
        print('下载失败，文件不存在')

scp.close()
print('连接断开....')




