#USE myemployees;
/*
	排序查询:对选择出来的值进行特定的顺序排放
			排序对象:单个字段,多个字段,表达式,函数 
		
	语法:	ORDER BY 字段名/表达式/函数 ASC(默认值,升序)/DESC(降序),字段名 ASC/DESC;
					当进行多个字段查询的时候,按照从左到右的顺序进行查询,然后对前面字段查询中出现的相同数据再进行下面的查询		

			对多个字段排序:查询员工信息，要求先按工资降序，再按employee_id升序
											按照工资降序后,对工资相同的进行按employee_id升序排序

	LENGTH(str):返回字段的长度

*/
USE myemployees;
##1、按单个字段排序
SELECT 
				*
FROM 
				employees
ORDER BY salary;
#添加筛选条件
#案例：查询部门编号>=90的员工信息，并按员工编号降序
SELECT
				*
FROM 
				employees
WHERE 
				department_id >=90
ORDER BY 
				employee_id DESC;



#案例：查询员工信息 按年薪降序
SELECT
				*,salary*12*(1+IFNULL(commission_pct,0))  AS 年薪
FROM
				employees
ORDER BY 
				salary*12*(1+IFNULL(commission_pct,0)) DESC;

#按函数排序
#案例：查询员工名，并且按名字的长度降序
SELECT
				last_name,LENGTH(last_name)
FROM
				employees
ORDER BY
				LENGTH(last_name) DESC;


#按多个字段排序
#案例：查询员工信息，要求先按工资降序，再按employee_id升序
SELECT
				*
FROM
				employees
ORDER BY
				salary DESC,employee_id;


#1.查询员工的姓名和部门号和年薪，按年薪降序 按姓名升序
SELECT
				last_name,department_id,salary*12*(IFNULL(commission_pct,0)) AS 年薪
FROM
				employees
ORDER BY
				年薪 DESC,last_name;

#2.选择工资不在8000到17000的员工的姓名和工资，按工资降序

SELECT
				last_name,salary
FROM
				employees
WHERE
				NOT(salary BETWEEN 8000 AND 17000)
				#salary < 8000 || salary > 17000
ORDER BY
				salary DESC;


##3.查询邮箱中包含e的员工信息，并先按邮箱的字节数降序，再按部门号升序
SELECT
				*
FROM
				employees
WHERE
				email LIKE '%e%'
ORDER BY
				LENGTH(email) DESC,department_id ASC;







