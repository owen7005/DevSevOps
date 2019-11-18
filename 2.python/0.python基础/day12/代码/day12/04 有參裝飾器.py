
# 无参装饰器: 装饰在被装饰对象时，没有传参数的装饰器。
'''
# 以下是无参装饰器
@wrapper1  # inner1 = wrapper1(inner2)
@wrapper2  # inner2 = wrapper2(inner3)
@wrapper3
'''

# 有参装饰器: 在某些时候，我们需要给用户的权限进行分类
'''
# 以下是有参装饰器
@wrapper1(参数1)  # inner1 = wrapper1(inner2)
@wrapper2(参数2)  # inner2 = wrapper2(inner3)
@wrapper3(参数3)
'''


# 有参装饰器
def user_auth(user_role):  # 'SVIP'
    def wrapper(func):
        def inner(*args, **kwargs):
            if user_role == 'SVIP':
                # 添加超级用户的功能
                res = func(*args, **kwargs)
                return res
            elif user_role == '普通用户':
                print('普通用户')
                # 添加普通用户的功能
                res = func(*args, **kwargs)
                return res

        return inner
    return wrapper


# 被装饰对象
# @user_auth('SVIP')
wrapper = user_auth('普通用户')
@wrapper
# @user_auth('SVIP')  # wrapper = user_auth('普通用户')
@wrapper  #<--- 返回结果(wrapper) <---- user_auth()
def index():
    pass
index()

