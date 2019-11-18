'''
内置函数:
    range()
    print()
    len()

    # python内部提供的内置方法
    max, min, sorted, map, filter
    sorted: 对可迭代对象进行排序
'''
# max求最大值   max(可迭代对象)
# list1 = [1, 2, 3, 4, 5]

# max内部会将list1中的通过for取出每一个值，并且进行判断
# print(max(list1))  #

# dict1 = {
#     'tank': 1000,
#     'egon': 500,
#     'sean': 200,
#     'jason': 500
# }

# 获取dict1中薪资最大的人的名字
# 字符串的比较: ASCII
# print(max(dict1, key=lambda x: dict1[x]))


# 获取dict1中薪资最小的人的名字
# print(min(dict1, key=lambda x:dict1[x]))


# sorted: 默认升序（从小到大） reverse:反转 reverse默认是False
# list1 = [10, 2, 3, 4, 5]
# print(sorted(list1))
# # reverse=True--> 降序
# print(sorted(list1, reverse=True))

dict1 = {
    'tank': 100,
    'egon': 500,
    'sean': 200,
    'jason': 50
}
# new_list = ['egon', 'sean', 'tank', 'jason']
new_list = sorted(dict1, key=lambda x: dict1[x], reverse=True)
print(new_list)
