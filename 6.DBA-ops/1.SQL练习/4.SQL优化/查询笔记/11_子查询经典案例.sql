USE myemployees
# 1. 查询工资最低的员工信息: last_name, salary
SELECT last_name,salary
FROM employees
WHERE salary = (
		SELECT MIN(salary)
		FROM employees
)



# 2. 查询平均工资最低的部门信息
-- 查询每个部门的平均工资
SELECT AVG(salary) 平均工资,department_id
FROM employees 
GROUP BY department_id

-- 对结果一中的表进行查询,查询平均工资最低
SELECT MIN(tab.平均工资) 最低工资
FROM (
	SELECT AVG(salary) 平均工资,department_id
	FROM employees 
	GROUP BY department_id
) AS tab
-- 查询平均工资为表二的department_id
SELECT department_id
FROM (
	SELECT AVG(salary) 平均工资,department_id
	FROM employees 
	GROUP BY department_id
)	AS tab2	
WHERE tab2.平均工资 = (
	SELECT MIN(tab.平均工资) 最低工资
		FROM (
			SELECT AVG(salary) 平均工资,department_id
			FROM employees 
			GROUP BY department_id
		) AS tab
)
-- 在departments表中查询department_id 为50的部门信息
SELECT *
FROM departments
WHERE department_id = (
		SELECT department_id
		FROM (
			SELECT AVG(salary) 平均工资,department_id
			FROM employees 
			GROUP BY department_id
		)	AS tab2	
		WHERE tab2.平均工资 = (
			SELECT MIN(tab.平均工资) 最低工资
				FROM (
					SELECT AVG(salary) 平均工资,department_id
					FROM employees 
					GROUP BY department_id
				) AS tab
		)
) 


# 3. 查询平均工资最低的部门信息和该部门的平均工资
SELECT tab3.*,tab4.平均工资
FROM departments AS tab3
INNER JOIN
(
		SELECT AVG(salary) 平均工资,department_id
		FROM employees 
		GROUP BY department_id
) AS tab4
ON tab3.department_id = tab4.department_id		
WHERE tab3.department_id = (
		SELECT department_id
		FROM (
			SELECT AVG(salary) 平均工资,department_id
			FROM employees 
			GROUP BY department_id
		)	AS tab2	
		WHERE tab2.平均工资 = (
			SELECT MIN(tab.平均工资) 最低工资
				FROM (
					SELECT AVG(salary) 平均工资,department_id
					FROM employees 
					GROUP BY department_id
				) AS tab
		)
) 


# 4. 查询平均工资最高的 job 信息
#查询每个job_id的平均工资,并按照从高到底排序
SELECT AVG(salary),job_id
FROM employees
GROUP BY job_id
ORDER BY AVG(salary) DESC
#查询结果一中第一个信息中的job_id
SELECT tab1.job_id
FROM (
	SELECT AVG(salary),job_id
	FROM employees
	GROUP BY job_id
	ORDER BY AVG(salary) DESC
) AS tab1
LIMIT 0,1
#查询job_id 为结果二的jobs信息
SELECT *
FROM jobs
WHERE job_id = (
		SELECT tab1.job_id
		FROM (
			SELECT AVG(salary),job_id
			FROM employees
			GROUP BY job_id
			ORDER BY AVG(salary) DESC
		) AS tab1
		LIMIT 0,1
)


# 5. 查询平均工资高于公司平均工资的部门有哪些?
-- 查询公司平均工资
SELECT AVG(salary)
FROM employees
-- 查询各个部门的平均工资
SELECT AVG(salary) 平均工资
FROM employees AS e
GROUP BY department_id
HAVING 平均工资> (
	SELECT AVG(salary)
	FROM employees
)


# 6. 查询出公司中所有 manager 的详细信息.
#查出公司中所有manager的id
SELECT manager_id
FROM employees
WHERE manager_id IS NOT NULL; 

#查询employee_id是表一的数据
SELECT e.*
FROM employees e
WHERE employee_id in(
		SELECT manager_id
		FROM employees
		WHERE manager_id IS NOT NULL
);




# 7. 各个部门中 最高工资中最低的那个部门的 最低工资是多少
#查询每个部门的最高工资
SELECT MAX(salary)
FROM employees
GROUP BY department_id
#查询表一的最小值
SELECT MAX(salary)
FROM employees
GROUP BY department_id
ORDER BY MAX(salary)
LIMIT 1
#查询最高工资为表二的那个部门id
SELECT tab1.department_id
FROM (
		SELECT MAX(salary) aa,department_id
		FROM employees
		GROUP BY department_id
) AS tab1
WHERE	tab1.aa = (
		SELECT MAX(salary)
		FROM employees
		GROUP BY department_id
		ORDER BY MAX(salary)
		LIMIT 1
)

-- ------------或者----------------
SELECT tab1.department_id
FROM (
		SELECT MAX(salary),department_id
		FROM employees
		GROUP BY department_id
		HAVING MAX(salary) =  (
				SELECT MAX(salary)
				FROM employees
				GROUP BY department_id
				ORDER BY MAX(salary)
				LIMIT 1
		)
) AS tab1;


# 8. 查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
#查询平均工资最高的部门id
SELECT	department_id
FROM employees
GROUP BY department_id
ORDER BY AVG(salary) DESC
LIMIT 0,1
#查询所有的管理者信息
SELECT	*
FROM employees AS tab1
WHERE tab1.employee_id in (
	SELECT manager_id 
	FROM employees
)
#查询结果二中管理者的department_id为结果一的管理者信息
SELECT last_name, department_id, email, salary		
FROM employees AS tab1
WHERE tab1.employee_id in (
	SELECT manager_id 
	FROM employees
)
AND tab1.department_id = (
	SELECT	department_id
	FROM employees
	GROUP BY department_id
	ORDER BY AVG(salary) DESC
	LIMIT 0,1
);
			
























