"""
1、什么是函数
    函数就是一种工具。
    可以重复调用

2、为什么要用函数
    1、防止代码冗（rong）余
    2、代码的可读性差

3、怎么用函数

    1、定义函数-->制造工具
    2、调用函数-->使用工具


    1、无参函数：
        def index():
            print('ok')
    2、空函数：
        def login():
            pass
    3、有参函数：
        def login(username):
            print(username)

    返回值：
        1、不写return：默认返回None
        2、只写return：只有结束函数体代码的效果，返回None
        3、写return None ：与只写return的效果相同
        4、return返回一个值: 可以将返回的结果，当做一个变量值来使用
        5、return返回多个值:
            1、将返回的多个值，默认存入元组返回
            2、函数的返回值不想被修改
            3、可以自己指定返回的数据类型
    函数的参数：
        参数的类型：
            形参：定义阶段
            实参：调用阶段---注释：当前函数具体功能--解释当前参数作用，--函数题代码---返回值return

        传参方式：
            位置参数
            关键字参数
            默认参数

        可变长参数：
            *args：接收所有溢出的位置参数
            **kwargs：接收所有溢出的关键字参数
            *：放到实参中就是打散
"""

# name = input(">>>")
# pwd = input(">>>")
# if name == 'sean' and pwd == 123:
#     print('success')


"""
函数名的命名规范与变量名一样

关键字(def)  函数名(index) 括号:
    函数描述：描述函数体代码的功能
"""


# def index():
#     """
#     from index
#     :return:
#     """
#     print('hello world')


# def login():
#     """
#     登录
#     :return:
#     """
#     pass
#
#
# def register():
#     """
#     注册
#     :return:
#     """
#     pass

# username = 'keejan'
# # password = '123'
# # def login(username,password):
# #     print(username,password)
# #
# # login(username,password)


# def index(a, b):
#     if a > b:
#         return a
#     else:
#         return b
#     # print('hello world')
#
#
# print(index(1, index(2, 3)))# f = index
# f()
