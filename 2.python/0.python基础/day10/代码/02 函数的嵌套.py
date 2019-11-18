# 函数的嵌套调用:在函数内调用函数

# def index():
#     print('from index')
#
#
# def func():
#     index()
#     print('from func')
#
#
# func()


# def func1(x, y):
#     if x > y:
#         return x
#     else:
#         return y


# print(func1(1,2))

# def func2(x, y, z, a):
#     result = func1(x, y)
#     result = func1(result, z)
#     result = func1(result, a)
#     return result
#
#
# print(func2(1, 200000, 3, 1000))


# 函数的嵌套定义：

def index():
    def home():
        print("from home")
    home()

index()