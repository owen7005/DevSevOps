#
"""

d打印：
******
******
******
"""

# for i in range(3):
#     for j in range(6):
#         print("*",end="")
#     print()


"""
九九乘法表：
1x1=1
2x1=2 2x2 =4
。。。。     
"""

for i in range(1,10):
    for j in range(1,i+1):
        print(f"{i}x{j}={i*j}",end="")
    print()