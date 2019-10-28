# -*- coding:utf-8 -*-


# 选择结构

# 输入一个学生的成绩,将其转化为简单描述: 不及格(小于60),及格(60-79),良好(80-89),优秀(90-100)
# 方法1
"""
score = int(input("请输入分数:"))
grade = " "
if (score < 60):
    grade = "不及格"
if(60 <= score < 80):
    grade = "及格"
if(80 <= score < 90):
    grade = "良好"
if(90 <= score <= 100):
    grade = "优秀"

print("分数是{0},等级是{1}".format(score,grade))
"""


# 方法二(利用多分支结构)
"""
score = int(input("请输入分数:"))
grade = " "
if score < 60:
    grade = "不及格"
elif score < 80:
    grade = "及格"
elif score < 90:
    grade = "良好"
elif score <= 100:
    grade = "优秀"

print("分数是{0},等级是{1}".format(score,grade))
"""



# 已知点的坐标(x,y),判断其所在的象限
"""
x = int(input("请输入x坐标:"))
y = int(input("请输入y坐标:"))

if (x == 0 and y == 0): print("原点")
elif (x == 0): print("y轴")
elif (y == 0): print("x轴")
elif ( x > 0 and y > 0): print("第一象限")
elif (x < 0 and y > 0): print("第二象限")
elif (x < 0 and y < 0): print("第三象限")
else:
    print("第四象限")
"""



# 输入一个分数,分数在0-100之间,90以上是A,80以上是B,70以上是c,60以上是D,60以下是E。
"""
score = int(input("请输入一个在0-100之间的分数:"))
grade = " "
if score > 100 or score < 0:
    score = int(input("输入错误,请重新输入一个在0-100之间的数字."))
else:
    if score >= 90:
        grade = 'A'
    elif score >= 80:
        grade = "B"
    elif score >= 70:
        grade = "C"
    elif score >= 60:
        grade = "D"
    else:
        grade = 'E'
    print("分数为{0},等级为{1}".format(score,grade))
"""



# 也可以使用代码更少的写法
"""
score = int(input("请输入一个分数:"))
degree = "ABCDE"
num = 0
if score > 100 or score < 0:
    print("请输入一个0-100的分数。")
else:
    num = score // 10
    if num < 6:
        num = 5
    
    print(degree[9-num])

"""



# 循环结构

"""
num = 0
while num <= 10:
    print(num)
    num += 1
"""

# 利用while循环,计算1-100之间数字的累加和; 计算1-100之间偶数的累加和. 计算1-100之间奇数的累加和.
"""
num = 0
sum_all = 0 # 1-100 所有数的累加和.
sum_even = 0 # 1-100 偶数的累加和.
sum_odd = 0  # 1-100 奇数的累加和.
while num <= 100:
    sum_all += num 
    if num % 2 == 0: sum_even += num
    else: sum_odd += num 
    num += 1    # 迭代,改变条件表达式,使循环趋于结束.

print("1-100所有数的累加和:",sum_all)
print("1-100偶数的累加和:",sum_even)
print("1-100奇数的累加和:",sum_odd)
"""




# 测试for循环
"""
for x in (10,20,30):
    print(x*30)

for y in "JackyLi":
    print(y)

# 遍历字典
a = {'name': "Jacky Li",'age': 27,'job': 'devops'}
for i in a:
    print(i) # 默认遍历字典所有的key

for i in a.keys():  # 遍历字典所有的key
    print(i)

for i in a.values(): # 遍历字典所有的value
    print(i)

for i in a.items():  # 遍历字典所有的"键值对"
    print(i)
"""


# 利用for循环,计算1-100之间数字的累加和,计算1-100之间偶数的累加和.计算1-100之间奇数的累加和.
"""
sum_all = 0 # 1-100所有数的累加和
sum_even = 0 # 1-100偶数的累加和.
sum_odd = 0   # 1-100奇数的累加和.

for num in range(101):
    sum_all += num 
    if num%2 == 0: sum_even += num 
    else: sum_odd += num 
    num += 1     # 迭代,改变条件表达式,使循环趋于结束.

print("1-100所有数的累加和:",sum_all)
print("1-100偶数的累加和:",sum_even)
print("1-100奇数的累加和:",sum_odd)

print('#'*30)
"""


