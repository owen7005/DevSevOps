#!/usr/bin/env python
# -*- coding:utf-8 -*-

import turtle

"""
turtle.showturtle() # 显示箭头
turtle.pendown()
turtle.circle(100)
"""

# 绘制奥运五环
turtle.width(10)

turtle.color("blue")
turtle.circle(50)

turtle.penup()
turtle.goto(120,0)
turtle.pendown()  

turtle.color("black")
turtle.circle(50)

turtle.penup()
turtle.goto(240,0)
turtle.pendown()

turtle.color("red")
turtle.circle(50)

turtle.penup()
turtle.goto(60,-50)
turtle.pendown()

turtle.color("yellow")
turtle.circle(50)

turtle.penup()
turtle.goto(180,-50)
turtle.pendown()

turtle.color("green")
turtle.circle(50)