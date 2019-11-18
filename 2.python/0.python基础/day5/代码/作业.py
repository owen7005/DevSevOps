"""
1、使用while循环输出1 2 3 4 5 6     8 9 10

2、求1-100的所有数的和

3、输出 1-100 内的所有奇数

4、输出 1-100 内的所有偶数

5、求1-2+3-4+5 ... 99的所有数的和

6、猜年龄游戏

```python
要求：
    1、允许用户最多尝试3次
    2、每尝试3次后，如果还没猜对，就问用户是否还想继续玩，如果回答Y或y, 就继续让其猜3次，以此往复，如果回答N或n，就退出程序
    3、如果猜对了，就直接退出
```

7、运用所学知识，打印以下图案：

```python
     *
    ***
   *****
  *******
 *********
```

# 默写：
"""

# count = 0
# while count< 10:
#     count += 1
#     if count == 7:
#         continue
#     print(count)


# sum = 0
# for i in range(1,101):
#     sum += i
# print(sum)


# for i in range(1,101):
#     if i % 2 != 0:
#         print(i)


# for i in range(1,101):
#     if i % 2 == 0:
#         print(i)

# sum = 0
# for i in range(1,100):
#     if i % 2 == 0:
#         sum -= i
#     else:
#         sum += i
# print(sum)


# 6、猜年龄游戏
#
# ```python
# 要求：
#     1、允许用户最多尝试3次
#     2、每尝试3次后，如果还没猜对，就问用户是否还想继续玩，如果回答Y或y, 就继续让其猜3次，以此往复，如果回答N或n，就退出程序
#     3、如果猜对了，就直接退出
# ```


# age = "18"
# count = 1
# while True:
#     guess = input("please input your age：")
#     if guess == age:
#         print("恭喜你")
#         break
#     else:
#         print('猜错了')
#         if count == 3:
#             inp = input("》》：")
#             if inp in ['Y','y']:
#                 count = 1
#                 continue
#             elif inp in ['N','n']:
#                 break
#             else:
#                 print("你tmd能不能好好输")
#                 break
#     count += 1



"""
     *         *号：1  空格：4
    ***        *号：3  空格：3
   *****       *号：5  空格：2
  *******      *号：7  空格：1
 *********     *号：9  空格：0
"""

max_level = 5

for i in range(1,max_level+1):

    for j in range(max_level-i):
        print(" ",end="")
    for z in range(2*i-1):
        print("*",end="")
    print()









