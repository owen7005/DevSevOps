# -*- coding:utf-8 -*-


test = "jacky Li yuan."
print("字符串长度:{}".format(len(test)))
print("首字母大写: {}".format(test.capitalize()))
print("首字母大写: %s" % test.capitalize())
print("字符a出现次数: {}".format(test.count('a')))
print("是否以句号结尾: {}".format(test.endswith('.')))
print("L字符是否是开头: {}".format(test.startswith('L')))
print("L字符索引位置: {}".format(test.find('L')))
print("格式化字符串: Jacky Li{0} Yuan.".format(','))
print("是否都是小写: {}".format(test.islower()))
print("是否都是大写: {}".format(test.isupper()))
print("所有字母都转为小写: {}".format(test.lower()))
print("所有字母都转为大写: {}".format(test.upper()))
print("句号替换为感叹号: {}".format(test.replace('.','!')))
print("以空格分隔切分成列表: {}".format(test.split(' ')))
print("转换为一个列表: {}".format(test.splitlines()))
print("去除两边空格: {}".format(test.strip()))
print("大小写互换: {}".format(test.swapcase()))
print("只要jacky Li字符串: {}".format(test[0:8]))
print("去掉倒数第一个字符: {}".format(test[0:-1]))
print("查找最后一次出现该字符串的位置: {}".format(test.rfind('a')))
print("所有字符全是字母或者数字:{}".format(test.isalnum()))


import io
test = "Jacky Li Yuan"
iotest = io.StringIO(test)
print(iotest)
print(iotest.getvalue())
print(iotest.seek(7))
print(iotest.write("Y"))
print(iotest.getvalue())


# 字体颜色
for i in range(31,38):
    print("\033[{};40mJacky Li.\033[0m".format(i))
# 背景颜色
for i in range(41,48):
    print("\033[47;{}mJacky Li.\033[0m".format(i))
# 显示方式
for i in range(1,9):
    print("\033[{};31;40mJacky Li.\033[0m".format(i))
