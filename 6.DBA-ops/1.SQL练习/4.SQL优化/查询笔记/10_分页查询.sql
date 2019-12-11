/*
		分页查询:
				应用场景:当我们在查询数据的时候,会发现数据有很多,仅仅只想看指定条目和指定索引的数据
			语法:
					SELECT 查询列表
					FROM 表一
					[连接类型] JOIN
					ON 连接条件
					WHERE 查询条件
					GROUP BY 分组字段
					。。。。
					LIMIT index len (index为查询的起始索引,len为查询的个数)
*/
USE myemployees;
#案例1：查询前五条员工信息
SELECT * 
FROM employees
LIMIT 0,5

#案例2：查询第11条——第25条
SELECT *
FROM employees
LIMIT 10,15
	
#案例3：有奖金的员工信息，并且工资较高的前10名显示出来
SELECT * 
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC
LIMIT 0,10



