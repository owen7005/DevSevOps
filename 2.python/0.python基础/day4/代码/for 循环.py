# l1 = [1, 2, 3, 4, 5, 6, 7]
# s1 = 'hello'
#
# count = 0
# while count<len(s1):
#     print(s1[count])
#     count += 1

d1 = {'a':1,'b':2,"c":3}
#
# count = 0
# while count < len(d1):
#     print(count)
#     count += 1

# for i in d1:
#     print(d1[i])

# for:给我们提供了一种不依赖于索引的取值方式
# for取值方式更加简洁
# l1 = [1, 2, 3, 4, 5, 6, 7]
# for i in l1:
#     print(i)

# range(10) 等价于-->[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# l1 = [1,2,3,4,5,6,7,8,9,10]
#
# for i in l1:
#     print(i)

# print(range(10))

# range() 顾头不顾尾
# start  stop  sep
# for i in range(0,10,9):
#     print(i)


# for i in range(0,10):
#     if i == 7:
#         continue
#     if i == 9:
#         break
#     print(i)

# for循环正常执行结束，就会执行else对应的代码块
# 非正常结束，例如break打断，就不会执行

for i in range(10):
    if i == 5:
        break
    print(i)
else:
    print('执行成功')