'''
闭包函数:
    1.闭包函数必须在函数内部定义
    2.闭包函数可以引用外层函数的名字

    闭包函数是 函数嵌套、函数对象、名称空间与作用域 结合体。
'''


# 直接传参
def func(x):
    print(x)


func(1000)


# 通过闭包函数传参
def outer(number):
    # number = 100
    # inner就是闭包函数
    def inner():
        print(number)
    return inner


func = outer(1000)  # ---》 inner地址 ---》 func变量名
func()  # func ---> inner地址（）

