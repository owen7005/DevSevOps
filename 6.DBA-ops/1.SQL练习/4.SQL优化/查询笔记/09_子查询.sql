USE myemployees;
/*
	子查询:
		含义:利用select查询的嵌套,也就是出现在了其他语句中的select语句,则该查询称为子查询
						那么包含在外面的则为主查询
		分类:
				按出现位置分:
								<1>SELECT 关键字后面
								<2>FROM 关键字后面
								<3>WHERE/HAVING关键字后面
								<4>EXISTS关键字后面
												语法: SELECT EXISTS(完整的查询语句)  
																---->EXISTS关键字查询到的结果为一个数值,如果里面的查询有结果则为1,没有结果则为null
				按子查询得出的结果集的行列数的不同:
								<1>标量子查询(即只有一个数据,一行一列)
													标量子查询中获取的结果是一行一列,也就是说只有一个数据,一般与单行操作符连用
														(> < >= <= = <>等)
								<2>列子查询(一列多行)
													列子查询获取的结果是一列多行,一般与多行操作符一起使用(IN/NOT IN , ANY/SOME , ALL)
													IN/NOT IN:数据是否是其中任意一个
													ANY/SOME:是否满足其中任意一个
													ALL:是否满足里面所有的				
								<3>行子查询(一行多列)
													一般用于当两者都是同一条件比较符时
								<4>表子查询(一般为多行多列)
							
总结:
		对于子查询来说:只不过把子查询select查出的结果作为了条件或者比较值
	
*/
#--------------------WHERE/HAVING后面--------------------------

#----标量子查询
#案例2：返回job_id与141号员工相同，salary比143号员工多的员工 姓名，job_id 和工资

#选中141号员工的job_id
SELECT
			job_id
FROM
			employees AS e
WHERE
			e.employee_id = 141;
#选中143号员工的工资
SELECT
			salary 
FROM
			employees AS e
WHERE
			e.employee_id = 143
#最终查询
SELECT
			last_name,job_id,salary
FROM
			employees AS e
WHERE e.job_id = (
				SELECT
					job_id
				FROM
							employees AS e
				WHERE
							e.employee_id = 141
)
AND	e.salary > (
				SELECT
							salary 
				FROM
							employees AS e
				WHERE
							e.employee_id = 143
);

#案例3：返回公司工资最少的员工的last_name,job_id和salary
#查询员工工资最低为多少
SELECT
			MIN(salary)
FROM
			employees;
#------
SELECT
			last_name,job_id,salary
FROM
			employees
WHERE salary = (
		SELECT
			MIN(salary)
		FROM
					employees
);
		
#案例4：查询最低工资大于50号部门最低工资的部门id和其最低工资

#查询50号部门最低工资
SELECT
			MIN(salary)
FROM
			employees
WHERE
			department_id = 50;
#------
SELECT
			department_id,MIN(salary)
FROM
			employees
GROUP BY
			department_id
HAVING MIN(salary) > (
			SELECT
						MIN(salary)
			FROM
						employees
			WHERE
						department_id = 50
);

#----列子查询

#案例1：返回location_id是1400或1700的部门中的所有员工姓名

-- 查询location_id是1400或者1700的部门所有员工姓名
SELECT
			d.location_id,last_name
FROM
			departments AS d
INNER JOIN
			employees AS e
ON
			d.department_id = e.department_id
WHERE
			d.location_id IN (1400,1700);
			

SELECT DISTINCT department_id
FROM departments
WHERE location_id IN(1400,1700)


SELECT last_name
FROM employees
WHERE department_id  <>ALL(
	SELECT DISTINCT department_id
	FROM departments
	WHERE location_id IN(1400,1700)


);




#案例2：返回其它工种中比job_id为‘IT_PROG’工种任一工资低的员工的员工号、姓名、job_id 以及salary

SELECT
			employee_id,last_name,job_id,salary
FROM
			employees
WHERE employees.job_id <> 'IT_PROG'
AND		employees.salary < ANY(
			SELECT
						salary
			FROM
						employees AS e
			WHERE
						e.job_id = 'IT_PROG'
);

-- 或者 -------
SELECT
			employee_id,last_name,job_id,salary
FROM
			employees
WHERE employees.job_id <> 'IT_PROG'
AND		employees.salary < (
			SELECT MAX(salary)
			FROM	employees
			WHERE employees.job_id = 'IT_PROG'
);


#案例3：返回其它工种中比job_id为‘IT_PROG’工种所有工资都低的员工   的员工号、姓名、job_id 以及salary

#选取job_id为'IT_PROG'的部门
SELECT
	department_id,MIN(salary)
FROM
	employees
WHERE
	job_id = 'IT_PROG'
GROUP BY department_id;

		
SELECT
		employee_id,last_name,job_id,salary
