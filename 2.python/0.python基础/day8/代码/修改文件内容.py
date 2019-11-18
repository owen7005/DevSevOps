# 第一方案
# with open(r'b.txt','r',encoding='gbk')as f:
#     data = f.read()
#     print(data)
#     print(type(data))
#
# with open(r'b.txt','w',encoding='gbk')as f:
#     res = data.replace('穆斯林','亚峰牛批')
#     f.write(res)


# with open(r'b.txt','r',encoding='gbk')as rf,\
#         open(r'b.txt','a',encoding='gbk')as wf:
#     data = rf.read()
#     res = data.replace('穆斯林', '亚峰牛批')
#     wf.seek(0,0)
#     wf.write(res)


# 第二个方案
import os

with open(r'b.txt','r',encoding='gbk')as rf,\
        open(r'b_wap.txt','w',encoding='gbk')as wf:
    data = rf.read()
    res = data.replace('穆斯林', '亚峰牛批')
    wf.write(res)

os.remove('b.txt')
os.rename('b_wap.txt','b.txt')



