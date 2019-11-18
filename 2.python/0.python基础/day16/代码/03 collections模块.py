'''
- python默认八大数据:
            - 整型
            - 浮点型
            - 字符串
            - 字典
            - 元组
            - 列表
            - 集合
            - 布尔
collections模块:
    - 提供一些python八大数据类型 “以外的数据类型” 。


    - 具名元组:
        具名元组 只是一个名字。
        应用场景:
            - 坐标
            -

        from collections import namedtuple

    - 有序字典:
        - python中字典默认是无序

        - collections中提供了有序的字典

        from collections import OrderedDict

'''


# 具名元组
# from collections import namedtuple

# 传入可迭代对象是有序的
# 应用:坐标
# 将'坐标'变成 “对象” 的名字
# point = namedtuple('坐标', ['x', 'y'])  # 第二个参数既可以传可迭代对象
# point = namedtuple('坐标', ('x', 'y'))  # 第二个参数既可以传可迭代对象
# point = namedtuple('坐标', 'x y')  # 第二个参数既可以传可迭代对象
#
# # 会将 1 ---> x,   2 ---> y
# 传参的个数，要与namedtuple第二个参数的个数一一对应
# p = point(1, 3)  # 本质上传了4个，面向对象讲解
# print(p)
# print(type(p))


# 扑克牌:
# 获取扑克牌对象
# card = namedtuple('扑克牌',  ['color', 'number'])
#
# # 由扑克牌对象产生一张 扑克牌
# red_A = card('♥', 'A')
# print(red_A)
# black_K = card('♠', 'K')
# print(black_K)

# 演员的信息
# p = namedtuple('dao国', 'city movie_type name')
# jason_and_dabing = p('大阪', 'action', 'C老师')
# print(jason_and_dabing)



# 有序字典
# python默认无序字典
dic = dict({'x': 1, 'y': 2, 'z': 3})
print(dic)
print(type(dic))
for line in dic:
    print(line)


from collections import OrderedDict
# 有序字典
order_dict = OrderedDict({'x': 1, 'y': 2, 'z': 3})
print(order_dict, '打印有序的字典')
print(type(order_dict))
print(order_dict.get('y'))
print(order_dict['y'])

for line in order_dict:
    print(line)

