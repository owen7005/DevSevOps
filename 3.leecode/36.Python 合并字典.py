def Merge(dict1, dict2):
    res = {**dict1, **dict2}
    return res


# 两个字典
dict1 = {'a': 10, 'b': 8}
dict2 = {'d': 6, 'c': 4}
dict3 = Merge(dict1, dict2)
print(dict3)