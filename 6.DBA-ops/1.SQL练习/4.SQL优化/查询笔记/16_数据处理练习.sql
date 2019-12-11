USE myemployees;

#2.	显示表my_employees的结构
DESC my_employees
DESC users
SELECT * FROM my_employees;
SELECT * FROM users;
/*
		#3.	向my_employees表中插入下列数据
		ID	FIRST_NAME	LAST_NAME	USERID	SALARY
		1	patel		Ralph		Rpatel	895
		2	Dancs		Betty		Bdancs	860
		3	Biri		Ben		Bbiri	1100
		4	Newman		Chad		Cnewman	750
		5	Ropeburn	Audrey		Aropebur	1550
*/
INSERT INTO my_employees
VALUE (1,'patel','Ralph','Rpatel',895),
(2,'Dancs','Betty','Bdancs',860),
(3,'Biri','Ben','Bbiri',1100),
(4,'Newman','Chad','Cnewman',750),
(5,'Ropeburn','Audrey','Aropebur',1550);
/*
		#4.	 向users表中插入数据
		1	Rpatel	10
		2	Bdancs	10
		3	Bbiri	20
		4	Cnewman	30
		5	Aropebur	40
*/
insert INTO users
VALUE (1,'Rpatel',10),
(2,'Bdancs',10),
(3,'Bbiri',20),
(4,'Cnewman',30),
(5,'Aropebur',40);

#5.将3号员工的last_name修改为“drelxer”
UPDATE my_employees SET last_name = 'drelxer' WHERE id = 3;


#6.将所有工资少于900的员工的工资修改为1000
SELECT * FROM my_employees;
SELECT * FROM users;
UPDATE  my_employees
SET salary = 1000
WHERE salary < 900


#7.将userid 为Bbiri的user表和my_employees表的记录全部删除
DELETE u,e 
FROM users AS u
INNER JOIN my_employees AS e
ON u.id = e.id
WHERE u.userid = 'Bbiri';

#8.删除所有数据
TRUNCATE my_employees;
TRUNCATE users;



