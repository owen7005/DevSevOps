test_list = [1, 6, 3, 5, 3, 4]

print("查看 4 是否在列表中 ( 使用循环 ) : ")

for i in test_list:
    if (i == 4):
        print("存在")

print("查看 4 是否在列表中 ( 使用 in 关键字 ) : ")

if (4 in test_list):
    print("存在")