name = 'tank'

"""
什么是名称空间？
    存放名字的空间
    
如果你想访问一个变量值，必须先方向对应的名称空间，拿到名字和对应的内存地址的绑定关系

名称空间的分类：
    1、内置名称空间：
        python提前给你的定义完的名字，就是存在内置名称空间
    2、全局名称空间
        存放于文件级别的名字，就是全局名称空间
        if while for 内部定义的名字执行之后都存放于全局名称空间
    3、局部名称空间
        函数内部定义的所有名字都是存放与当前函数的内置名称空间

生命周期：
    1、内置名称空间
        在python解释器启动的时候生效，关闭解释器的时候失效
    2、全局名称空间
        当你启动当前这个py文件的时候生效，当前页面代码执行结束之后失效
    3、局部名称空间
        当你调用当前函数时生效，函数体最后一行代码执行结束就失效
名称空间的查找顺序:
    
"""


def index():
    x = 1
    return x
print("index1",index)
def foo():
    print("index2",index)
foo()

# print(print)
# def index():
#     print(print)
#
# index()

# x = 1


# print(x)

# def index():
#     print(x)
#
#
# index()

# x = 1
# print(x)
#
# def index():
#     pass
#
# print(index)

# if 1 == 1:
#     x = 1

# print(x)

# while True:
#     a = 2
#     break
#
# print(a)
# for i in range(2):
#     print(i)
#
# print(i)

# def index():
#     a = 1
#
# index()
# print(a)
