# with open(r"a.txt",'r',encoding='utf-8')as f:
#     print(f.read(5))


#
"""
f.seek(offset,whence)
offset: 相对偏移度 （光标移动的位数）针对的是字节
whence：指定光标位置从何开始
    0：从文件开头
    1：从当前位置
    2：从文件末尾

补充：
    utf-8:
        中文是3个bytes
        英文是1个bytes
    gbk：
        全部都是2个bytes

    open函数不设置encoding，默认是gbk
    与encode一毛钱都没有，encoding只是一个参数

    除了read里面的参数是针对字符，其他都是针对字节
"""

# with open(r"a.txt",'r')as f:  # 打开文件的编码：gbk
#     # print(f.read(2))
#     print(f.tell())
#     f.seek(5,0)
#     print(f.read(2))
# print(f.read(5))


# with open(r"a.txt", 'rt',encoding='utf-8')as f:  # 打开文件的编码：gbk
#     print(f.read())
#     f.seek(6, 0)
#     print(f.tell())
#     print(f.read(2))


# with open(r"a.txt",'r')as f:  # 打开文件的编码：gbk
#     # print(f.read(2))
#     print(f.tell())
#     f.seek(4,0)  # fuck的卡仕达看但扩大
#     print(f.read(2).encode('utf-8'))

# with open(r'a.txt', 'rb')as f:
#     print(f.read(10).decode('gbk'))
#     f.seek(10, 1)
#     print(f.tell())


# with open(r'a.txt', 'rb')as f:
#     f.seek(10, 1)
#     print(f.tell())


# with open(r'a.txt','rb')as f:
#     f.seek(-3,2)
#     print(f.tell())

