# ========================基本方法===========================
# 用途: 用于存储一些描述性信息，名字。。
# 定义方式:
# 第一种：

# s1 = '大象'

# 第二种：

# s2 = "大象2"

# 第三种：
#
# s3 = '''大象3'''
#
# s4 = """大象4"""
#
# print(s1,s2,s3,s4)

# 以上三种方式没有任何区别，但是不能混用

# s5 = '你今天"吃饭"了吗'

# 补充：字符串前面加一个小写的r，代表转义

# 常用方法:

# 优先掌握知识点
"""
1、索引取值（正向取、反向取），只能取不能存
"""
# s1 = 'hello world'

# print(s1[4])  # 正向取
# print(s1[-7]) # 反向取

# 2、索引切片  ： 截取字符串中的一小段字符串

# print(s1[2:5])
# print(s1[4:])
# print(s1[:5])
# print(s1[0:-2:2])
# print(s1[::-1])

# 3、成员运算：in  not in

# print("o" not in s1)

# 4、strip :去除字符串左右两边的空格，中间不算
# input无论接受的是什么类型，一定返回的是字符串

# name = input(">>:").strip()
# print(len(name))

# a1 = '$$$$sean$$$'
# print(a1.strip("$"))


# 5:split : 切分: 对字符串进行切分，可以指定切分的分隔符，返回是一个列表

# a1 = 'sean 18 male'
#
# print(a1.split())

# 6 ：len() :获取当前数据中的元素的个数

# a1 = 'hello'
#
# print(a1)

# for
# a1 = 'hello'
#
# for i in a1:
#     print(i)

# 需要掌握知识点
# strip，rstrip,lstrip

# inp = input(">>:").lstrip("*")
# print(inp)
# print(len(inp))


# lower\upper
# s1 = 'Hello world'

# print(s1.upper())
# print(s1.lower())


# startswith\endswith  : 判断当前字符串是否以。。。开头，或者以。。结尾，返回的一定是布尔值
# print(s1.startswith("He"))

# print(s1.endswith('ld'))

# .format()
#  你的名字是：sean，你的年龄是：18

# name = 'sean'
# age = 19

# print("你的名字是:",name,"你的年龄是,",age)

# print("你的名字是：{}，你的年龄是：{}".format(name,age))

# print("你的名字是：{1}，你的年龄是：{0}".format(name,age))

# print("你的名字是：{name}，你的年龄是：{age},{gender}".format(age=age,name=name,gender='male'))

# f-string:
# 通过大括号接收变量，在字符串前面一定要加一个小写f，，，，在python3.6以后才有
# print(f"你的名字是：{name}，你的年龄是：{age}")

# split\rsplit
# s1 = "name,age,gender"
#
# print(s1.split(",",1))  # 可以指定切分的次数

# join : 将（列表）中每个元素按照前面字符串中的分隔符进行拼接
#
# l1 = ['sean','18','male']
#
# print("|".join(l1))

# replace：将字符串中的元素进行替换，参数，先老值，再新值

# s1 = 'sean,18'
# print(s1.replace("sean",'大象'))


# isdigit() ： 判断当前字符串中的数据，是否是一个数字，返回布尔值

# score = input("please input your score:")
#
# if score.isdigit():
#     score = int(score)
#     if score >= 90:
#         print('优秀')
# else:
#     print("你tmd能不能好好输")


s1 = "胡晨阳"
print(s1)
print(id(s1))
s1 = '高地'
print(s1)
print(id(s1))

# =========================类型总结==========================
# 有序or无序  : 有序
# 可变or不可变  ：不可变类型
"""
值变id不变就是可变类型
值变id也变就是不可变类型
"""

# 存一个值or存多个值  ： 存一个值