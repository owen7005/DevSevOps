# 在表白的基础上继续：
# 如果表白成功，那么：在一起
# 否则：打印。。。

gender = 'female'
age = 20
is_beautiful = True
is_success = True

if gender == 'female' and 24 > age > 18 and is_beautiful:
    print("小姐姐，给个微信")
    if is_success:
        print("在一起")
    else:
        print('滚')
# 在这个流程控制语句中可以加n多个elif
elif gender == 'female' and 30 > age > 18 and is_beautiful:
    print("认识一下")
else:  # 条件不成立将要执行的代码块
    print('打扰了')