# -*- coding:utf-8 -*-

class Student:  # 类名首字母大写,多个单词采用驼峰原则.

    def __init__(self,name,score):  # self必须位于第一个参数
        self.name = name 
        self.score = score 

    def say_score(self):   # self必须位于第一个参数
        print("{0}的分数是: {1}".format(self.name,self.score))


a = Student("Jacky",98)
a.say_score()

# self指的是对象本身.
     