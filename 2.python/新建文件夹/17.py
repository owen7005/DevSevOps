#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : owen.zhang
# @Site    :
# @File    : opsUse.py
# @Software: PyCharm

import mysql.connector

mydb = mysql.connector.connect(
    host="192.168.126.128",  # 数据库主机地址
    user="root",  # 数据库用户名
    passwd="123456"  # 数据库密码
)

mycursor = mydb.cursor()

mycursor.execute("CREATE TABLE sites (name VARCHAR(255), url VARCHAR(255))")