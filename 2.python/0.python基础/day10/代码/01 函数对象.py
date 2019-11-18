# 函数是第一类对象

# 1、函数名是可以被引用：

# name = 'tank'
# dsb = name

# def index():
#     print('from index')
#
#
# a = index
# a()

# 2、函数名可以当做参数传递

# def foo(x, y, func):
#     print(x, y)
#     func()
#
#
# def bar():
#     print('from bar')
#
#
# foo(1, 2, bar)

# 3 函数名可以当做返回值使用
# 传参的时候没有特殊需求，一定不要加括号，加括号当场执行了

# def index():
#     print("from index")
#
#
# def func(a):
#     return a
#
#
# a = func(index)
# # print(a)
# a()

# 4、函数名可以被当做容器类型的元素

# def func():
#     print('from func')
#
#
# l1 = [1, '2', func, func()]
#
# f = l1[2]
# print(f)

def register():
    print('register')


def login():
    print('login')


def shopping():
    print('shopping')


def pay():
    print('pay')


func_dic = {
    '1': register,
    '2': login,
    '3': shopping,
    '4': pay
}

def main():
    while True:
        print("""
            1、注册
            2、登录
            3、购物
            4、付款
            5、退出
        """)
        choice = input("请输入对应的编号：").strip()
        if choice == '5':
            break
        if choice not in func_dic:
            continue
        else:
            func_dic[choice]()

main()