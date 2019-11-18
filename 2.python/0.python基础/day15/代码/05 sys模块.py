import sys
import os

# 获取当前的Python解释器的环境变量路径
print(sys.path)

# 将当前项目添加到环境变量中
BASE_PATH = os.path.dirname(os.path.dirname(__file__))
sys.path.append(BASE_PATH)

# 获取cmd终端的命令行  python3 py文件 用户名 密码
print(sys.argv)  # 返回的是列表['']



