
# x = 10
# while True:
#     print(x)


# list1 = [1, 2, 3, 4]  # 1, 2, 3, 4
# n = 0
# while n < len(list1):
#     print(list1[n])
#     n += 1


# 以下都是可迭代对象
'''
str1 = 'hello tank!'
str1.__iter__()
list1 = [1, 2, 3]  # list([1, 2, 3])
list1.__iter__()
set.__iter__()
dict.__iter__()
tuple.__iter__()
open('a.txt').__iter__()
'''


# str1 = '靓仔靓女'

# iter_str1 = str1.__iter__()
# print(iter_str1)  # iterator指的是迭代器对象   # iter_str1 ---> python13期都是靓仔，靓女！
# print(iter_str1.__next__())
# print(iter_str1.__next__())
# print(iter_str1.__next__())
# print(iter_str1.__next__())

# 因为迭代器中的值已经取完了
# print(iter_str1.__next__())  # 报错，StopIteration


# dict1 = {'age': 17, 'name': 'tank'}
# iter_dict1 = dict1.__iter__()
#
# print(iter_dict1.__next__())
# print(iter_dict1.__next__())
# print(iter_dict1.__next__())


# # list1是一个可迭代对象
# list1 = ['tank', 'jason鸡哥', 'sean', '饼哥']
#
# # 获取迭代器对象： iter_list1
# iter_list1 = list1.__iter__()
#
# while True:
#     # 补充: try: 捕获异常
#     try:
#         print(iter_list1.__next__())  # 报错
#
#     # 立即触发此处代码 StopIteration
#     except StopIteration:
#         break


# 依赖于索引取值
# list1 = [1, 2, 3, 4]  # 1, 2, 3, 4
# n = 0
# while n < len(list1):
#     print(list1[n])
#     n += 1


# 不依赖索引的取值方式
# tuple1 = ('tank', 'jason鸡哥', 'sean', '饼哥')
#
# # 获取迭代器对象： iter_list1
# iter_tuple1 = tuple1.__iter__()
#
# while True:
#     # 补充: try: 捕获异常
#     try:
#         print(iter_tuple1.__next__())  # 报错
#
#     # 立即触发此处代码 StopIteration
#     except StopIteration:
#         break


# list1 = [1, 2, 3, 4]
#
# for line in list1:  # list1是可迭代对象 ----> 内部会自动调用.__iter__() ---> 迭代器对象
#     # 迭代器对象.__next__()
#     print(line)


# 测试迭代文件
# f = open('user.txt', 'r', encoding='utf-8')
# iter_f = f.__iter__()
#
# while True:
#     try:
#         print(iter_f.__next__())
#
#     except StopIteration:
#
#         break


# str1 = 'hello tank'
# 先获取迭代器对象
# iter_str1 = str1.__iter__()
#
# while True:
#     try:
#         print(iter_str1.__next__())
#
#     except StopIteration:
#         break




# set1 = {1, 2, 3, 4}
# set1 = (1, 2, 3, 4)
# set1 = [1, 2, 3, 4]
set1 = '1, 2, 3, 4'

# iter_set1: 迭代器对象
iter_set1 = set1.__iter__()
iter_set1.__next__()

# 确定: 迭代器对象也是一个可迭代对象
# 判断可迭代对象是否是迭代器对象
# print(iter_set1.__iter__() is iter_set1)  # True

# 唯独文件比较特殊: 因为文件从读取出来的时候就是一个迭代器对象
# f ---> 可迭代对象， 还是迭代器对象
# f = open('user.txt', 'r', encoding='utf-8')
# # 确定: 文件既是可迭代对象，也是迭代器对象。
# # iter_f ---> 迭代器对象
# iter_f = f.__iter__()
# print(iter_f is f)  # True


# 可迭代对象
list1 = [1, 2, 3, 4]

# iter_list1 ---> 迭代器对象
iter_list1 = list1.__iter__()
print(iter_list1 is list1)  # False
# 可迭代对象不一定是迭代器对象
