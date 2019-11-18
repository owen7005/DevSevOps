"""
名称空间的查找顺序:
    局部：局部 > 全局 > 内置
    全局：全局 > 内置  # 内置再找不到就报错
# 函数内部使用的名字，在定义阶段已经规定死了，与你的调用位置无关



"""
# x = 111
# def func1():
#     x = 222
#     def func2():
#         x = 333
#         def func3():
#             # x = 444
#             def func4():
#                 # x = 555
#                 print(x)
#                 print('from func4')
#             func4()
#
#         func3()
#     func2()
# func1()

# x = 1
#
# def wrapper():
#     x = 2
#     index()
#
# def index():
#     x = 3
#     print(x)
#
# wrapper()


# x = 1
# def inner():
#     # x = 2
#     def wrapper():
#         print(x)
#     wrapper()
#
# inner()
# x = 111





# def index():
#     x = 2
#     # print(x)
#
# print(x)

# x = 1
#
# def index(arg = x):
#     print(x)
#     print(arg)
#
# x = 2
# index()


x = 111
def index():
    def wrapper():
        print(x)

    return wrapper
    # return wrapper

index()
# x = 222
# f = index()
# f()