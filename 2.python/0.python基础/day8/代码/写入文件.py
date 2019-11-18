import time

res = time.strftime('%Y-%m-%d %H:%M:%S')

with open(r'a.txt','a',encoding='utf-8')as f:
    for i in range(10):
        f.write(f'{res}：马上要学函数了，有点难，怎么办\n')
