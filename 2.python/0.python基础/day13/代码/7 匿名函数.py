'''
匿名函数:
    无名字的函数
    # :左边是参数， 右边是返回值
    lambda :

    PS: 原因,因为没有名字，函数的调用  函数名 + ()
    匿名函数需要一次性使用。
    注意: 匿名函数单独使用毫无意义，它必须配合 “内置函数” 一起使用的才有意义。



有名函数:
    有名字的函数
'''

# 有名函数
def func():
    return 1
print(func())  # func函数对象 + ()
print(func())


# 匿名函数:
# def  ():
#     pass
#
# ()  #  + ()

# 匿名()， return 已经自动添加了
# lambda 匿名(): return 1
# func = lambda : 1
# print(func())
# func = lambda : 1
# print()

