'''
叠加装饰器:
    在同一个被装饰对象中，添加多个装饰器，并执行。
    @装饰1
    @装饰2
    @装饰3
    def 被装饰对象():
        pass

    注意: 装饰器在调用被装饰对象时才会执行添加的功能。

    - 叠加装饰器:
        - 装饰的顺序: 由下到上装饰
        - 执行的顺序: 由上往下

    注意: 无论inner中出现任何判断，最后都要返回“调用后的被装饰对象” func(*args, **kwargs)

'''

# def wrapper(func):
#     def inner(*args, **kwargs):
#         # 注册
#         res = func(*args, **kwargs)
#         # 登录
#         return res
#
#     return inner


# 需求: 为被装饰对象，添加统计时间 与 登录认证功能
import time

user_info = {
    'user': None
}


# 登录功能
def login():
    # 判断用户没有登录时，执行
    # 登录功能
    # global user
    username = input('请输入账号: ').strip()
    password = input('请输入密码: ').strip()
    with open('user.txt', 'r', encoding='utf-8') as f:
        for line in f:
            print(line)
            name, pwd = line.strip('\n').split(':')  # [tank, 123]

    if username == name and password == pwd:
        print('登录成功!')
        user_info['user'] = username
        return True
    else:
        print('登录失败!')
        return False


# 登录认证装饰器
def login_auth(func):  # func---》 download_movie
    def inner1(*args, **kwargs):

        '''
        注意: 无论inner中出现任何判断，
        最后都要返回“调用后的被装饰对象” func(*args, **kwargs)
        '''

        # 登录认证
        if user_info.get('user'):
            # res = download_movie(*args, **kwargs)
            res = func(*args, **kwargs)
            return res

        else:
            flag = login()
            # 添加用户是否登录判断
            if flag:
                res = func(*args, **kwargs)
                return res

            else:

                login()
                return func(*args, **kwargs)

    return inner1


# 统计时间装饰器
def time_record(func):
    def inner2(*args, **kwargs):
        print('开始统计...')
        start_time = time.time()
        res = func(*args, **kwargs)
        end_time = time.time()
        print(f'消耗时间为: {end_time - start_time}')
        return res
    return inner2


# 下载电影功能
'''
    - 叠加装饰器:
        - 装饰的顺序: 由下到上装饰
        - 执行的顺序: 由上往下
'''
@time_record  # inner2 = time_record(inner1地址)
@login_auth  # inner1 = login_auth(download_movie)
def download_movie():
    print('正在下载电影...')
    time.sleep(2)
    print('下载电影完成...')
    return 'GTWZ.mp4'


# login()
# 执行的顺序： 先执行time_record功能，再执行login_auth功能
# 统计登录时间 + 下载时间
# download_movie()


# 装饰顺序
# @login_auth  # inner1 = login_auth(inner2)
# @time_record  # inner2 = time_record(download_movie)
# def download_movie():
#     print('正在下载电影...')
#     time.sleep(2)
#     print('下载电影完成...')
#     return 'GTWZ.mp4'


# 执行顺序:
# 先执行login_auth, 再执行time_record
# 只统计下载电影的时间
# login()  # 先调用登录，模拟用户已登录
download_movie()
