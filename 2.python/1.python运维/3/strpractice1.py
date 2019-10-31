# -*- coding:utf-8 -*-

import time

time01 = time.time()   # 起始时刻
a = " "
for i in range(10000000):
    a += "sxt"

time02 = time.time() # 终止时刻

print("运算时间:" + str(time02-time01))

time03 = time.time()  # 起始时刻
li = []
for i in range(10000000):
    li.append("sxt")

a = " ".join(li)

time04 = time.time()  # 终止时刻
print("运算时间:" + str(time04-time03))
