#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : owen.zhang
# @Site    : 基础语法
# @File    : opsUse.py
# @Software: PyCharm
# 第一个注释
print ("Hello, Python!") # 第二个注释

# 第二个注释

'''
第三注释
第四注释
'''
print ("Hello, Python!")
#用缩进来表示代码块，缩进的空格数是可变的，但是同一个代码块的语句必须包含相同的缩进空格数

if True:
    print ("True")
else:
    print ("False")

#多行语句
total = ['item_one', 'item_two', 'item_three',
        'item_four', 'item_five']

#数字(Number)类型
int (整数), 如 1, 只有一种整数类型 int，表示为长整型，没有 python2 中的 Long。
bool (布尔), 如 True。
float (浮点数), 如 1.23、3E-2
complex (复数), 如 1 + 2j、 1.1 + 2.2j

#等待用户输入
input("\n\n按下 enter 键后退出。")

#Print 输出
x = "a"
y = "b"
# 换行输出
print(x)
print(y)

print('---------')
# 不换行输出
print(x, end=" ")
print(y, end=" ")
print()

#import 与 from...import
#在 python 用 import 或者 from...import 来导入相应的模块。
#将整个模块(somemodule)导入，格式为： import somemodule
#从某个模块中导入某个函数,格式为： from somemodule import somefunction
#从某个模块中导入多个函数,格式为： from somemodule import firstfunc, secondfunc, thirdfunc
#将某个模块中的全部函数导入，格式为： from somemodule import *


#导入sys模块
import sys

print('================Python import mode==========================');
print('命令行参数为:')
for i in sys.argv:
    print(i)
print('\n python 路径为', sys.path)

#导入
#sys#模块的argv, path成员
from sys import argv, path  # 导入特定的成员

print('================python from import===================================')
print('path:', path)  # 因为已经导入path成员，所以此处引用时不需要加sys.path