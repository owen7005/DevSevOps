"""
打开文件的三种模式：
    r :
        1、只读
        2、如果文件不存在，会报错
    w：（慎用）
        1、只写
        2、如果文件不存在，则新建一个文件写入数据
        3、如果文件内存在数据，会将数据清空，重新写入
    a：
        1、追加写
        2、如果文件内存在数据，会在已有数据的后面追加数据
        3、如果文件不存在，则新建一个文件写入数据
处理文件的模式：
    t
    b
"""

# with open(r'dir\b.txt','r',encoding='gbk')as f:
#     print(f.readable())
# print(f.read())
# print(f.readline())  # 执行一次，打印一行内容
# print(f.readlines())
# print(f.read())
# print(f.readable())
# print(f.read())
# for i in f:
#     print(i)


# with open(r'dir\b.txt', 'w', encoding='gbk')as f:
#     # f.write("上海校区第一帅-sean")
#     f.writelines(["上午没翻车\n",'我很高兴'])


# with open(r'dir\aaaaa.txt','a',encoding='gbk')as f:
    # print(f.writable())
    # f.write("\n翻车是不可能的")

