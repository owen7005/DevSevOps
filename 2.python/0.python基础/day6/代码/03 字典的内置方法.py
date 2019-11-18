# ========================字典(dict)基本方法===========================
# 用途:
# 定义方式:通过大括号来存储数据，通过key:value来定义键值对数据，每个键值对中间通过逗号分隔

# key:一定是一个不可变类型
# value：可以是任意类型

# d1 = {(1,2):[1,2]}

"""
字典的三种定义方式·：
"""
# 1、*****
# d1 = {'name':'egon','age':84}

# 2、*****

# d2 = dict({'name':'egon'})

# 3、zip : 了解即可

# l1 = ['name',"age"]
# l2 = ['egon',18]
# z1 = zip(l1,l2)
# print(dict(z1))

# 常用方法:

"""
1、优先掌握的
    1、按照key:value映射关系取值（可存可取）
    2、成员运算in，not in # 默认判断key
    3、len()  # 获取当前字典中键值对的个数
"""

# d1 = {'name':'egon', 'age': 73}
# print(d1['name'])
# print(d1['age'])
# d1['name'] = 'tank'
# d1['gender'] = 'male'
# print(d1)
# print('egon' in d1)
# 内置方法：

# get(******) : 获取指定key的值，如果值不存在·，默认返回None,可以通过第二个参数修改默认返回的内容
# print(d1['gender'])
# print(d1.get('gender'))
# print(d1.get('gender','male'))

# keys、values、items  ******
# print(d1.keys())  # 返回所有的key
# print(d1.values())  # 返回所有的值
# print(d1.items())  # 返回所有的键值对，返回值是列表套元组，每一个键值对都是存在元组

# for key in d1.keys():
#     print(key)
# for value in d1.values():
#     print(value)
# for key,value in d1.items():
#     print(key,value)
# key,value = ("name",'age')

# pop:删除 ： 指定key进行删除，有返回值，返回为对应的value
# a = d1.pop('name')
# print(d1)
# print(a)


# popitem() ,随机弹出一个键值对，有返回值，返回只是一个元组

# d1 = {'name':'egon', 'age': 73,'gender':'male','a':"1"}
#
# d1.popitem()
# print(d1)


# update : 用新字典替换旧字典
# d1.update({"b":'2'})
# print(d1)
# d1.update({'name':'tank'})
# print(d1)

# fromkeys : 生产一个新字典， 第一个参数（列表），它会以第一个参数中各个元素为key，以第二个参数为值，组成一个新字典



# print(dict.fromkeys([1,2,3],['ke','k1']))

# setdefault :key不存在新增键值对，有返回值，返回新增value，key存在返回对应的value

# d1 = {'name':'egon', 'age': 73,'gender':'male','a':"1"}
#
# print(d1.setdefault('name',1))
# print(d1)





# =========================类型总结==========================
# 有序or无序  ： 无序
# 可变or不可变  ：可变类型
# 存一个值or存多个值 ： 存多个值