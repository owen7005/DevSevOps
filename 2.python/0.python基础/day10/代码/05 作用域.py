"""
作用域的分类：
    1、全局作用域
        全局可以调用的名字就存在于全局作用域

        内置名称空间+全局名称空间
    2、局部作用域
        局部可以调用的名字就存放与局部作用域
        局部名称空间

global:声明全局变量（***）
nonlocal:在局部名称空间声明局部变量,在局部修改上层函数的变量（*）

只有可变类型可以在局部修改外部变量的值 （*****）
"""


# x = 1
#
# def index():
#     global x
#     x = 2
# index()
#
# print(x)


# 在局部修改外部函数的变量
# x = 1111
#
#
# def index():
#     x = 1
#
#     def func2():
#         x = 2
#
#         def func():
#             nonlocal x
#             x = 3
#
#         func()
#         print(x)
#
#     func2()
#     print(x)
#
#
# index()
# print(x)

# l1 = []
# def index(a):
#     l1.append(a)
#     # print(l1)
# index(1)
#
# print(l1)

# 局部变量的修改无法影响上层，上上层

def index():
    x = 1

    def index2():
        nonlocal x
        x = 2

    index2()
    print(x)


index()