"""
sum_all = 0
sum_odd = 0 # 100以内的奇数和
sum_even = 0 # 100以内的偶数和.

for x in range(101):
    sum_all += x 
    if x%2 == 1:
        sum_odd += x
    else:
        sum_even += x 

print("1-100累加总和:{0},奇数和:{1},偶数和:{2}".format(sum_all,sum_odd,sum_even))

print('#'*35)

# 打印图案
for x in range(5):
    for y in range(5):
        print(x,end="\t")
    print()

# 利用嵌套循环打印九九乘法表
for m in range(1,10):
    s = " "
    for n in range(1,m+1):
        # s += str.format("{0} * {1} = {2}\t",m,n,m*n)
    # print(s)
        print("{0} * {1} = {2}".format(m,n,(m*n)),end="\t")
    print()



print('=='*30)

# 使用列表和字典存储表格的数据
a1 = dict(name="Jacky",age = 28,job='devops',city = "北京")
a2 = dict(name="Danille",age = 35,job='cooker',city = "杭州")
a3 = dict(name="Sofi",age = 26,job='actor',city = "深圳")

b1 = [a1,a2,a3]

for i in b1:
    if i.get("age") < 30:
        print(i)



print('=='*30)

# 要求输入员工的薪资,若薪资小于0则重新输入,最后打印出录入员工的数量和薪资明细,以及平均薪资.
empNum = 0
salarySum = 0
salarys = []
while True:
    s = input("请输入员工的薪资(按Q或q结束):")

    if s.upper() == 'Q':
        print("录入完成,退出")
        break 
    if float(s) < 0:
        continue
    empNum += 1
    salarys.append(float(s))
    salarySum += float(s)

print("员工数{0}".format(empNum))
print("录入薪资:",salarys)
print("平均薪资{0}".format(salarySum/empNum))



while True:
    a = input("请输入一个字符(q|Q):")
    if a.upper() == 'Q':
        print("循环结束,退出.")
        break    # 更换为continue 执行查看效果.
    else:
        print(a)


print('=='*30)
"""

# 员工一共4人,录入这4位员工的薪资,全部录入后,
# 打印提示:您已经全部录入4名员工的薪资. 最后,打印输出录入的薪资和平均薪资
"""
salarySum = 0
salarys = []
for i in range(4):
    s = input("请输入一共4名员工的薪资(按Q退出):")
    if s.upper() == 'Q':
        print("录入完成,退出.")
        break
    if float(s) < 0:
        continue

    salarys.append(float(s))
    salarySum += float(s)

else:
    print("您已经全部录入4名员工的薪资")

print("录入薪资:",salarys)
print("平均薪资:{0}".format(salarySum/4))
"""




# 循环代码优化测试:
"""
import time 

start = time.time()
for i in range(1000):
    result = []
    for m in range(10000):
        result.append(i*1000+m*100)

end = time.time()
print("耗时: {0}".format((end-start)))


start2 = time.time()
for i in range(1000):
    result = []
    c = i*1000
    for m in range(10000):
        result.append(c+m*100)

end2 = time.time()
print("耗时: {0}".format((end2-start2)))
"""





# 使用zip()并行迭代
"""
names = ("Jacky","Tom","Benny","Khae","Anniya")
ages = (27,32,30,26,28)
jobs = ("Project Manager","Saleman","cooker","design engineer","building engineer")

for name,age,job in zip(names,ages,jobs):
    print("{0}\t| {1}\t|\t{2}".format(name,age,job))

for i in range(3):
    print("{0}\t| {1}\t|\t{2}".format(names[i],ages[i],jobs[i]))



# 列表推导式
print([x * 2 for x in range(1,20) if x%5 == 0])

cells = [(row,col) for row in range(1,10) for col in range(1,10)]
print(cells)



print("=="*30)
"""

# 全局变量和局部变量效率测试
"""
import math
import time 

def Benn():
    start = time.time()
    for i in range(10000000):
        math.sqrt(30)
    end = time.time()
    print("耗时:{0}".format(end-start))

def Benny():
    b = math.sqrt 
    start = time.time()
    for i in range(10000000):
        b(30)
    
    end = time.time()
    print("耗时:{0}".format(end-start))


Benn()
Benny()
"""



b = [10,20]
def f2(m):
    print("m:",id(m))  # b和m是同一个对象.
    m.append(30)   # 由于m是可变对象,不创建对象拷贝,直接修改这个对象.


f2(b)
print("b:",id(b))
print(b)

print('==='*30)




# 测试浅拷贝
import copy 

a = [10,20,[5,6]]
b = copy.copy(a)

print("a:",a)
print("b:",b)

b.append(30)
b[2].append(7)

print("浅拷贝。。。。")
print("a:",a)
print("b:",b)


print("---"*30)

# 测试深拷贝
def testdeepcopy():
    a = [10,20,[5,6]]
    b = copy.deepcopy(a)

    print("a:",a)
    print("b:",b)
    
    b.append(30)
    b[2].append(7)
    print("深拷贝....")
    print("a:",a)
    print("b:",b)

testdeepcopy()
