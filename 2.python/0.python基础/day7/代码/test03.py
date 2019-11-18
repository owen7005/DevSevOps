

x = '你好帅'

res = x.encode('gbk')  # （编码）默认给它当成二进制
print("unicode转utf-8：",res)


res1 = res.decode('gbk')
print("utf-8转unicode：",res1)


