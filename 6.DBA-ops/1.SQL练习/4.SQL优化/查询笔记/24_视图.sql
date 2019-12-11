/*
		视图:是一张动态创建的表,由一组查询语句构成
				应用场景:当我们多次用到同一张虚拟的表的时候,例如两个内连接或者外连接形成的表,
									那么我们就可以把这张表封装成视图,想要使用获取里面数据的时候就可以直接用了
		创建视图:
					CREATE VIEW 视图名
					AS  查询语句
		删除视图:
					DROP VIEW 视图名,视图名...
		修改视图:
					方式一:
								CREATE OR REPLACE VIEW 视图名
								AS 查询语句
					方式二:
								ALTER VIEW 视图名
								AS 查询语句
		查看视图的结构:
				DESC 视图名
				SHOW CREATE VIEW 视图名

		更新视图:(注意:更新视图会影响到原表的信息)
				但是以下情况下是实现不了更新的:
								group by,常量视图,子查询,distinct,join,from一个不能够更新的视图，
								where语句中的子查询中引用了from中的表
					
				总结:一般我们利用视图是来进行查找数据的,所以不会对视图进行修改,而且对于可修改的视图都会设置其权限为只读

	
	

		
*/
#创建两个视图
CREATE VIEW myv1
AS
SELECT last_name,email
FROM myemployees.employees as e
WHERE e.salary > 10000;

SELECT * FROM myv1;
#修改视图
CREATE OR REPLACE VIEW myv1
AS
SELECT last_name,salary
FROM myemployees.employees e
WHERE e.salary > 10000;

ALTER VIEW myv1
AS 
SELECT last_name,salary
FROM myemployees.employees
WHERE salary = 10000;

ALTER VIEW myv1 
AS 
SELECT * FROM myemployees.employees;

DESC myv1;
SHOW CREATE VIEW myv1;


CREATE OR REPLACE VIEW myv1
AS 
SELECT last_name,salary
FROM myemployees.employees
WHERE salary = 10000;

SELECT * from myv1;
SELECT * FROM myemployees.employees;
insert into myv1 VALUES('张飞',9999999);
UPDATE myv1  SET last_name = '刘备'  WHERE salary = 10000 ;

CREATE OR REPLACE VIEW myv1
AS 
SELECT '我来自中国';

DELETE FROM myv1 WHERE 1;
