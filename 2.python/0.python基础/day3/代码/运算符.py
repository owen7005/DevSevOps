# 算数运算符

# a = 9
# b = 2
#
# print(a // b)  # 取整。
# print(a % b)  # 取模
# print(a ** b)  # 次幂 9 ^ 2

# 比较运算符

# print(a == b)  # 判断运算符左右两边的值是否相等
# print(a != b)  # 判断运算符左右两边的值是否不相等
#
# print(a > b)
# print(a >= b)
# print(a < b)
# print(a <= b)

# 赋值运算符
# 增量赋值
# a = 1
# a += 1  # a = a + 1
# print(a)

# a -= 1
# print(a)

# a *= 2
# print(a)

# a /= 2
# print(a)

# 链式赋值
# x = 1
# y = 1
# z = 1
# x = y = z = 1
# print(x,y,z)

# 交叉赋值

# a = 1
# b = 2
# print(f"a:{a},b:{b}")
# c = a
# a = b
# b = c
# print(f"a:{a},b:{b}")
# a, b = b, a
# print(f"a:{a},b:{b}")

# 解压赋值

l1 = [1,2,3,4,5,6]
# a = l1[0]
# b = l1[1]
# c = l1[2]
# d = l1[3]

# print(a,b,c,d)

# a,b,c,d,*_ = l1  # *_可以接收溢出的元素
# *_,a,b,c,d = l1

# print(a,b,c,d)

