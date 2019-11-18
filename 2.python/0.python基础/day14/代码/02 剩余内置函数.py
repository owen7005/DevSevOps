'''
map: 映射
    map(函数地址, 可迭代对象) ---> map对象
    map会将可迭代对象中的每一个值进行修改，然后映射一个map对象中，
    可以再将map对象转换成列表/元组。
    注意: 只能转一次。

reduce: 合并
    reduce(函数地址, 可迭代对象, 默认为0)
    reduce(函数地址, 可迭代对象, 初始值)

filter: 过滤
    filter(函数地址, 可迭代对象) --> filter 对象
'''
# def func():
#     pass
# map(func)
# 姓名列表
# name_list = ['egon', 'jason', 'sean', '大饼', 'tank']
# map_obj = map(lambda name: name + '喜欢吃生蚝' if name == 'tank' else name + 'DJB', name_list)
# print(map_obj)  # map_obj ---> list/tuple
# print(list(map_obj))  # map_obj ---> 生成器(迭代器) ---> 用完后，不能再取了
# print(tuple(map_obj))


# reduce
# from functools import reduce
# 每次从可迭代对象中获取两个值进行合并，
# 初始值: 执行reduce函数时，都是从初始值开始合并
# reduce(lambda x, y: x + y, range(1, 101), 0)

# 需求: 求1——100的和
# 普通
# init = 1000
# for line in range(1, 101):
#     init += line
#
# # print(init)  # 5050
# print(init)  # 6050

# reduce
# res = reduce(lambda x, y: x + y, range(1, 101), 1000)
# print(res)  # 6050


# filter
name_list = ['egon_dsb', 'jason_dsb',
             'sean_dsb', '大饼_dsb', 'tank']
# filter_obj = filter(lambda x: x, name_list)

# 将后缀为_dsb的名字 “过滤出来”
# filter会将函数中返回的结果为True 对应 的参数值 “过滤出来”
# 过滤出来的值会添加到 filter对象中
filter_obj = filter(lambda name: name.endswith('_dsb'), name_list)
print(filter_obj)
print(list(filter_obj))  #
# print(tuple(filter_obj))

