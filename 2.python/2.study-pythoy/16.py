#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : owen.zhang
# @Site    :Python3 输入和输出
# @File    : opsUse.py
# @Software: PyCharm
#!/usr/bin/python3

str = input("请输入：");
print ("你输入的内容是: ", str)

##f.read()
# 打开一个文件
f = open("/tmp/foo.txt", "r")
str = f.read()
print(str)
# 关闭打开的文件
f.close()

#f.readline()
# 打开一个文件
f = open("/tmp/foo.txt", "r")
str = f.readline()
print(str)
# 关闭打开的文件
f.close()


#
#f.readlines()
#!/usr/bin/python3

# 打开一个文件
f = open("/tmp/foo.txt", "r")
str = f.readlines()
print(str)
# 关闭打开的文件
f.close()

!/usr/bin/python3

# 打开一个文件
f = open("/tmp/foo.txt", "w")

num = f.write( "Python 是一个非常好的语言。\n是的，的确非常好!!\n" )
print(num)
# 关闭打开的文件
f.close()