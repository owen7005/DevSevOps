# 与 或 非
# and or not

a = 1
b = 2
c = 3

# print(a < b and b > c)  # and:如果有一个式子不符合条件，整条式子都为False
# print(a > b and b < c)

# print(a < b or b < c)   # or:只要有一个式子符合条件，整条式子都为True
# print(a > b or b < c)

# print(not a < b)  # 取反

print(a < b and b < c or a > c)  # True

print(a > b or b < c and a > c)  # False
