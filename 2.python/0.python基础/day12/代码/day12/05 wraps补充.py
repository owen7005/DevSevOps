'''
wraps: （了解）
    是一个修复工具，修复的是被装饰对象的空间。
    from functools import wraps

'''
from functools import wraps


def wrapper(func):

    @wraps(func)  # 修改名称空间: inner ---》 func
    def inner(*args, **kwargs):
        '''
        此处是装饰器的注释
        :param func:
        :return:
        '''
        res = func(*args, **kwargs)
        return res
    return inner  # ---》 func


@wrapper
def index():
    '''
    此处是index函数的注释
    :return:
    '''
    pass


print(index)  # 函数对象

# 函数对象.__doc__: 查看函数内部的注释
print(index.__doc__)  # inner.__doc__
