"""
比较2个文件内容是否相同，类似diff命令
"""

import sys

try:
    file1 = sys.argv[1]
    file2 = sys.argv[2]
except IndexError:
    print('请输入文件参数')
else:
    with open(file1, 'rb') as f:
        str1 = f.read()
    with open(file2, 'rb') as f:
        str2 = f.read()
    if str1 == str2:
        print('相同')
    else:
        print('不相同')
