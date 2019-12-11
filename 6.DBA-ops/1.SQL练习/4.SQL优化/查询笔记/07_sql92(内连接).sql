/*
	连接查询:(又称多表查询)
			按年份分:
						- sql92:仅仅支持内连接和外连接的一小部分
						- sql99:支持内连接,外连接(除了全外连接),交叉连接
			按功能分:
						- 内连接
									- 等值连接:将两个表和为一个表,并且根据连接条件,将表之间的数据进行放置									
									- 非等值连接:对两个表中进行非相等值的匹配
									- 自连接:自身的表中进行匹配,将一个表分成两个相同的表,用别名区分
						- 外连接
									- 左外连接
									- 右外连接
									- 全外连接
						- 交叉连接
			查询的顺序是先对from后面的进行查询,即先进入表
 为表起别名:
			<1>使得查询简洁
			<2>区分多个表中有重名的字段
	注意:为表起别名后就不能再用原来的表名去操作

	表的顺序:
				可以进行调换,因为始终都是依次拿一个表的数据去匹配其他表的全部,
				最后两个表的所有数据都会匹配到
	添加筛选:筛选的条件在where后面用and连接
			
92语法和99语法的对比；
				<1> 92语法实现的仅仅为内连接,而99语法实现了更多
				<2> 99语法将连接条件与查询条件进行了分离,可读性更高
*/
/*
USE girls;

#案例1：查询女神名和对应的男神名
SELECT
			beauty.name,boys.boyName
FROM  beauty,boys
WHERE beauty.boyfriend_id = boys.id;

USE myemployees;
#案例2：查询员工名和对应的部门名
SELECT
			e.last_name,d.department_name
FROM
			employees AS e,departments AS d
WHERE
			e.department_id = d.department_id;
#查询员工名、工种号、工种名
SELECT
			e.last_name,e.job_id,j.job_title
FROM
			employees AS e,jobs AS j
WHERE
			e.job_id = j.job_id;

#案例：查询有奖金的员工名、部门名

SELECT
			e.last_name,d.department_name
FROM
			employees AS e,departments AS d
WHERE
			e.department_id = d.department_id

#案例2：查询城市名中第二个字符为o的部门名和城市名
SELECT
			d.department_id,l.city
FROM
			departments AS d,locations AS l
WHERE
			d.location_id = l.location_id
AND
			city LIKE '_o%';


#案例1：查询每个城市的部门个数
SELECT
			COUNT(*),l.city
FROM
			departments AS d,locations AS l
WHERE
			d.location_id = l.location_id
GROUP BY
			l.city;



#案例2：查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT
			d.department_name,d.manager_id,MIN(salary)
FROM
			departments AS d,employees AS e
WHERE
			d.department_id = e.department_id
AND
			e.commission_pct IS NOT NULL
GROUP BY
			department_name;
	

#案例：查询每个工种的工种名和员工的个数，并且按员工个数降序
SELECT
			j.job_title,COUNT(*) as 员工个数
FROM 
			jobs AS j,employees AS e
WHERE
			j.job_id = e.job_id
GROUP BY
			j.job_title
ORDER BY
			员工个数 DESC;


#案例：查询员工名、部门名和所在的城市

SELECT
			last_name,department_name,city
FROM
			employees AS e,departments AS d,locations AS l
WHERE
			l.location_id = d.location_id
AND
			d.department_id = e.department_id;


-- 非等值连接

#案例1：查询员工的工资和工资级别

SELECT
				salary,grade_level
FROM
				employees,job_grades
WHERE
				salary BETWEEN lowest_sal AND highest_sal;


-- 自连接
#案例：查询 员工名和上级的名称
SELECT
			f.last_name,s.last_name
FROM
			employees f,employees s
WHERE
			f.manager_id = s.employee_id;




#作业:
#1.显示所有员工的姓名，部门号和部门名称。

SELECT
		concat(UPPER(substr(last_name,1,1)),substr(last_name,2)) AS 姓名,d.department_id,department_name
FROM
		employees AS e,departments AS d
WHERE
		e.department_id = d.department_id;
 

#2.查询90号部门员工的job_id和90号部门的location_id
SELECT
			e.job_id,e.department_id,d.location_id
FROM
			employees AS e,jobs AS j,departments AS d
WHERE
			e.job_id = j.job_id
AND
			d.department_id = e.department_id
AND
			e.department_id = 90;


#3.	选择所有有奖金的员工last_name , department_name , location_id , city
SELECT
			last_name,department_name,l.location_id,city,commission_pct
FROM
		departments AS d,employees AS e,locations AS l
WHERE
		e.department_id = d.department_id
AND
		l.location_id = d.location_id
AND
		commission_pct IS NOT NULL;


#4.选择city在Toronto工作的员工的last_name , job_id , department_id , department_name 
SELECT	
			last_name,job_id,d.department_id,department_name,city
FROM
			employees AS e,departments AS d,locations AS l
WHERE
			d.department_id = e.department_id
AND
			l.location_id = d.location_id
AND
			city = 'Toronto';


#查询每个工种、每个部门的部门名、工种名和最低工资
SELECT
			department_name,job_title,MIN(salary)
FROM
			departments AS d,jobs AS j,employees AS e
WHERE
			e.department_id = d.department_id
AND
			e.job_id = j.job_id
GROUP BY
			department_name,job_title


#6.查询每个国家下的部门个数大于2的国家编号
SELECT
			country_id,count(*) 部门个数
FROM
		locations

*/

/*
7、选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式
employees	Emp#	manager	Mgr#
kochhar		101	king	100
*/
/*
SELECT
			e.last_name AS employeeName,e.employee_id AS employeeID,m.last_name AS managerName,m.employee_id AS managerID
FROM
			employees AS e,employees AS m
WHERE
			e.manager_id = m.employee_id
*/













