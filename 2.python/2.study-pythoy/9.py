#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : owen.zhang
# @Site    :Python3 字典
# @File    : opsUse.py
# @Software: PyCharm
# !/usr/bin/python3
dict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}
print("dict['Name']: ", dict['Name'])
print("dict['Age']: ", dict['Age'])

#修改字典
# !/usr/bin/python3
dict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}
dict['Age'] = 8  # 更新 Age
dict['School'] = "菜鸟教程"  # 添加信息
print("dict['Age']: ", dict['Age'])
print("dict['School']: ", dict['School'])

#删除字典元素
# !/usr/bin/python3
dict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}
del dict['Name']  # 删除键 'Name'
dict.clear()  # 清空字典
del dict  # 删除字典
print("dict['Age']: ", dict['Age'])
print("dict['School']: ", dict['School'])