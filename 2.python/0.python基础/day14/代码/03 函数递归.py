'''
函数递归:
    函数递归指的是重复 “直接调用或间接调用”  函数本身，
    这是一种函数嵌套调用的表现形式。

    直接调用: 指的是在函数内置，直接调用函数本身。
    间接调用: 两个函数之间相互调用间接造成递归。

    了解:
        面试可能会问:
            python中有递归默认深度: 限制递归次数
            998, 1000
            PS: 但是在每一台操作系统中都会根据硬盘来设置默认递归深度。

        获取递归深度: 了解
            sys.getrecursionlimit()

        设置递归深度: 了解
            sys.setrecursionlimit(深度值)


注意: 单纯的递归调用时没有任何意义的。

'''


# def func():
#     print('from func')
#     func()
#
# func()

# import sys  # 获取操作系统资源的模块
# print(sys.getrecursionlimit())
#
# sys.setrecursionlimit(2000)
#
# print(sys.getrecursionlimit())

# import sys
# sys.setrecursionlimit(2000)  # 了解
#
# # 查看当前可以承受的递归深度
# num = 1
# def func():
#     global num
#     print('from func', num)
#     num += 1
#     func()
#
# func()



# def foo():
#     print('from foo')
#     goo()
#
# def goo():
#     print('from goo')
#     foo()
#
# foo()








'''
想要递归有意义，必须遵循两个条件:
    - 回溯:
        指的是重复地执行, 每一次执行都要拿到一个更接近于结果的结果，
        回溯必要有一个终止条件。

    - 递推:
        当回溯找到一个终止条件后，开始一步一步往上递推。

    age5 == age4 + 2
    age4 == age3 + 2
    age3 == age2 + 2
    age2 == age1 + 2
    age1 == 18  # 回溯终止的结果

    # result = age(n - 1) + 2
'''

def age(n):
    if n == 1:
        return 18

    # 这里写return才能实现递推
    return age(n - 1) + 2

res = age(5)
print(res)  # 26
























