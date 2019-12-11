create DATABASE exercise;

/*
1.	创建表dept1
NAME	NULL?	TYPE
id		INT(7)
NAME		VARCHAR(25)
*/
create TABLE dept1(id int(7),name varchar(25));
USE exercise;

#2.	将表departments中的数据插入新表dept2中
create TABLE dept2
SELECT *
FROM myemployees.departments;

/*
		#3.	创建表emp5
		NAME	NULL?	TYPE
		id		INT(7)
		First_name	VARCHAR (25)
		Last_name	VARCHAR(25)
		Dept_id		INT(7)
*/
CREATE TABLE emp5(
		id int(7),
		First_name varchar(25),
		Last_name varchar(25),
		Dept_id int(7)
)




#4.	将列Last_name的长度增加到50
ALTER TABLE emp5 MODIFY COLUMN last_name VARCHAR(50);


#5.	根据表employees创建employees2
CREATE TABLE employees2 LIKE myemployees.employees;


#6.	删除表emp5
DROP TABLE emp5;


#7.	将表employees2重命名为emp5
ALTER TABLE employees2 RENAME TO emp5;

#8.在表dept和emp5中添加新列test_column，并检查所作的操作
ALTER TABLE dept2 ADD COLUMN test_column varchar(4);
ALTER TABLE emp5 ADD COLUMN test_column varchar(4);

#9.直接删除表emp5中的列 dept_id
ALTER TABLE emp5 DROP COLUMN test_column;







