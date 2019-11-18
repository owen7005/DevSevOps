# find\rfind\index\rindex\count

# find # 查找当前字符串中某个元素的位置，返回索引，找不到返回-1
# s1 = '你今天吃饭吃了吗？'
# print(s1.find("？",))

# index  # 查找当前字符串中某个元素的位置，返回索引，找不到返回异常
# print(s1.index("？"))

# count  # 统计当前字符串中某一个元素的个数
# print(s1.count("吃"))


# center\ljust\rjust\zfill

# print("欢迎光临".center(8,"-"))

# print("欢迎光临".ljust(30,"-"))
# print("欢迎光临".rjust(30,"-"))

# print("欢迎光临".zfill(50))


#

# s1 = """
# sean\t18\tmale\t
# tank\t84\tfemale\t
# """
# print(s1.expandtabs())
# print(s1.expandtabs())

# is系列

a = b'10'
b = '10'
c = '十'
d = 'IV'
print(type(a))

# print(b.isnumeric())
# print(c.isnumeric())
# print(d.isnumeric())

# isdigit: unicode,bytes

print(a.isdigit())
print(b.isdigit())


