'''
补充: 函数对象优雅取代if分支
'''

# ATM 100个功能
def login():
    pass

def register():
    pass


# 功能字典容器
func_dic = {
    '1': login,
    '2': register,
}

choice = input('请输入功能名字: ').strip()

if choice in func_dic:
    # 尽可能使用dict.get方式取值
    func_dic.get(choice)()

#
# if choice == 'login':
#     login()
# elif choice == 'register':
#     register()
# else:
#     print('输入错误!')