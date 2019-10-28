"""
info: 转换centos下用户账号创建时间，过期时间，转换成可阅读时间（linux默认从1970年开始按天计算）
anthor: penpen
"""
import time
import sys

try:
    day = int(sys.argv[1])
except IndexError:
    print('请加入时间参数')
else:
    time_str = time.strftime('%Y-%m-%d', time.localtime(day*24*3600))
    print('转换后的日期为：', time_str)
