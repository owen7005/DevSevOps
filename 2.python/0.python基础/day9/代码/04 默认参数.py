"""
默认参数：
    在定义函数阶段就已经传入参数，
    如果说你在实参的时候传入了一个新的参数，就会使用新参数
    默认参数在传值的时候，不要将可变类型当做参数传递

    应用场景：
        当参数对应值重复出现的情况下使用默认参数
"""


# def reg(username, password, gender='male'):
#     print(f"用户名：{username}，密码:{password},性别：{gender}")
#
# reg('tank','dsb')
# reg('jason','dsb')
# reg('egon','xsb')
# reg('胡晨阳','dsb','female')


# 第一种解决
# def reg(hobby, l1=None):  # 四个形参
#     if l1 == None:
#         l1 = []
#     l1.append(hobby)
#     print(f"爱好：{l1}")
#
#
# reg(hobby='生蚝')
# reg('大保健')
# reg('女教练')

# 第二种解决方案

def reg(hobby, l1):  # 四个形参
    l1.append(hobby)
    print(f"爱好：{l1}")


reg('生蚝', [])
reg('大保健', [])
reg('女教练', [])
