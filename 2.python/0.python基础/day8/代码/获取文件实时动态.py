import time

with open(r"a.txt", 'r', encoding='utf-8')as f:
    # f.seek(0, 2)  # 以文件末尾为参照点，移动0位
    while True:
        # time.sleep()
        res = f.readline()  # 一次读一行
        if res:  # 如果你读出数据了，就执行下面的代码块
            print(f'录入记录：{res}')

