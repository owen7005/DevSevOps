/*
		分组查询:
				将类型一样的分为一组,然后再对该组进行统计
		语法:
				SELECT 
							分组函数,分组的字段
				FROM 
							表名
				WHERE 		
							条件语句
				GROUP BY 分组的字段
分组前查询:则条件放在where中
分组后查询:则条件放在having中

*/

USE myemployees;
/*引入：查询每个部门的员工个数
SELECT 
			COUNT(job_id),department_id
FROM
			employees
GROUP BY 
			department_id;

#案例1：查询每个工种的员工平均工资
SELECT
			avg(salary),job_id
FROM 
			employees
GROUP BY 
			job_id;

#案例2：查询每个位置的部门个数
SELECT 
			COUNT(*),location_id
FROM
			departments
GROUP BY 
			location_id;

#案例1：查询邮箱中包含a字符的 每个部门的最高工资
SELECT
			MAX(salary),department_id
FROM
			employees
WHERE
			email LIKE '%a%'
GROUP BY
			department_id;


#案例2：查询有奖金的每个领导手下员工的平均工资

SELECT
			AVG(salary),manager_id
FROM
			employees
WHERE
			commission_pct is NOT NULL
GROUP BY manager_id;

#案例：查询哪个部门的员工个数>5
SELECT
			count(*) 个数,department_id
FROM
			employees
GROUP BY
			department_id

HAVING
		 count(*)>5

#案例2：每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
SELECT
			MAX(salary),job_id
FROM
			employees
WHERE
			commission_pct is not null
GROUP BY
			job_id
HAVING
			MAX(salary) > 12000;

#案例3：领导编号>102的每个领导手下的最低工资大于5000的领导编号和最低工资
SELECT
			MIN(salary),manager_id
FROM
			employees
WHERE
			manager_id >102
GROUP BY
			manager_id
HAVING
			MIN(salary) > 5000;

#案例：每个工种有奖金的员工的最高工资>6000的工种编号和最高工资,按最高工资升序
SELECT
			MAX(salary),job_id
FROM
			employees
WHERE
			commission_pct IS NOT NULL
GROUP BY
			job_id
HAVING
			MAX(salary) > 6000
ORDER BY
			MAX(salary) asc;

#案例：查询每个工种每个部门的最低工资,并按最低工资降序

SELECT
			MIN(salary),job_id,department_id
FROM
			employees
GROUP BY
			department_id,job_Id
ORDER BY
			min(salary) DESC;


#1.查询各job_id的员工工资的最大值，最小值，平均值，总和，并按job_id升序
SELECT
			MAX(salary),MIN(salary),AVG(salary),SUM(salary),job_id
FROM
			employees
GROUP BY
			job_id
ORDER BY
			job_id;
#2.查询员工最高工资和最低工资的差距（DIFFERENCE）
SELECT
			(MAX(salary)-MIN(salary)) AS DIFFERENCE
FROM
			employees;
#3.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT
			MIN(salary),manager_id
FROM
			employees
WHERE
			manager_id is NOT NULL
GROUP BY
			manager_id
HAVING
			MIN(salary) >= 6000;

#4.查询所有部门的编号，员工数量和工资平均值,并按平均工资降序
SELECT
			department_id,COUNT(*) AS 人数,AVG(salary) AS 平均工资
FROM
			employees
GROUP BY
			department_id 
ORDER BY
			平均工资 DESC;
#5.选择具有各个job_id的员工人数

SELECT
			COUNT(*),job_id
FROM
			employees
GROUP BY
			job_id;


*/