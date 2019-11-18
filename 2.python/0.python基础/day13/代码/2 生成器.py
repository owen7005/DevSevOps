'''
1.什么是生成器？
    生成的工具。
    生成器是一个 "自定义" 的迭代器， 本质上是一个迭代器。

2.如何实现生成器
    但凡在函数内部定义了的yield，
    调用函数时，函数体代码不会执行，
    会返回一个结果，该结果就是一个生成器。

yield:
    每一次yield都会往生成器对象中添加一个值。
    - yield只能在函数内部定义
    - yield可以保存函数的暂停状态


yield与return:
    相同点:
        返回值的个数都是无限制的。

    不同点:
        return只能返回一次值，yield可以返回多个值

'''

# # 可迭代对象
# list1 = [1, 2, 3.....]
#
# # 迭代器对象  python内置生成的迭代器
# iter_list = list1.__iter__()


# # 自定义的迭代器
# def func():
#     print('from func')
#     yield 'tank'
#
#
# res = func()
# # 当我们通过__next__取值时，才会执行函数体代码。
# print(res.__next__())

# 自定义的迭代器
# def func():
#     print('开始准备下蛋')
#     print('1---火鸡蛋1')
#     yield '火鸡蛋1'
#     print('2---火鸡蛋2')
#     yield '火鸡蛋2'
#     print('3---火鸡蛋3')
#     yield '火鸡蛋3'
#
#     print('取最后一个蛋，查看是否有')


# res是迭代器对象
# res = func()
# 当我们通过__next__取值时，才会执行函数体代码。
# next(迭代器对象)
# print(next(res))
# print(next(res))
# print(next(res))

# 迭代器对象.__next__()
# print(res.__next__())
# print(res.__next__())
# print(res.__next__())
# print(res.__next__())  # StopIteration报错



# 循环10次
# for i in range(1, 11):
# #     print(i)  # 1—10

# python2: range(1, 5) ---> [1, 2, 3, 4]
# python3: range(1, 5) ---> range对象 ---> 生成器 ---> 迭代器
# res = range(1, 5)
# print(res)


# 自定义range功能，创建一个自定义的生成器
# (1, 3)  # start--> 1  , end---> 5, move=2
def my_range(start, end, move=1):  #
    while start < end:
        yield start
        start += move

# g_range = my_range(1, 5)
# print(g_range)
#
# for line in g_range:
#     print(line)


for line in my_range(1, 5, 2):
    print(line)