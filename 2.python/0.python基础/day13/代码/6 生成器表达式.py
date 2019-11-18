'''
生成器表达式(生成器生成式):
    - 列表生成式:  若数据量小时采用
        [line for line in range(1, 6)] ---> [1, 2, 3, 4, 5]
        优点:
            可以依赖于索引取值，取值方便

        缺点:
            浪费资源

    - 生成器生成式:  若数据量过大时采用
        () ---> 返回生成器
        (line for line in range(1, 6)) ---> g生成器(1, 2, 3, 4, 5)

        优点:
            节省资源

        缺点:
            取值不方便
'''

# 生成一个有1000个值的生成器
g = (line for line in range(1, 1000001))
# <generator object <genexpr> at 0x00000203262318E0>
print(g)

# 列表生成式实现
list1 = [line for line in range(1, 1000001)]
print(list1)
