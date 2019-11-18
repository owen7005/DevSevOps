# 字符串
# 定义：存一些描述性信息，存个人爱好，个人简介
# 字符串引号是用没有区别，但是不能混用
# 如果字符串中还需引号，就必须嵌套


s1 = 'sean'  # s1 = str(sean)

print(s1)
print(type(s1))
print(id(s1))


"""
python2:
    str本质其实是有一个拥有8个bit位的序列
    >>> s1 = 'sean'
    >>> type(s1)
    <type 'str'>
    >>> s1 = s1.decode("utf-8")
    >>> type(s1)
    <type 'unicode'>
    >>> s1
    u'sean'
python3:
    str本质其实是unicode序列
    >>> ss1 = 'sean'
    >>>
    >>> type(ss1)
    <class 'str'>
    >>>
    >>> ss1 = ss1.encode('utf-8')
    >>> ss1
    b'sean'
    >>>
    >>> type(ss1)
    <class 'bytes'>
        
1024G = 1T
1024M = 1G
1024KB = 1M
1024B = 1KB
1B = 8bit
"""

# 单引号

# s1 = 'sean'
# print(s1)

#  双引号

# s2 = "sean"
# print(s2)

# 三引号

# s3 = '''sean'''
#
# s4 = """sean"""
#
# print(s3)
# print(s4)

# s5 = 'dadada"dada"'



# 字符串拼接是开辟一个新的内存空间，将你拼接之后的值存进去
s6 = 'hello'

s7 = 'world'
print(s6 + s7)