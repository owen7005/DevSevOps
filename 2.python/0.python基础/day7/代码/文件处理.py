"""
1、什么是文件
    操作系统提供给你操作硬盘的一个工具

2、为什么要用文件
    因为人类和计算机要永久保存数据

3、怎么用文件

相对路径：a.txt  # 必须与当前py文件在同一级目录
绝对路径：D:\项目路径\python13期\day07\a.txt

"""

# f = open("a.txt")
#
# print(f.readable())  # 判断当前文件是否可读
# print(f.writable())  # 判断当前文件是否可写
#
# # del f  # 回收变量资源
# f.close()  # 回收操作系统的资源


# with open('a.txt',mode='r')as rf,\
#         open('a.txt',mode='w')as wf:  # with会自动帮你回收操作系统的资源，无需自己操作
#     print(rf.readable())
#     print(wf.writable())

# r进行转义
with open(r'D:\项目路径\python13期\day07\a.txt')as f:
    print(f.read())   # 读取文件






