/*
	变量:
			系统变量
					- 全局变量
					- 会话变量
					语法:
							查看所有的系统/会话变量
										SHOW global/[session] variables;
							查看部分的系统/会话变量
										SHOW global/[session] variables LIKE 模糊查询;
							查看单个的系统/会话变量
										SELECT @@global/[SESSION].变量
							设置系统/会话变量
							SET @@global/[session].变量名 = 变量值 
					总结:对于全局变量来说,设置之后不管什么时候打开客户端值都是上次设置的,除非重启mysql
								对于会话变量来说,更改后只会影响当前会话
								全局变量的设置不会影响当前会话变量,但是当重新打开客户端后会话变量会同步全局变量
			
			自定义变量(要求声明的时候赋值)
						- 用户变量(类似于会话变量,只在当前会话有效,一旦重启客户端则失效)
											创建变量:
													SET @用户变量 = 变量值
													SET @用户变量 := 变量值
													SELECT @用户变量 := 变量值   -->必须加冒号,否则会当做查询语句
											修改变量:
													SET @用户变量 = 变量值
													SET @用户变量 := 变量值
													SELECT @用户变量 := 变量值
											
													SELECT 字段名 into @变量名
													FROM 表名 WHERE 筛选条件。。。
											 使用变量:
														SELECT @变量名;
										使用位置: 任何地方,包括在begin,END语句中

					- 局部变量(定义在begin..end语句中, 作用范围也被限定在之间)					
											创建变量:
														declare 变量名 变量类型
														declare 变量名 变量类型 [DEFAULT 变量值]  
											修改变量:
															SET 变量名 = 变量值
															SET 变量名 := 变量值
															SELECT @变量名 := 变量值  ---> 必须要@符号
				
															SELECT 字段 INTO 变量名
															FROM 表名 WHERE 筛选条件

											使用变量
															SELECT 变量名

*/
#查看所有的全局变量
	SHOW GLOBAL variables; 
#查看所有的会话变量
	SHOW session variables;
	SHOW variables;


#查看部分的全局变量
	SHOW GLOBAL VARIABLES LIKE '%auto%';
#查看部分的会话变量
	SHOW session variables LIKE '%auto%';
	SHOW variables LIKE '%auto%';


#查看单个的全局变量
	SELECT @@global.transaction_isolation;
#查看单个的会话变量
	SELECT @@session.transaction_isolation;
	SELECT @@transaction_isolation;




#设置全局变量
	SET @@global.transaction_isolation = 'repeatable-read';
#设置会话变量
	SET @@session.transaction_isolation = 'repeatable-read';


SHOW GLOBAL VARIABLES LIKE '%transaction%';
SELECT @@transaction_isolation;

SET @@global.TRANSACTION_isolation = 'repeatable-read';


-- ------------------------------------------------------
#创建用户变量
SET @age = 10;
SET @gender := '女';
SELECT @id := 1;

#查看用户变量
SELECT @age;
SELECT @gender;
SELECT @id;

#修改用户变量
SET @age = 20;
SET @gender := '男';
SELECT @id := 110;





#案例：声明两个变量，求和并打印
DECLARE num1 INT DEFAULT 50;
DECLARE num2 INT;
SET num2 := 60;	

SELECT num1 + num2

















