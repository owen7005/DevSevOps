'''
列表生成式:
    可以一行实现生成列表。
    语法:
        list = [取出的每一个值、任意值 for 可迭代对象中取出的每一个值 in 可迭代对象]
        # for的右边是循环次数，并且可以取出可迭代对象中每一个值
        # for的左边可以为当前列表添加值
        list = [值 for 可迭代对象中取出的每一个值 in 可迭代对象]

        list = [值 for 可迭代对象中取出的每一个值 in 可迭代对象 if 判断]
'''

# 将list1中的值，依次取出，添加到new_list中
# list1 = [1, 2, 3, 4]
# new_list = []
# for line in list1:
#     new_list.append(line)
#
# print(new_list)


# 普通方式
# new_list = []
# for line in range(1, 101):
#     new_list.append(line)
# print(new_list)

# 列表生成式
# list1 = [f'1{line}' for line in range(1, 101)]
# print(list1)


# Demo: 将name_list列表中的每一个人后缀都添加_dsb
# name_list = ['jason', '饼哥(大脸)', 'sean', 'egon']
# new_name_list = [name + '_dsb' for name in name_list]
# print(new_name_list)


# 将name_list列表中的tank过滤掉，其他人后缀都添加_dsb
# name_list = ['jason', '饼哥(大脸)', 'sean', 'egon', 'tank']
# new_name_list = [name + '_dsb' for name in name_list if not name == 'tank']
# print(new_name_list)


# 只要思想不滑坡，方法总比问题多。
