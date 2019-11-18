"""
1、不写return：默认返回None
2、只写return：只有结束函数体代码的效果，返回None
3、写return None ：与只写return的效果相同
4、return返回一个值: 可以将返回的结果，当做一个变量值来使用
5、return返回多个值:
    1、将返回的多个值，默认存入元组返回
    2、函数的返回值不想被修改
    3、可以自己指定返回的数据类型
return:它是一个函数结束的标志，函数体代码只要执行到return，函数执行结束
"""


# def index():
#     print('hello world')
#     return None
#
# print(index())

# len()
# s1 = "hello world"
# #
# l1 = [1, 6, 3, 4, 5, 6]
# #
# #
# def my_len():
#     count = 0
#     while True:
#         for i in l1:
#             if i == 4:
#                 print(count)
#                 return
#             count += 1
#
#
# print(my_len())

# def func():
#
#     for i in range()


# def home():
#
#     if a > b:
#         return a
#     else:
#         return b
#
#
# res = home()
# print(res)

# a = 1
# b = 2
# c = '3'
# d = [4, 5]
# e = {'name': 'sean'}


# def func(a, b, c, d, e):
#     return a, b, c, d, e
#
#
# print(func(a, b, c, d, e))

def func1():
    return 1, "2"


print(func1())
