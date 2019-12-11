/*
	函数:
			含义:一组SQL语句的集合体
	
	函数与存储过程的区别:
				<1>存储过程允许返回多个值,函数仅仅能并且必须返回一个值
				<2>存储过程的形参由三个部分组成(参数模式,形参名,形参类型),而函数只需要两部分(形参名,形参类型)
				<3>在定义函数时必须指明函数返回值的类型
				<4>函数的返回值需要用select来接收, 而存储过程的返回值会被反应到会话变量中
	创建语法:
			create FUNCTION 函数名(形参列表) RETURN 返回类型
			BEGIN
					函数体
			END 分隔符
	调用语法:
		 函数名(实参) 分隔符
注意:函数调用结束后会有返回值

	查看函数:
			show create FUNCTION 函数名
	删除函数:
			DROP FUNCTION 函数名

*/
USE myemployees;
delimiter $
#1.无参有返回
#案例：返回公司的员工个数
DROP FUNCTION sumPerson;
CREATE FUNCTION sumPerson() RETURNS INT
BEGIN
	DECLARE c int DEFAULT 0;
	SELECT COUNT(*) into c
	FROM employees;
	RETURN c;
END $

SELECT sumPerson()$


#2.有参有返回
#案例1：根据员工名，返回它的工资.
CREATE FUNCTION myf1(last_name varchar(20)) RETURNS INT
BEGIN
		DECLARE sal int;
		SELECT salary INTO sal
		FROM employees AS e
		WHERE e.last_name = last_name;
		RETURN sal;
END $

SELECT myf1('Hunold')$

#案例2：根据部门名，返回该部门的平均工资
CREATE FUNCTION myf2(department_name VARCHAR(20)) RETURNS INT
BEGIN
		DECLARE avgSal INT;
		SELECT AVG(salary) into avgSal
		FROM employees AS e
		INNER JOIN departments AS d
		ON d.department_id = e.department_id
		WHERE department_name = d.department_name
		RETURN avgSal;
END $






#案例
#一、创建函数，实现传入两个float，返回二者之和

CREATE FUNCTION myf4(num1 float,num2 float) RETURNS FLOAT
BEGIN
	DECLARE sum INT;
	set sum = num1 + num2;
	RETURN sum;
END $

SELECT myf3(11.1,11.1)$










