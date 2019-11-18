# ========================集合基本方法===========================
# 用途: 去重、关系运算
# 定义方式: 通过大括号存储数据，每个元素通过逗号分隔
# 定义空集合，必须使用set()来定义
# l1 = []
# s1 = ""
# d1 = {}
# ss1 = set()
# 常用方法:

"""
合集：|
交集：&
差集：-
对称差集：^
"""

"""
1、集合中不可能出现两个相同的元素
"""

python_student = {'egon', 'jason', 'tank', 'owen', 'egon'}
linux_student = {'frank', 'alex', 'egon'}
go_student = {'egon'}

print(python_student)
# print(python_student | linux_student)
# print(python_student & linux_student)
# print(python_student - linux_student)
# print(linux_student - python_student)
# print(python_student ^ linux_student)
# print(python_student > go_student)
# print(python_student < linux_student)

# l1 = [1, 2, 3, 1, 2, 9, 1, 5, 6, 7]
# print(l1)
#
# s1 = set(l1)
# print(s1)
# print(type(s1))
# l2 = list(s1)
# print(l2)
# print(type(l2))

for i in python_student:
    print(i)

# =========================类型总结==========================
# 有序or无序 : 无序
# 可变or不可变 : 不可变
# 存一个值or存多个值 ： 存多个值
