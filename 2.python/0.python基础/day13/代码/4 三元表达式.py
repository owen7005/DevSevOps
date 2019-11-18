'''
三元表达式:

    可以将if...else...分支变成一行。

    语法:
       条件成立返回左边的值 if 判断条件 else 条件不成立返回右边的值
'''

# if 判断条件:
#     执行
# else:
#     执行


# 求两个值的大小
# 通过if...else语法
# def max2(num1, num2):
#
#     if num1 > num2:
#         return num1
#     else:
#         return num2
#
# res = max2(100, 20)
#
# print(res)

# 三元表达式
# num1 = 10
# num2 = 20
# # 伪代码
# # return num1 if num1 > num2 else return num2
# # res = num1 if num1 > num2 else num2
# def max2(num1, num2):
#     res = num1 if num1 > num2 else num2
#     return res
#
# res = max2(num1, num2)
# print(res)


# 需求: 让用户输入用户名，输入的用户如果不是tank，为其后缀添加_DSB
username = input('请输入用户名:').strip()
new_username = username if username == 'tank' else username + '_DSB'
print(new_username)
