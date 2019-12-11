/*
	条件查询:
			语法: 在基础查询的基础上添加一个where关键字
				
			分为:
						- 条件表达式查询
								>   <    =    >=    <=    <>(!= 不等于)
						- 逻辑表达式查询
								AND(&&)   OR(||)   NOT(!)
						- 模糊查询
									LIKE
									in
									BETWEEN AND
			LIKE:模糊查询满足要求的,一般与通配符一起使用
					通配符:  
							% -->表示任意个字符(也包括0个)
							_ -->表示任意单个字符
					转义字符: \		
					自定义转义字符: ESCAPE '$'--->该关键字将$设置为转义字符
					用法: WHERE last_name LIKE '%a%'
								WHERE last_name LIKE '__a%'
								WHERE last_name LIKE '%\_%'
								WHERE last_name LIKE '%@_%' ESCAPE '@';  ------> @为转义字符		
			in:查询与in里面的内容相等的信息
					用法:WHERE employee_id in (39,40,41);
					等价于: WHERE employee_id = 39 OR employee_id = 40 OR employee_id = 41;
					注意:这个运算符是相等查询,不能用通配符等
			
			BETWEEN AND:查询满足between A and B中A到B中的内容 ,等价于 A<= xxxx <=B;
											（包含临界值,两个临界值之间不能调换位置）
			
			列名 IS NULL /列名 IS NOT NULL:查询是null或者不是null的值

				
				

*/
USE myemployees;
-- 按条件表达式筛选
#案例1：查询工资>12000的员工信息
SELECT
	*
FROM 
	employees
WHERE
	salary > 12000;

#案例2：查询部门编号不等于90号的员工名和部门编号
SELECT 
	last_name,
	department_id
FROM 
	employees
WHERE
	department_id != 90;


-- 按逻辑表达式筛选

#案例1：查询工资z在10000到20000之间的员工名、工资以及奖金
SELECT 
	last_name,
	salary,
	commission_pct
FROM
	employees
WHERE
	salary > 10000 AND salary < 20000;


#案例2：查询部门编号不是在90到110之间，或者工资高于15000的员工信息
SELECT
	*
FROM
	employees
WHERE
	NOT(department_id >=90 && department_id <= 110) OR salary > 15000;


#-----------模糊查询------------------


-- LIKE

#案例1：查询员工名中包含字符a的员工信息
SELECT
				* 
FROM
			  employees
WHERE
				last_name LIKE '%a%';	

#案例2：查询员工名中第三个字符为e，第五个字符为a的员工名和工资
SELECT 
				last_name,
				salary
FROM
				employees
WHERE
				last_name LIKE '__c_h%';



#案例3：查询员工名中第二个字符为_的员工名
SELECT
				last_name
FROM
				employees
WHERE
				last_name LIKE '_@_%' ESCAPE '@';



-- in


#案例：查询员工的工种编号是 IT_PROG、AD_VP、AD_PRES中其中一个的员工名和工种编号

SELECT
				job_id,
				last_name
FROM
				employees
WHERE
				job_id in ('IT_PROG','AD_VP','AD_PRES');


-- BETWEEN AND

#案例1：查询员工编号在100到120之间的员工信息

SELECT 
				*
FROM 
				employees
WHERE
				employee_id >= 100 AND employee_id <= 120;


SELECT
				*
FROM 
				employees
WHERE
				employee_id BETWEEN 100 AND 120;

-- IS NULL /IS NOT NULL; 

#案例1：查询没有奖金的员工名和奖金率
SELECT 
				last_name,
				commission_pct
FROM
				employees
WHERE
				commission_pct IS NULL;

#案例2：查询有奖金的员工邮箱,奖金率,phone_number
SELECT
				email,
				phone_number,
				commission_pct
FROM
				employees
WHERE
				commission_pct IS NOT NULL;

SELECT  null + 50 AS 结果;
			



