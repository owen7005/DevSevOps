'''
思想！！！
面向过程编程是一门编程思想。

面向 过程 编程:
    核心是 '过程' 二字，过程 指的是一种解决问题的步骤，即先干什么再干什么
    基于该编程思想编写程序，就好比在设计一条工厂流水线，一种机械式的思维方式。

    优点:
        将复杂的问题流程化，进而简单化

    缺点:
        若修改当前程序设计的某一部分， 会导致其他部分同时需要修改， 扩展性差。

        牵一发而动全身，扩展性差。
'''


# # 1.先让用户输入用户名和密码，校验合法性
# def get_user_pwd():
#     while True:
#         # 让用户输入用户名与密码
#         username = input('请输入用户名:').strip()
#         # 校验用户名是否为 英文字母  str.isalpha 校验英文字母、中文
#         if username.isalpha():
#             break
#         else:
#             print('用户名不合法')
#
#     while True:
#         password = input('请输入密码:').strip()
#         re_password = input('请确认密码:').strip()
#         # 校验两次密码是否一致
#         if password == re_password:
#             break
#         else:
#             print('两次密码不一致。')
#
#     return username, password
#
#
# # 2.拼接用户字符串
# def cut_user_pwd(user, pwd):
#     user_pwd_str = f'{user}:{pwd}\n'
#     return user_pwd_str
#
#
# # 3.保存用户数据，写入文件中
# def save_data(user_pwd_str):
#     with open('user.txt', 'a', encoding='utf-8') as f:
#         f.write(user_pwd_str)
#
#
# # 注册功能Demo
# def register():
#     # 1.设计先让用户输入用户名和密码，校验合法性，得到合法的用户名与密码
#     user, pwd = get_user_pwd()
#
#     # 2.设计字符串的拼接, 得到拼接好的字符串
#     user_pwd_str = cut_user_pwd(user, pwd)
#
#     # 3.开始写入文件
#     save_data(user_pwd_str)
#
#
# register()


# 1.先让用户输入用户名和密码、用户角色，校验合法性
def get_user_pwd():
    while True:
        # 让用户输入用户名与密码
        username = input('请输入用户名:').strip()
        # 校验用户名是否为 英文字母  str.isalpha 校验英文字母、中文
        if username.isalpha():
            break
        else:
            print('用户名不合法')

    while True:
        password = input('请输入密码:').strip()
        re_password = input('请确认密码:').strip()
        # 校验两次密码是否一致
        if password == re_password:
            break
        else:
            print('两次密码不一致。')

    # 作业: 保证用户输入的角色范围 [普通用户、管理员用户、超级用户]
    user_role = input('请输入用户角色:').strip()

    return username, password, user_role


# 2.拼接用户字符串
def cut_user_pwd(user, pwd, user_role):
    user_pwd_str = f'{user}:{pwd}:{user_role}\n'
    return user_pwd_str, user


# user = 'tank'
# user_name = user

# 3.保存用户数据，写入文件中
# 每一个用户保存一个文件,以用户的名字当做文件名
def save_data(user_pwd_str, user_name):
    with open(f'{user_name}.txt', 'w', encoding='utf-8') as f:
        f.write(user_pwd_str)


# 注册功能Demo
def register():
    # 1.设计先让用户输入用户名和密码，校验合法性，得到合法的用户名与密码
    user, pwd, user_role = get_user_pwd()

    # 2.设计字符串的拼接, 得到拼接好的字符串
    user_pwd_str, user_name = cut_user_pwd(user, pwd, user_role)

    # 3.开始写入文件
    save_data(user_pwd_str, user_name)


register()
