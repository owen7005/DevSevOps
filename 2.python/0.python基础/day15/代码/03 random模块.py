import random

# 随机获取1—9中任意的整数
# res = random.randint(1, 9)
# print(res)

# 默认获取0——1之间任意小数
# res2 = random.random()
# print(res2)

# 洗牌
# 将可迭代中的值进行乱序
# list1 = ['红桃A', '梅花A', '红桃Q', '方块K']
# random.shuffle(list1)
# print(list1)

# 随机获取可迭代对象中的某一个值
# list1 = ['红桃A', '梅花A', '红桃Q', '方块K']
# res3 = random.choice(list1)
# print(res3)


# 需求: 随机验证码
'''
需求: 
    大小写字母、数字组合而成
    组合5位数的随机验证码
    
前置技术:
    - chr(97)  # 可以将ASCII表中值转换成对应的字符
    # print(chr(101))
    - random.choice
'''


# 获取任意长度的随机验证码
def get_code(n):
    code = ''
    # 每次循环只从大小写字母、数字中取出一个字符
    # for line in range(5):
    for line in range(n):

        # 随机获取一个小写字母
        res1 = random.randint(97, 122)
        lower_str = chr(res1)

        # 随机获取一个大写字母
        res2 = random.randint(65, 90)
        upper_str = chr(res2)

        # 随机获取一个数字
        number = str(random.randint(0, 9))

        code_list = [lower_str, upper_str, number]

        random_code = random.choice(code_list)

        code += random_code

    return code


code = get_code(100)
print(code)
print(len(code))
