# 无参装饰器模板
def wrapper(func):
    def inner(*args, **kwargs):
        res = func(*args, **kwargs)
        # 在被装饰对象调用后添加功能
        return res
    return inner


# 有参装饰器模板
def outer(arg):
    def wrapper(func):
        def inner(*args, **kwargs):
            res = func(*args, **kwargs)
            return res

        return inner
    return wrapper

