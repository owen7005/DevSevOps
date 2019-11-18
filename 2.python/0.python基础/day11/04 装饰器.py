'''
# 需求: 统计下载电影的时间。

装饰器:
    不修改被装饰对象的源代码
    不修改被装饰对象的调用方式

    被装饰对象: ---> 需要添加功能 函数
    装饰器： ---> 被装饰对象添加的新功能 函数
'''
import time


# # 下载电影功能
# def download_movie():
#     print('开始下载电影...')
#     # 模拟电影下载时间 3秒
#     time.sleep(3)  # 等待3秒
#     print('电影下载成功...')

# start_time = time.time()  # 获取当前时间戳
# download_movie()
# end_time = time.time()  # 获取当前时间戳
# print(f'消耗时间: {end_time - start_time}')


# 装饰器:
# def time_record(func):
#     def inner():
#         # 统计开始
#         start_time = time.time()
#         func()  # func() ---> download_movie()
#         # 当被统计的函数执行完毕后，获取当前时间
#         end_time = time.time()
#         # 统计结束，打印统计时间
#         print(f'消耗时间: {end_time - start_time}')
#     return inner


# inner = time_record(download_movie)  # inner
# inner()  #  inner() ---> download_movie()

# download_movie = time_record(download_movie)  # inner
# download_movie()  #  download_movie() ---> download_movie()


# 问题1: 被装饰对象 有返回值


# # 下载电影功能
# def download_movie():
#     print('开始下载电影...')
#     # 模拟电影下载时间 3秒
#     time.sleep(3)  # 等待3秒
#     print('电影下载成功...')
#     return '小泽.mp4'
#
#
# def time_record(func):  # func <-- download_movie
#
#     # 在闭包函数中
#     def inner():
#         # 统计开始
#         start_time = time.time()
#         res = func()  # func() ---> download_movie()
#         # 当被统计的函数执行完毕后，获取当前时间
#         end_time = time.time()
#         # 统计结束，打印统计时间
#         print(f'消耗时间: {end_time - start_time}')
#
#         return res
#
#     return inner
#
#
# download_movie = time_record(download_movie)
# download_movie()


# 问题2: 被装饰对象 有参数
# 下载电影功能
# def download_movie(url):
#     print(f'{url}中的电影开始下载了...')
#     # 模拟电影下载时间 3秒
#     time.sleep(3)  # 等待3秒
#     print('电影下载成功...')
#     return '小泽.mp4'
#
#
# def time_record(func):  # func <-- download_movie
#     # url = 'https://www.baidu.com/'
#
#     # 在闭包函数中
#     def inner(url):
#         # 统计开始
#         start_time = time.time()
#
#         res = func(url)  # func(url) ---> download_movie(url)
#
#         # 当被统计的函数执行完毕后，获取当前时间
#         end_time = time.time()
#         # 统计结束，打印统计时间
#         print(f'消耗时间: {end_time - start_time}')
#         return res
#     return inner
#
#
# download_movie = time_record(download_movie)

# download_movie(url) --> inner(url)
download_movie('https://www.baidu.com')


# 问题4: 假如有多个参数
def download_movie(url):
    print(f'{url}中的电影开始下载了...')
    # 模拟电影下载时间 3秒
    time.sleep(3)  # 等待3秒
    print('电影下载成功...')
    return '小泽.mp4'

def download_movie2(url1, url2, url3):
    print(f'{url}中的电影开始下载了...')
    # 模拟电影下载时间 3秒
    time.sleep(3)  # 等待3秒
    print('电影下载成功...')
    return '小泽.mp4'


def time_record(func):  # func <-- download_movie
    # url = 'https://www.baidu.com/'

    # 在闭包函数中
    def inner(url):
        # 统计开始
        start_time = time.time()

        res = func(url)  # func(url) ---> download_movie(url)

        # 当被统计的函数执行完毕后，获取当前时间
        end_time = time.time()
        # 统计结束，打印统计时间
        print(f'消耗时间: {end_time - start_time}')
        return res
    return inner


download_movie = time_record(download_movie)

# download_movie(url) --> inner(url)
download_movie('https://www.baidu.com')