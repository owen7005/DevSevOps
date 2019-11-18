"""
可变长参数：
    *args:接收所有溢出的位置参数
        接收的值都被存入一个元组
    官方认证：*args
    只要有*就有可变长参数的效果

    *:打散你传入容器类型

    **kwargs:接收所有溢出的关键字参数
        接收的值都被存入一个字典

    官方认证：**kwargs
"""


# def index(a, b, c,d,e):
#     print(a, b, c,d,e)
#
#
# index(1, 2, *(3, 4, 5))
# a = 1
# b = 2
# c = 3
# d = 4
#  = 5
#  = 6

# def func(a, b, c, d,**kw):
#     print(a, b, c, d,kw)
#
#
# func(1, 2, c=3, d=4, e=5, f=6)

# l1 = [1,2,3,4]
# t1 = (1,2,3,4)
# d1 = {'name':'tank','age':73}
#
# print(*l1)
# print(*t1)
# print(d1)


def foo(a, b, c, d, e, f):
    print(a, b, c, d, e, f)


def bar(*args, **kwargs):
    foo(*args, **kwargs)


bar(1, 2, 3, d=10, e=20, f=30)
