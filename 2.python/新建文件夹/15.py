#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : owen.zhang
# @Site    :Python3 模块
# @File    : opsUse.py
# @Software: PyCharm
# !/usr/bin/python3
# 文件名: using_sys.py

import sys

print('命令行参数如下:')
for i in sys.argv:
    print(i)

print('\n\nPython 路径为：', sys.path, '\n')

# 导入模块
import support

# 现在可以调用模块里包含的函数了
support.print_func("Runoob")
