"""
模拟认证功能：
    1、接收用户的输入
    2、判断用户的输入结果
    如果用三次输入失败，锁定账户
    如果用户登录成功：
        执行指令
    3、返回数据

"""
from_db_username = 'sean'
from_db_password = '123'
count = 0
tag = True
while tag:
    username = input("please input your username>>:")
    password = input("please input your password>>:")
    if username == from_db_username and password == from_db_password:
        print('登录成功')
        while tag:
            cmd = input(">>>:")
            if cmd == 'exit':
                tag = ''
            else:
                print(f"执行{cmd}指令")
    else:
        print("登录失败")
        count += 1
    if count == 3:
        print('锁定账户')
        tag = 0


while 1:
  print("ok")