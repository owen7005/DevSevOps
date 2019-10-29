#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : owen.zhang
# @Site    :
# @File    : opsUse.py
# @Software: PyCharm
import time;  # 引入time模块
import calendar
ticks = time.time()
print ("当前时间戳为:", ticks)
localtime = time.localtime(time.time())
print ("本地时间为 :", localtime)
localtime = time.asctime( time.localtime(time.time()) )
print ("本地时间为 :", localtime)
cal = calendar.month(2016, 1)
print ("以下输出2016年1月份的日历:")
print (cal)