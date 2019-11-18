'''
闭包函数的应用 (了解)
    ***** 为了装饰器作准备

# 下载: (了解)
    pip3 install requests

# 使用: (了解)
    import requests

'''

# 需求: 爬取某个网站，打印获取数据的长度
# 爬虫是获取数据。
import requests  # 爬虫请求工具，是大佬给我们提供的第三方的爬虫请求库


# 方式一: 直接传参
def spider_func(url):
    # 往url地址发送请求，获取响应数据
    response = requests.get(url)  # 必须接受url
    # 状态码: 200
    if response.status_code == 200:
        # 获取当前url地址中所有的文本
        print(len(response.text))
        print(response.text)
# url = 'https://www.cnblogs.com/xiaoyuanqujing/'
# spider_func(url)
# spider_func(url)
# spider_func(url)
# spider_func(url)


# 方式二: 通过闭包函数接受url地址，执行爬取函数
def spider_outer(url):
    # url = 'https://www.cnblogs.com/xiaoyuanqujing/'
    def spider_inner():
        response = requests.get(url)
        if response.status_code == 200:
            print(len(response.text))
    return spider_inner


# 爬取 小猿取经
# spider_blog = spider_outer('https://www.cnblogs.com/xiaoyuanqujing/')
# spider_blog()
# spider_blog()
# spider_blog()

# 爬取 京东
# spider_baidu = spider_outer('https://www.baidu.com/')
# spider_baidu()
# spider_baidu()
# spider_baidu()
