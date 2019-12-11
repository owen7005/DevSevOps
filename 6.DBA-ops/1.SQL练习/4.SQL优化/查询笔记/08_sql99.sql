USE myemployees;
/*
sql99:注意:当进行外连接的时候,最好使用主键进行连接,防止其他属性中有null的存在
		一、内连接(应用场景:用于匹配两个表之间的交集部分)
					- 等值连接
					- 非等值连接
					- 自连接
		二、外连接(也是用于匹配两个表之间的交集,但同时匹配两个表之间信息不对等的部分)
					左外/右外匹配规则:		
								对两个匹配的表分成主表和附表,LEFT JOIN 左边和Right JOIN 右边的为主表
								将主表依次与附表进行匹配,跟内连接一样,依然需要匹配规则
								将匹配条件下相同的放为一起,匹配条件不能匹配成功的那一行表示附表的部分显示为null							
					- 左外连接
					- 右外连接	
								得到的结果为主表附表的交集,以及主表有的,附表没有的(显示为null)
					- 全外连接(不支持)
								得到的结果为主表附表的交集,以及表一有的,表二没有的(显示为null),
														以及表一没有的,表二有的
		三、交叉连接
					通过99语法实现的笛卡尔乘积(表一的每一项对应表二的每一项,结果为两个表相连)
					等价于92语法中没有给予连接条件

					
							
语法:
			SELECT 
						查询列表
			FROM
						表一 别名
			[连接类型] JOIN	
						表二 别名
			ON	
						连接条件
			WHERE 
						筛选条件....
连接类型:
			内连接:INNER JOIN
			外连接:
						左外连接:LEFT OUTER JOIN
						右外连接:RIGHT OUTER JOIN
						全外连接:FULL JOIN
		  交叉连接:
							CROSS JOIN
内连接特点:
			<1>查询条件放在where后面myemployees,连接条件放在on后面
			<2>连接条件on和表之间紧密相连,当多表查询时,没两个表之间
						用on连接一次
			<3>inner可以省略
*/
-- --------------内连接--------------------
#等值连接

#案例1.查询员工名、部门名
SELECT
			last_name,department_name
FROM
			employees AS e
INNER JOIN
			departments AS d
ON
			d.department_id = e.department_id;

#案例2.查询名字中包含e的员工名和工种名（添加筛选）
SELECT
			last_name,job_title
FROM
			employees AS e
INNER JOIN
			jobs AS j
ON
			e.job_id = j.job_id
WHERE
			last_name LIKE '%e%';

			
#3. 查询部门个数>3的城市名和部门个数，（添加分组+筛选）
#①查询每个城市的部门个数
#②在①结果上筛选满足条件的
SELECT
			count(*) AS 部门个数,city
FROM
			departments AS d
INNER JOIN
			locations AS l
ON
			d.location_id = l.location_id
GROUP BY
			city
HAVING
			部门个数 > 3;


#案例4.查询哪个部门的员工个数>3的部门名和员工个数，并按个数降序（添加排序）
SELECT
			department_name,count(*) AS 员工个数
FROM
			employees AS e
INNER JOIN
			departments AS d
ON
			e.department_id = d.department_id
GROUP BY
			department_name
HAVING
			员工个数 > 3
ORDER BY	
			员工个数 DESC;


#5.查询员工名、部门名、工种名，并按部门名降序（添加三表连接）
SELECT
			last_name,department_name,job_title
FROM
			employees AS e
INNER JOIN
			departments AS d
ON
			e.department_id = d.department_id
INNER JOIN
			jobs j
ON
			e.job_id = j.job_id
ORDER BY
			department_name DESC;

#非等值连接

#查询员工的工资级别
SELECT
			salary,grade_level
FROM
			employees
INNER JOIN
			job_grades
ON
			salary BETWEEN lowest_sal AND highest_sal;

 
#查询工资级别的个数>20的个数，并且按工资级别降序
SELECT
			COUNT(*),grade_level
FROM
			employees
INNER JOIN
			job_grades
ON
			salary BETWEEN lowest_sal AND highest_sal
GROUP BY
			grade_level
HAVING
			COUNT(*) > 20
ORDER BY
			grade_level DESC;

 #查询员工的名字、上级的名字
SELECT
			e.last_name,m.last_name
FROM
			employees AS e
INNER JOIN
			employees AS m
ON
			e.manager_id = m.employee_id;

 #查询姓名中包含字符k的员工的名字、上级的名字
SELECT
			e.last_name,m.last_name
FROM
			employees AS e
INNER JOIN
			employees AS m
ON
			e.manager_id = m.employee_id
WHERE
			e.last_name LIKE '%k%';
			

-- --------------外连接--------------------
 #引入：查询男朋友 不在男神表的的女神名
USE girls;
SELECT 
		g.name
FROM
		beauty AS g
LEFT OUTER JOIN
		boys AS b
ON
		g.boyfriend_id = b.id;

SELECT
		g.name 
FROM
		boys AS b
RIGHT OUTER JOIN
		beauty AS g
ON
		b.id = g.boyfriend_id;

USE myemployees;
#案例1：查询哪个部门没有员工
SELECT
			d.*,e.department_id
FROM
			departments AS d
LEFT OUTER JOIN
			employees AS e
ON
			d.department_id = e.department_id
WHERE
			e.department_id IS NULL;

SELECT
			d.department_name,e.employee_id
FROM
			employees AS e
RIGHT OUTER JOIN
			departments AS d
ON
			e.department_id = d.department_id
WHERE
			e.employee_id is null


#一、查询编号>3的女神的男朋友信息，如果有则列出详细，如果没有，用null填充
SELECT
			g.name,g.id,b.*
FROM
			beauty AS g
LEFT JOIN
			boys AS b
ON
			g.boyfriend_id = b.id
WHERE
			g.id > 3
ORDER BY 
			boyName
			

#二、查询哪个城市没有部门
SELECT
		l.city,d.department_name
FROM
		locations AS l
LEFT JOIN
		departments AS d
ON
		l.location_id = d.location_id
WHERE
		d.department_id is NULL

			
			

#三、查询部门名为Sal或IT的员工信息
SELECT
			e.*
FROM
			departments AS d
LEFT JOIN
			employees AS e
ON
			e.department_id = d.department_id
WHERE
			d.department_name IN ('SAL','IT');


















