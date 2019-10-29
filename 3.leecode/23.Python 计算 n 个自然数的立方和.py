# 定义立方和的函数
def sumOfSeries(n):
    sum = 0
    for i in range(1, n + 1):
        sum += i * i * i

    return sum


# 调用函数
n = 5
print(sumOfSeries(n))