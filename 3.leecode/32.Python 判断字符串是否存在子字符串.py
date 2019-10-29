def check(string, sub_str):
    if (string.find(sub_str) == -1):
        print("不存在！")
    else:
        print("存在！")


string = "www.runoob.com"
sub_str = "runoob"
check(string, sub_str)