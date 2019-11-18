'''
编写装饰器，为多个函数加上认证的功能（用户的账号密码来源于文件），
要求登录成功一次，后续的函数都无需再输入用户名和密码。
'''
# 可变类型，无需通过global引用，可直接修改
user_info = {
    'user': None  # username
}

# 不可变类型，需要在函数内部使用global对其进行修改
user = None

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
    else:
        print('登录失败!')


def login_auth(func):  # func ---> func1, func2, func3
    def inner(*args, **kwargs):
        # 已经登录，将被装饰对象直接调用并返回
        if user_info.get('user'):
            res = func(*args, **kwargs)  # func() ---> func1(), func2(), func3v
            return res

        # 若没登录，执行登录功能
        else:
            print('请先登录...')
            login()

    return inner


# func1,2,3 都需要先登录才可以使用，若登录一次，
# 后续功能无需再次登录，绕过登录认证
@login_auth
def func1():
    print('from func1')
    pass


@login_auth
def func2():
    print('from func2')
    pass


@login_auth
def func3():
    print('from func3')
    pass


while True:
    func1()
    input('延迟操作...')
    func2()
    func3()

