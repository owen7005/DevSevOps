# -*- coding:utf-8 -*-

# 传递不可变对象时,不可变对象里面包含的子对象是可变的,则方法内修改了这个可变对象,源对象也发生了变化.
"""
a = 10
print("a:",id(a))

def test01(m):
    print("m:",id(m))
    m = 20
    print(m)
    print("m:",id(m))


test01(a)

print("=="*30)

b = (10,20,[5,6])
print("a:",id(a))

def test02(m):
    print("m:",id(m))
    m[2][0] = 888
    print(m)
    print("m:",id(m))

test02(b)
print(b)




def test03(a,b,c,d):
    return a+b+c+d

print("=="*30)
g = [lambda a:a*2, lambda b: b*3]
print(g[0](6))


print("=="*30)
h = [test03,test03]  # 函数也是对象
print(h[0](3,4,5,6))



print("=="*30)
# eval函数
a = 10
b = 20
c = eval("a+b")
print(c)
print("=="*30)

dict1 = dict(a=20,b=30)
d = eval("a+b",dict1)
print(d)

"""








# 递归函数-函数调用内存分析--栈帧的创建
"""
def test01():
    print("test01")
    # test02()
    test01()

def test02():
    print("test02")

test01()


print("===="*30)

def test01(n):
    print("test01:",n)
    if n == 0:
        print("over")
    else:
        test01(n-1)

    print("test01***",n)  # 最先调用的,最后执行.


test01(4)

# 先进后出,后进先出
"""





# 递归函数
# 使用递归函数计算阶乘(factorial)
"""
def factorial(n):
    if n == 1: return 1
    return n*factorial(n-1)

for i in range(1,6):
    print(i,"!=",factorial(i))
"""

print('=='*30)


def fact(n):

    if n == 1:
        return 1
    else:
        return n*fact(n-1)

result = fact(6)
print(result)

print('=='*30)

# 嵌套函数
def f1():
    print("f1 running ...")

    def f2():
        print("f2 running...")
    
    f2()

f1()

print('=='*30)

def outer():
    print("outer running ...")

    def inner():
        print("inner running ...")

    inner()

outer()


print("=="*30)


# 使用嵌套函数避免重复代码
def ChineseName(name,familyname):
    print("{0}\t{1}".format(familyname,name))
    
def EnglishName(name,familyname):
    print("{0}\t{1}".format(name,familyname))


# 使用1个函数代替上面的两个函数
def Name(isChinese,name,familyname):
    def inner_print(a,b):
        print("{0}\t{1}".format(a,b))

    if isChinese:
        inner_print(familyname,name)
    else:
        inner_print(name,familyname)

Name(True,"小五","赵")
Name(False,"Jacky","Li")



print("=="*30)

# 测试nonlocal,global关键字用法

a = 150
def ounter():
    b = 10

    def inners():

        nonlocal b   # 声明外部函数的局部变量
        print("inner b:",b)
        b = 20

    inners()
    print("ounter b:",b)

    global a 
    a = 1500      # 声明全局变量


ounter()
print("global a:",a)





# 测试LEGB
glo = "global environment"
print(glo)
def outside():

    column = "at the outside"
    print(column)

    def inside():
        column = "on the inside"
        print(column)

    inside()

outside()