/*
		分组函数:	
				sum(expr)  MAX(expr)  MIN(expr) avg()  count()
		处理类型:	
					sum(),avg()函数对字符没用,max()和min()对字符都可以生效,count可以处理任意的类型
		特点:
				<1>是否忽略null值:
								所有函数都忽略null值的,因为任何数和null相加都的null,包括count函数
										如果该值是null则不会计算
				<2>与关键字distinct使用时,去重去的是整个一行的内容,那么在之后的计算中这一行也不会参与计算
				<3>用分组函数和其他字段进行查询的时候是有限制的,因为分组函数返回的是一个值,而其他字段返回的是一组值
				
		COUNT(*)/COUNT(1)/COUNT('haha') ---->用于计算行数
					原理:在原本的表中增加一列,在增加的列中填充相同的数,再计算数的个数
*/
USE myemployees;

#sum
SELECT SUM(salary) FROM employees;
SELECT SUM(last_name) FROM employees;
SELECT SUM(IFNULL(commission_pct,0)) FROM employees;


#avg()
SELECT AVG(salary)FROM employees;
SELECT AVG(last_name)FROM employees;
SELECT AVG(commission_pct)FROM employees;
SELECT sum(commission_pct)/35 FROM employees;

#MAX(expr)/MIN(expr)
SELECT MAX(salary) FROM employees;
SELECT MAX(last_name) FROM employees;
SELECT MAX(commission_pct) FROM employees;
SELECT MIN(commission_pct) FROM employees;
#与关键字distinct
SELECT SUM(DISTINCT salary) FROM employees;
SELECT SUM(salary) FROM employees;

SELECT MAX(DISTINCT department_id) FROM employees;
SELECT MAX(department_id) FROM employees;

SELECT  SUM(DISTINCT salary)/107  FROM employees;
SELECT avg(DISTINCT salary) FROM employees;
SELECT avg(salary) FROM employees;

#count详解
SELECT COUNT(commission_pct) FROM employees;
SELECT COUNT(salary) FROM employees;
SELECT COUNT(DISTINCT salary) FROM employees;

#如果要计算多少行,一般里面传入*或者任意数值/任意字符
SELECT COUNT(*) from employees;
#SELECT COUNT(1) from jobs_copy1;




#1.查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary) AS max,MIN(salary) AS min,AVG(salary) avg,SUM(salary) sum from employees;
#2.查询员工表中的最大入职时间和最小入职时间的相差天数 （DIFFRENCE）
SELECT 
		MAX(hiredate),
		MIN(hiredate),
	  (MAX(hiredate) - MIN(hiredate))/1000/60/60/24
from 
		employees;
#3.查询部门编号为90的员工个数
SELECT 
		COUNT(*) 
FROM 
		employees 
WHERE
		department_id = 90;










