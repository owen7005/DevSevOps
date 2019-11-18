'''
在python的三种时间表现形式:
    1.时间戳: 给电脑看的。
        - 自1970-01-01 00:00:00到当前时间，按秒计算，计算了多少秒。

    2.格式化时间（Format String）: 给人看的
        - 返回的是时间的字符串 2002-01-11

    3.格式化时间对象(struct_time):
        - 返回的是一个元组, 元组中有9个值:
            9个值分别代表: 年、月、日、时、分、秒、一周中第几天，一年中的第几天，夏令时（了解）

时间模块
'''
import time

# 1.获取时间戳（******）计算时间时使用
# print(time.time())  （******）

'''
%Y  Year with century as a decimal number.
%m  Month as a decimal number [01,12].
%d  Day of the month as a decimal number [01,31].
%H  Hour (24-hour clock) as a decimal number [00,23].
%M  Minute as a decimal number [00,59].
%S  Second as a decimal number [00,61].
'''
# 2.获取格式化时间 （*******）拼接用户时间格式并保存时使用
# 获取年月日
# print(time.strftime('%Y-%m-%d'))

# 获取年月日时分秒
print(time.strftime('%Y-%m-%d %H:%M:%S'))
# %X == %H:%M:%S
print(time.strftime('%Y-%m-%d %X'))

# 获取年月
# print(time.strftime('%Y/%m'))


# 3.获取时间对象 （****）
# print(time.localtime())
# print(type(time.localtime()))
# time_obj = time.localtime()
# print(time_obj.tm_year)
# print(time_obj.tm_year)
# print(time_obj.tm_mon)


# res = time.localtime()
# time.sleep(5)

# 获取当前时间的格式化时间
# print(time.strftime('%Y-%m-%d %H:%M:%S', time.localtime()))
#
# # 将时间对象转为格式化时间
# print(time.strftime('%Y-%m-%d %H:%M:%S', res))


# 将字符串格式的时间转为时间对象
# res = time.strptime('2019-01-01', '%Y-%m-%d')
# print(res)


