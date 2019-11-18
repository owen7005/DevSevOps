'''   - sha_256(了解)
hashlib是一个加密模块:
    内置了很多算法
    - MD5(*******): 不可解密的算法（2018年以前）

    摘要算法:
        - 摘要是从某个内容中获取的加密字符串
        - 摘要一样，内容就一定一样: 保证唯一性

        - 密文密码就是一个摘要
'''

# import hashlib
#
# md5_obj = hashlib.md5()
# # print(type(md5_obj))
# str1 = '1234'
# # update中一定要传入bytes类型数据
# md5_obj.update(str1.encode('utf-8'))
#
# # 得到一个加密后的字符串
# res = md5_obj.hexdigest()
# # 202cb962ac59075b964b07152d234b70
# print(res)


# 以上操作撞库有可能会破解真实密码

# 防止撞库问题: 加盐

import hashlib


def pwd_md5(pwd):  #
    md5_obj = hashlib.md5()
    # print(type(md5_obj))
    str1 = pwd  # '1234'
    # update中一定要传入bytes类型数据
    md5_obj.update(str1.encode('utf-8'))

    # 创造盐
    sal = '坦克怎么这么帅啊!'
    # 加盐
    md5_obj.update(sal.encode('utf-8'))

    # 得到一个加密后的字符串
    res = md5_obj.hexdigest()
    # eb1ca06cf5940e9fb6ef39100ec72c94
    return res

# user_str1 = f'tank:1234'
#
# user_str2 = f'tank:{res}'

# with open('user.txt', 'w', encoding='utf-8') as f:
#     f.write(user_str2)

# 模拟用户登陆操作

# 获取文件中的用户名与密码
with open('user.txt', 'r', encoding='utf-8') as f:
    user_str = f.read()

file_user, file_pwd = user_str.split(':')

# 用户输入用户名与密码
username = input('请输入用户名:').strip()
password = input('请输入密码:').strip()  # 1234

# 校验用户名与密码是否一致
if username == file_user and file_pwd == pwd_md5(password):  # pwd_md5('1234')
    print('登陆成功')
else:
    print('登陆失败')
