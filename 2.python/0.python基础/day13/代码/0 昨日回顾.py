# def wrapper1(func):
#     def inner1(*args, **kwargs):
#         print('1---start')
#         # 被裝飾對象在調用時,如果還有其他裝飾器,會先執行其他裝飾器中的inner
#         # inner2
#         res = func(*args, **kwargs)
#         print('1---end')
#         return res
#     return inner1
#
#
# def wrapper2(func):  # inner3
#     def inner2(*args, **kwargs):
#         print('2---start')
#         res = func(*args, **kwargs)  # inner3()
#         print('2---end')
#         return res
#
#     return inner2
#
#
# def wrapper3(func):  # index
#     def inner3(*args, **kwargs):
#         print('3---start')
#         res = func(*args, **kwargs)  # index()
#         print('3---end')
#         return res
#
#     return inner3
#
#
# '''
# 叠加裝飾器的裝飾順序與執行順序:
#     - 裝飾順序: 调用wrapper装饰器拿到返回值inner
#         由下往上裝飾
#
#     - 執行順序: 调用装饰过后的返回值inner
#         由上往下執行
# '''
#
#
# @wrapper1  # index《---inner1 = wrapper1(inner2)
# @wrapper2  # inner2 = wrapper2(inner3)
# @wrapper3  # inner3 = wrapper3(index)
# def index():  # 被裝飾對象   # inner1 ---》
#     print('from index...')
#
#
# # 正在装饰
# # inner3 = wrapper3(index)
# # inner2 = wrapper2(inner3)
# # inner1 = wrapper1(inner2)
#
# '''
# inner1()
# inner2()
# inner3()
# index()
# '''
# index()  # 此处执行 # inner1() --> inner2() ---> inner3()





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
# wrapper = user_auth('普通用户')
# @wrapper

# @user_auth('SVIP')  # wrapper = user_auth('普通用户')
# def index():
#     pass
# index()


# list1 = [1, 2, 3]
# iter_list = list1.__iter__()
# print(len(iter_list))