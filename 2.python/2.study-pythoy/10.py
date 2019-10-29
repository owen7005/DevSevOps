#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : owen.zhang
# @Site    :Python3 集合
# @File    : opsUse.py
# @Software: PyCharm
#1、添加元素
#语法格式如下：

#s.add( x )
#将元素 x 添加到集合 s 中，如果元素已存在，则不进行任何操作。
thisset = set(("Google", "Runoob", "Taobao"))
thisset.add("Facebook")
print(thisset)

#2、移除元素
s.remove( x )

#3、计算集合元素个数
len(s)

#4、清空集合
语法格式如下：
s.clear()