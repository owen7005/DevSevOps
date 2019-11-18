# 定义在* 和**之间
# 在给命名关键字传值的时候一定要以关键字形式传递
# 关键字参数一定不能放在位置参数前面
def index(x, y, z, a=1, *args, b, **kwargs):
    print(x, y, z)
    print(args)
    print(a, b)
    print(kwargs)

index(1, 2, 3,354353, 4342, 3213123, b=222, c=333, d=444)