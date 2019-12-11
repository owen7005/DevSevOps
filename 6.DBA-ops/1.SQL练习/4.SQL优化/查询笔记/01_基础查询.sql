/*
	基础查询:
			语法:SELECT 。。。;
			特点:
					- 查询的类型有: 字段, 常量值,表达式,函数(多个查询之间用逗号隔开)
			查询字段:
						查询单个字段: SELECT 字段名 FROM 表名;
						查询多个字段: SELECT 字段名1,字段名2 FROM 表名;
						查询全部字段: SELECT  * FROM 表名; 
			查询常量值:
						SELECT 常量值;
			查询表达式:
						SELECT 表达式;
			查询函数:
						SELECT 函数名();   ---> 将函数的返回值查询出来
起别名:
			在正常的查询语法下,在查询类型后面利用 AS 关键字来设置别名,别名中如果有空格,或者关键字的,需要用单引号或者双引号
			SELECT salary AS 工资 from employees;
			SELECT salary AS '工      资' from employees;
去重:
		 SELECT DISTINCT department_id FROM employees; 
+号的作用:只有运算符的作用
			<1>如果两个数值类型  :  会进行相加
			<2>如果一方为数值,一方为字符  :
									- 如果字符以数值开头,则会对数值进行选取,直到遇到非数值,类似于parseFloat
									- 如果字符以非数值开头,则将该字符设置为0再进行相加
cocat():该函数用于拼接查询的字符串

IFNULL(expr1,expr2):如果是expr1是null,则将expre2的值取代null

ISNULL(expr):判断expr是否是null,如果是null,则返回1,不是null则返回0；




	注意:
		<1>查询前最好先进入库	;			
		<2>查询的字段中出现关键字的用反引号来标识
*/
USE myemployees;
#查询单个字段
	select last_name from employees; 
#查询多个字段,用逗号隔开
	select last_name,first_name FROM employees;
#查询全部字段
	select * from employees;
#反引号的作用
	SELECT `salary` from employees;
#查询常量值
	SELECT 100;
#查询表达式
	SELECT 100/10,1000%999;
#查询函数
	SELECT VERSION();
#查询特殊的字段
	-- SELECT `name`,`last age`;
#起别名
	SELECT 100%99 AS 取模;
	SELECT salary AS '工           资'  from employees;
	
#去重
	SELECT DISTINCT department_id FROM employees;
#  +号的作用:
	SELECT 10+50;
	SELECT '110' + 50;
	SELECT '110哈哈' + 50;
	SELECT '哈哈110' + 50;
	SELECT '1哈哈1哈哈0' + 50;
	SELECT '110.1哈哈' + 50;
#concat():
	SELECT CONCAT(last_name,first_name) AS 姓名 FROM employees;


