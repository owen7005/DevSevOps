# x = "ａｂｃ"

# y = 'abc'

# print(y.encode('gbk'))


with open('a.txt', 'r', encoding='utf-8')as rf,\
        open('a.txt','a',encoding='utf-8')as wf:
    wf.write('亚峰牛批')
    wf.flush()
    print(rf.read())