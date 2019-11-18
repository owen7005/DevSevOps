"""
如果：成绩>=90，那么：优秀

如果成绩>=80且<90,那么：良好

如果成绩>=70且<80,那么：普通
"""

# score = input("please input your score>>>:")
# score = int(score)
# if score >= 90:
#     print('优秀')
# elif score >= 80:
#     print("良好")
# elif score >= 70:
#     print('普通')
# else:
#     print("不合格")


"""
如果：
    周一：工作
    周二：工作
    周三：工作
    周四：工作
    周五：工作
    周六：出去耍
    周日：出去耍
"""
#
# inp = input(">>>:")
#
#
# l1 = ['周一','周二','周三','周四','周五']
# l2 = ['周六','周日']

# if inp == '周一':
#     print('工作')
# elif inp == '周二':
#     print('工作')
# elif inp == '周三':
#     print('工作')
# elif inp == '周四':
#     print('工作')
# elif inp == '周五':
#     print('工作')
# elif inp == '周六':
#     print('出去耍')
# elif inp == '周日':
#     print("出去耍")

# 优化：
# if inp in l1:
#     print('工作')
# elif inp in l2:
#     print('出去耍')
# else:
#     print("你tmd能不能好好输")


"""
模拟认证功能：
    1、接收用户的输入
    2、判断用户的输入解果
    3、返回数据
"""
from_db_username = 'sean'
from_db_password = '123'

username = input("please input your username>>:")
password = input("please input your password>>:")

if username == from_db_username and password == from_db_password:
    print(username == from_db_username and password == from_db_password)
    print('登录成功')
else:
    print("登录失败")





