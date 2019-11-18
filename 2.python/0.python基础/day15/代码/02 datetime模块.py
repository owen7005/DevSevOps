import datetime

# 获取当前年月日
# print(datetime.date.today()) (*******)
#
# # 获取当前年月日时分秒
# print(datetime.datetime.today()) (*******)
#
# time_obj = datetime.datetime.today()
# print(type(time_obj))
# print(time_obj.year)
# print(time_obj.month)
# print(time_obj.day)
#
# # 从索引0开始计算周一
# UTC
# print(time_obj.weekday())  # 0-6
# ISO
# print(time_obj.isoweekday())  # 1-7

# UTC时区
# 北京时间
# print(datetime.datetime.now()) (*******)
# 格林威治
# print(datetime.datetime.utcnow())


'''
日期/时间的计算 (*******)
    日期时间 = 日期时间 “+” or “-” 时间对象
    时间对象 = 日期时间 “+” or “-” 日期时间
'''
# 日期时间:
current_time = datetime.datetime.now()
print(current_time)

# 时间对象
# 获取7天时间
time_obj = datetime.timedelta(days=7)
print(time_obj)

# 获取当前时间7天后的时间
# 日期时间 = 日期时间 “+” or “-” 时间对象
later_time = current_time + time_obj
print(later_time)

# 时间对象 = 日期时间 “+” or “-” 日期时间
time_new_obj = later_time - current_time
print(time_new_obj)