FROM
		employees
WHERE	department_id NOT IN(
		SELECT department_id
		FROM employees
		WHERE	job_id = 'IT_PROG'
)AND salary < (
		SELECT
			MIN(salary)
		FROM
			employees
		WHERE
			job_id = 'IT_PROG'
		GROUP BY department_id
);
-- 或者 -------

SELECT
			salary
FROM
			employees
WHERE
			job_id = 'IT_PROG';



SELECT
			employee_id,last_name,job_id,salary
FROM
			employees
WHERE job_id <> 'IT_PROG'
AND		salary < ALL(
			SELECT
						salary
			FROM
						employees
			WHERE
						job_id = 'IT_PROG'
)


	#--------------------SELECT后面--------------------------

#案例：查询每个部门的员工个数
SELECT	d.*,(
	SELECT
				COUNT(*) 员工个数
	FROM
				employees AS e
	WHERE
				e.department_id = d.department_id
)
FROM		departments d;



#查询员工号=102的部门名
SELECT	(
	SELECT department_name
	FROM
				departments AS d
	INNER JOIN
				employees AS e
	ON
				d.department_id  = e.department_id
	WHERE
				e.employee_id = 102
)	
	


	#--------------------FROM后面--------------------------

#案例：查询每个部门的平均工资的工资等级
#查询每个部门的平均工资
SELECT department_id AS 部门,AVG(salary) AS 平均工资
FROM employees
GROUP BY department_id
#查询工资等级
SELECT 部门,平均工资,grade_level AS 工资等级
FROM (
			SELECT department_id AS 部门,AVG(salary) AS 平均工资
			FROM employees
			GROUP BY department_id
) AS tab1
INNER JOIN job_grades AS g
ON 	tab1.平均工资 BETWEEN g.lowest_sal AND g.highest_sal	
ORDER BY 工资等级



	#--------------------EXISTS后面--------------------------

SELECT	exists(
	SELECT last_name
	FROM myemployees.employees
	WHERE employee_id = 100
)


USE girls;

#案例2：查询没有女朋友的男神信息
SELECT DISTINCT b.*
FROM boys AS b
LEFT JOIN beauty AS g
ON b.id = g.boyfriend_id
WHERE	g.id IS NULL
			


USE myemployees;

#1.	查询和Zlotkey相同部门的员工姓名和工资
SELECT last_name,salary
FROM	employees AS e
WHERE e.department_id = (
		SELECT department_id
		FROM employees
		WHERE last_name = 'Zlotkey'
)
		

#2.查询工资比公司平均工资高的员工的员工号，姓名和工资。
SELECT e.employee_id,e.last_name,e.salary
FROM employees AS e
WHERE e.salary > (
		SELECT AVG(salary)
		FROM employees
)				


#3.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资

#获取每个部门的平均工资

-- ------------------
SELECT em.employee_id,em.last_name,em.salary,em.department_id
FROM employees AS em
INNER JOIN (
		SELECT	e.department_id,AVG(salary) AS 平均工资
		FROM employees AS e
		GROUP BY e.department_id
) AS newT
ON em.department_id = newT.department_id
WHERE em.salary > newT.平均工资


#4.	查询姓名中包含字母u的员工在相同部门的员工的员工号和姓名
#查询姓名中包含字母u的员工的部门
SELECT department_id,last_name
FROM employees AS e
WHERE e.last_name LIKE '%u%';
#查询结果一中的部门中的员工号和姓名
SELECT employee_id,last_name
FROM employees
WHERE  department_id in(
	SELECT DISTINCT e.department_id
	FROM employees AS e
	WHERE e.last_name LIKE '%u%'
)		;

#5. 查询在部门的location_id为1700的部门工作的员工的员工号
#查询location_id为1700的部门
SELECT department_id
FROM departments
WHERE location_id = 1700;

#查询在结果一显示的部门中工作的员工的员工号
SELECT	employee_id
FROM employees
WHERE department_id = ANY(
	SELECT department_id
	FROM departments
	WHERE location_id = 1700
)

#6.查询管理者是King的员工姓名和工资
#查询管理者是King的员工id
SELECT employee_id
FROM employees
WHERE last_name = 'K_ing'
				

#查询管理者id为结果1中的
SELECT	last_name,salary
FROM employees
WHERE manager_id in (
	SELECT employee_id
	FROM employees
	WHERE last_name = 'K_ing'
)
				
#7.查询工资最高的员工的姓名，要求first_name和last_name显示为一列，列名为 姓.名
#查询工资最高为多少
SELECT MAX(salary)
FROM employees
#查询工资为结果一的员工
SELECT CONCAT(first_name,last_name) AS '姓.名'
FROM employees
WHERE salary = (
	SELECT MAX(salary)
	FROM employees
)
   


