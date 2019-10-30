# -*- coding: UTF-8 -*-
import calendar

year = int(input("请输入年份："))
check_year=calendar.isleap(year)
if check_year == True:
    print ("闰年")
else:
    print ("平年")