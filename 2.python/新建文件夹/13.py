#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : owen.zhang
# @Site    :Python3 函数
# @File    : opsUse.py
# @Software: PyCharm
# !/usr/bin/python3

# 计算面积函数
def area(width, height):
    return width * height


def print_welcome(name):
    print("Welcome", name)


print_welcome("Runoob")
w = 4
h = 5
print("width =", w, " height =", h, " area =", area(w, h))

##########函数调用
# !/usr/bin/python3

# 定义函数
def printme(str):
    # 打印任何传入的字符串
    print(str)
    return


# 调用函数
printme("我要调用用户自定义函数!")
printme("再次调用同一函数")

#匿名函数
# !/usr/bin/python3

# 可写函数说明
sum = lambda arg1, arg2: arg1 + arg2
# 调用sum函数
print("相加后的值为 : ", sum(10, 20))
print("相加后的值为 : ", sum(20, 20))