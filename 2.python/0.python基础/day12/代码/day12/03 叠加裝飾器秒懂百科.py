
def wrapper1(func):
    def inner1(*args, **kwargs):
        print('1---start')
        # 被裝飾對象在調用時,如果還有其他裝飾器,會先執行其他裝飾器中的inner
        # inner2
        res = func(*args, **kwargs)
        print('1---end')
        return res
    return inner1


def wrapper2(func):
    def inner2(*args, **kwargs):
        print('2---start')
        res = func(*args, **kwargs)
        print('2---end')
        return res
    return inner2


def wrapper3(func):
    def inner3(*args, **kwargs):
        print('3---start')
        res = func(*args, **kwargs)
        print('3---end')
        return res
    return inner3

'''
叠加裝飾器的裝飾順序與執行順序:
    - 裝飾順序: 调用wrapper装饰器拿到返回值inner
        由下往上裝飾
        
    - 執行順序: 调用装饰过后的返回值inner
        由上往下執行
'''


@wrapper1  # index《---inner1 = wrapper1(inner2)
@wrapper2  # inner2 = wrapper2(inner3)
@wrapper3  # inner3 = wrapper3(index)
def index():  # 被裝飾對象   # inner1 ---》
    print('from index...')


# 正在装饰
inner3 = wrapper3(index)
inner2 = wrapper2(inner3)
inner1 = wrapper1(inner2)


'''
inner1()
inner2()
inner3()
index()
'''
index()  # 此处执行 # inner1() --> inner2() ---> inner3()
