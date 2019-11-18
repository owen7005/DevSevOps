
# x = 10
# while True:
#     print(x)

#
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


dict1 = {'age': 17, 'name': 'tank'}
iter_dict1 = dict1.__iter__()

print(iter_dict1.__next__())
print(iter_dict1.__next__())
# print(iter_dict1.__next__())
