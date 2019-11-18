'''
pickle模块:
    pickle是一个python自带的序列化模块。

    优点:
        - 可以支持python中所有的数据类型
        - 可以直接存 "bytes类型" 的数据，pickle存取速度更快

    缺点: （致命的缺点）
        - 只能支持python去使用，不能跨平台
'''

import pickle

# set1 = {
#     'tank', 'sean', 'jason', '大脸'
# }
#
# # 写 dump
# with open('teacher.pickle', 'wb') as f:
#     pickle.dump(set1, f)


# 读 load
with open('teacher.pickle', 'rb') as f:
    python_set = pickle.load(f)
    print(python_set)
    print(type(python_set))
