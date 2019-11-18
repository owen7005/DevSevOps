# 看见一个小姐姐，是否上去要微信

gender = 'female'
age = 29
is_beautiful = True

# if gender == 'female' and 24 > age > 18 and is_beautiful:
#     print("小姐姐，给个微信")
# # 在这个流程控制语句中可以加n多个elif
# elif gender == 'female' and 30 > age > 18 and is_beautiful:
#     print("认识一下")
# else:  # 条件不成立将要执行的代码块
#     print('打扰了')


if gender == 'female' and 24 > age > 18 and is_beautiful:
    print("小姐姐，给个微信")
# 在这个流程控制语句中可以加n多个elif
elif gender == 'female' and 30 > age > 18 and is_beautiful:
    print("认识一下")
elif 30 > age > 18 and is_beautiful:
    print("认识一下")
else:  # 条件不成立将要执行的代码块
    print('打扰了')

