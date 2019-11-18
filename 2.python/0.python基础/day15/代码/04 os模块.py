'''
os与操作系统交互的模块
'''
import os

# 需求: 获取当前项目根目录

# 获取当前文件中的上一级目录
# DAY15_PATH = os.path.dirname(__file__)
# print(DAY15_PATH)
#
# # 项目的根目录，路径相关的值都用 “常量”
# BASE_PATH = os.path.dirname(DAY15_PATH)
# print(BASE_PATH)
#
# # 路径的拼接： 拼接文件 “绝对路径”
# TEST_PATH = os.path.join(DAY15_PATH, '老男孩老师们的写真集.txt')
# print(TEST_PATH)
#
# # 判断“文件/文件夹”是否存在：若文件存在返回True，若不存在返回False
# print(os.path.exists(TEST_PATH))  # True
# print(os.path.exists(DAY15_PATH))  # True
#
# # 判断“文件夹”是否存在
# print(os.path.isdir(TEST_PATH))  # False
# print(os.path.isdir(DAY15_PATH))  # True
#
# # 创建文件夹
# DIR_PATH = os.path.join(DAY15_PATH, '老男孩老师们的写真集')
# # os.mkdir(DIR_PATH)

# 删除文件夹: 只能删除 “空的文件夹”
# os.rmdir(DIR_PATH)

# 获取某个文件夹中所有文件的名字
teacher_list = os.listdir(r'D:\项目路径\python13期\day15\老男孩老师们的写真集')
print(teacher_list)

# enumerate(可迭代对象) ---> 得到一个对象，对象有一个个的元组(索引, 元素)
res = enumerate(teacher_list)
print(list(res))

# 让用户选择文件
while True:
    # 1.打印所有老师的作品
    for index, name in enumerate(teacher_list):
        print(f'编号: {index} 文件名: {name}')

    choice = input('请选择想看的老师作品-->(头条影片: Jason写真) 编号：').strip()

    # 2.限制用户必须输入数字，数字的范围必须在编号内
    # 若不是数字，则重新选择
    if not choice.isdigit():
        print('必须输入数字')
        continue

    # 若是数字，往下走判断是否在编号范围内
    choice = int(choice)

    # 判断如果不在列表范围内，则重新选择
    if choice not in range(len(teacher_list)):
        print('编号范围错误!')
        continue

    file_name = teacher_list[choice]

    teacher_path = os.path.join(
        r'D:\项目路径\python13期\day15\老男孩老师们的写真集', file_name)

    print(teacher_path)

    with open(teacher_path, 'r', encoding='utf-8') as f:
        print(f.read())















