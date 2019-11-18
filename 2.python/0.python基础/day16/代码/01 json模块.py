'''
json模块: 是一个序列化模块。
    json:
        是一个 “第三方” 的特殊数据格式。

        可以将python数据类型 ----》 json数据格式 ----》 字符串 ----》 文件中

        其他语言要想使用python的数据:
            文件中 ----》 字符串 ----》 json数据格式 ----》 其他语言的数据类型。

        注意: 在json中，所有的字符串都是双引号

        # 元组比较特殊:
        python中的元组，若将其转换成json数据，内部会将元组 ---> 列表

        # set是不能转换成json数据

为什么要使用json:
    - 为了让不同的语言之间数据可以共享。

    PS: 由于各种语言的数据类型不一，但长相可以一样，
    比如python不能直接使用其他语言的数据类型，
    必须将其他语言的数据类型转换成json数据格式，
    python获取到json数据后可以将json转换成pyton的数据类型。

如何使用:
    import json

    - json.dumps：
    json.dumps(), f = open() --> f.write()
        # 序列化: python数据类型 ---》 json ---》 字符串 ---》 json文件中

    - json.loads:
    f = open(), str = f.read(),  json.loads(str)
        # 反序列化: json文件中 --》  字符串 ---》 json ---》 python或其他语言数据类型

    - json.dump()：  # 序列化: python数据类型 ---》 json ---》 字符串 ---》 json文件中
        - 内部实现 f.write()

    - json.load()：  # 反序列化: json文件中 --》  字符串 ---》 json ---》 python或其他语言数据类型
        - 内部实现 f.read()

    - dump, load: 使用更方便

注意: 保存json数据时，用.json作为文件的后缀名
'''
# import json

# # 列表
# # list1 = ['123', '321']
# list1 = ['张全蛋', '李小花']
# # dumps: 将python数据 ---》 json数据格式 ---》 字符串
# # ensure_ascii将默认的ascii取消设置为False，可以在控制台看到中文，否则看到的是bytes类型数据
# json_str = json.dumps(list1, ensure_ascii=False)
# print(json_str)
# print(type(json_str))  # str
#
# # json.loads()字符串 ----> json数据格式 ---》将python数据
# python_data = json.loads(json_str)
# print(python_data)
# print(type(python_data))  # list


# 元组
# tuple1 = ('张全蛋', '李小花')
# # dumps: 将python数据 ---》 json数据格式 ---》 字符串
# # ensure_ascii将默认的ascii取消设置为False，可以在控制台看到中文，否则看到的是bytes类型数据
# json_str = json.dumps(tuple1, ensure_ascii=False)
# print(json_str)
# print(type(json_str))  # str
#
# # json.loads()字符串 ----> json数据格式 ---》将python数据
# python_data = json.loads(json_str)
# print(tuple(python_data))
# print(type(tuple(python_data)))  # list

# 字典
# dic = {
#     'name': 'tank',
#     'age': 17
# }
#
# # dumps: 将python数据 ---》 json数据格式 ---》 字符串
# # ensure_ascii将默认的ascii取消设置为False，可以在控制台看到中文，否则看到的是bytes类型数据
# json_str = json.dumps(dic, ensure_ascii=False)
# print(json_str)
# print(type(json_str))  # str
#
# # json.loads()字符串 ----> json数据格式 ---》将python数据
# python_data = json.loads(json_str)
# print(python_data)
# print(type(python_data))  # dict


# 注意: 集合是不能被序列化成json
# set1 = {
#     1, 2, 3, 4, 5
# }
#
# # dumps: 将python数据 ---》 json数据格式 ---》 字符串
# # ensure_ascii将默认的ascii取消设置为False，可以在控制台看到中文，否则看到的是bytes类型数据
# json_str = json.dumps(set1, ensure_ascii=False)
# print(json_str)
# print(type(json_str))  # str
#
# # json.loads()字符串 ----> json数据格式 ---》将python数据
# python_data = json.loads(json_str)
# print(python_data)
# print(type(python_data))  # dict


# 注册功能:
# def register():
#     username = input('请输入用户名:').strip()
#     password = input('请输入密码:').strip()
#     re_password = input('请确认密码:').strip()
#     if password == re_password:
#         # [username, password]
#         # {'name': username, 'pwd': password}
#         user_dic = {
#             'name': username, 'pwd': password
#         }
#
#         json_str = json.dumps(user_dic, ensure_ascii=False)
#
#         # 开始写入文件中
#         # 注意: 保存json数据时，用.json作为文件的后缀名
#         with open('user.json', 'w', encoding='utf-8') as f:
#             f.write(json_str)
#
#
# register()


# dump, load
# import json
# user_dic = {
#     'username': 'tank',
#     'password': 123
# }
# f = open('user2.json', 'w', encoding='utf-8')
# json.dump(user_dic, f)
# f.close()
#
# with open('user3.json', 'w', encoding='utf-8') as f:
#     json.dump(user_dic, f)

# with open('user3.json', 'r', encoding='utf-8') as f:
#     user_dic = json.load(f)
#     print(user_dic)
#     print(type(user_dic))
