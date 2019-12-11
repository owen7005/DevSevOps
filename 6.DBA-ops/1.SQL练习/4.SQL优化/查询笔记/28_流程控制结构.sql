/*
流程控制结构:
		顺序结构
		分支结构:
					- if函数
								语法: IF(表达式一,表达式二,表达式三)  如果表达式一为true则执行表达式二,false则执行表达式三
					- case结构
								语法:
										<1> CASE 表达式
												WHEN 常量值一 then 返回值一
												WHEN 常量值二 then 返回值二
												ELSE 返回值三
												END
										<2>CASE 
											 WHEN 条件一 THEN 返回值一[语句一;]
											 WHEN 条件二 THEN 返回值二[语句二;]
											 ELSE 返回值n[语句n;]
											 END [CASE];
								特点:
											<1>如果为返回值类型,那么该结构可以放在任何地方,包括begin,end语句中
											<2>如果为语句,那么该结构只能放在begin,end中,可以单独使用，并且语句后面需要用分号结尾
					- if结构:
								语法:
											if 条件一 then 语句一;
											elseif 条件二 then 语句二;
											else 语句三;
											end if
								注意:只能用在begin end语句中
		循环结构: 
					while:先判断后循环
							语法:
									[标签]:while 循环条件	do
																循环语句
												 end while [标签名];
					repeat:先循环体执行一次再开始判断(类似于do while语句)
							语法:
									[标签]:repeat 
															循环语句
												 until 结束条件
												 END repeat [标签];
					loop:死循环,除非用循环控制语句才能跳出循环
							语法:
									 [标签]:loop
															循环语句
													END loop [标签];
					
			注意:
						<1>对于以上的循环结构,只适用于begin end中
						<2>如果在循环前面加入了标签名,那么在循环后面也需要加入标签名
			循环控制语句:
						<1>leave 相当于break,后面要接标签名,用于直接退出循环
						<2>iterate 相当于continue,后面要接标签名,用于退出本次循环
		
*/
delimiter $
#案例1：创建函数，实现传入成绩，如果成绩>90,返回A，如果成绩>80,返回B，如果成绩>60,返回C，否则返回D
CREATE FUNCTION myf1(grade INT) RETURNS VARCHAR(10)
BEGIN
		DECLARE level CHAR;
		if grade > 90 THEN SET level = 'A';
		elseif grade > 80 THEN SET level = 'B';
		elseif grade > 60 THEN SET level = 'c';
		ELSE SET level = 'D';
		END IF;
		RETURN LEVEL;
END $
#调用
SELECT myf1(50)$




#案例2：创建存储过程，如果工资<2000,则删除，如果5000>工资>2000,则涨工资1000，否则涨工资500
CREATE PROCEDURE myp1(in sal int)
BEGIN
	if sal <2000 THEN DELETE FROM employees WHERE salary = sal;
	elseif sal > 2000 AND sal < 5000 THEN UPDATE employees SET salary = sal+1000 WHERE salary = sal;
	ELSE UPDATE employees SET salary = salary+500 WHERE salary = sal;
	end IF;
END $

CALL myp1(2100)$


#案例1：创建函数，实现传入成绩，如果成绩>90,返回A，如果成绩>80,返回B，如果成绩>60,返回C，否则返回D
CREATE FUNCTION myf2(grades float) RETURNS CHAR
BEGIN
		DECLARE level CHAR;
		CASE	
		WHEN grades > 90 THEN SET level = 'A';
		WHEN grades > 80 THEN SET level = 'B';
		WHEN grades > 60 THEN SET level = 'C';
		ELSE SET level = 'D';
		END CASE;
		RETURN level;
END $

SELECT myf2(56)$




#循环结构
#案例：批量插入，根据次数插入到admin表中多条记录

CREATE PROCEDURE insertMes(in flag int)
BEGIN
		DECLARE count INT DEFAULT 1;
		WHILE count <= flag DO	
				insert into admin (username,password) VALUES(CONCAT('name',count),'0000');
				SET count = count+1;
		END while;
END $
#调用
CALL insertMes(30)$



#案例：批量插入，根据次数插入到admin表中多条记录，如果次数>20则停止
DROP PROCEDURE insertMes;
create procedure insertMes(in flag int)
BEGIN
		DECLARE count  INT default 1;
		a:REPEAT
				INSERT into admin(username,password) VALUES(CONCAT('name',count),'5555');
				SET count = count + 1;
				UNTIL count>20
		END REPEAT a;
END $

CALL insertMes(30)$



#案例：批量插入，根据次数插入到admin表中多条记录，只插入偶数次
use girls;
delimiter $
DROP PROCEDURE insertMes$
create procedure insertMes(in flag int)
BEGIN
		DECLARE count int default 1;
		a:WHILE count < flag DO
				SET count = count + 1;
				IF MOD(count,2)!= 0 THEN ITERATE a;
				END IF;
				INSERT into admin (username,PASSWORD ) VALUES (CONCAT('name',count),'9999');
		END WHILE a;
END $

CALL insertMes(30)$





#------------------------案例-------------------------------------
/*
1、已知表stringcontent
其中字段：
id 自增长
content varchar(20)
向该表插入指定个数的，随机的字符串
*/
DROP TABLE stringcontent$
create TABLE stringcontent(
	id INT PRIMARY KEY auto_increment,
	content varchar(27)
)$

DROP PROCEDURE insertMes$
CREATE PROCEDURE insertMes(in flag INT)
BEGIN
		DECLARE count INT DEFAULT 1;
		DECLARE str VARCHAR(50) DEFAULT 'abcdefghijklmnopqrstuvwxyz';
		DECLARE randStr varchar(27);
		DECLARE randNum INT;
		WHILE count < flag DO	
				SET randNum = ROUND(RAND()*27);
				SET randStr = substr(str,randNum);
				INSERT into stringcontent(content) VALUES (randStr);			
				SET count = count + 1;
		END WHILE;
END $






