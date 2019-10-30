# -*- coding: UTF-8 -*-
# Python 判断奇数偶数
# 如果是偶数除于 2 余数为 0
# 如果余数为 1 则为奇数

num = int(input("输入一个数字: "))
if (num % 2) == 0:
    print("{0} 是偶数".format(num))
else:
    print("{0} 是奇数".format(num))