"""
模拟认证功能：
    1、接收用户的输入
    2、判断用户的输入解果
    3、返回数据
"""

# break :


# 限制登录次数，如果登录3次失败，锁定账户


from_db_username = 'sean'
from_db_password = '123'

# count = 0
#
#
# while count < 3:
#
#     username = input("please input your username>>:")
#     password = input("please input your password>>:")
#     if username == from_db_username and password == from_db_password:
#         print(username == from_db_username and password == from_db_password)
#         print('登录成功')
#         break
#     else:
#         print("登录失败")
#         count += 1
#
# if count == 3:
#     print('锁定账户')


# 登录认证的升级版
# count = 0
# while True:
#     username = input("please input your username>>:")
#     password = input("please input your password>>:")
#     if username == from_db_username and password == from_db_password:
#         print(username == from_db_username and password == from_db_password)
#         print('登录成功')
#         break
#     else:
#         print("登录失败")
#         count += 1
#     if count == 3:
#         print('锁定账户')
#         break


# count = 0
# while True:
#     print(count)
#     count+=1

# continue：跳过本次循环，执行下一次循环
# continue下面不管有多少行代码，都不会执行

# break:结束本层循环，单纯指代当前while
# 只能结束一层循环

# 打印1~10
# 不打印7
# 遇到8，结束循环

# count = 0
# while count < 10:
#     count += 1
#     print(f"第{count}次")
#     if count == 7:
#         continue
#     if count == 8:
#         break
#
#     print(count)


# len()
# s1 = 'hello'
# print(len(s1))  # 获取字符串字符的个数
# l1 = [1, 2, 3, 4, 5, 6, 7]
# print(len(l1))

# info = {"name":"sean",'age':18}
# print(len(info))


# l1 = [1, 2, 3, 4, 5, 6, 7]
#
# count = 0
# while count<len(l1):
#     print(l1[count])
#     count += 1


# while + else
# 当你的while正常执行结束，就会执行else下面的代码块
# 如果不正常结束，类似于被break打断，就不会执行

count = 0
while count<10:
    print(count)
    count += 1
    if count == 5:
        continue
else:
    print("执行成功")