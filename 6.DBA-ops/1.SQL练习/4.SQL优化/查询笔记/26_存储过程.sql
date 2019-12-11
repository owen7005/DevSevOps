/*
delimiter 符号:该关键字用于设置mysql的分隔符,默认是分号,当多条语句中需要用到分号的时候,我们需要将分隔符设置为其他的
存储过程:其实就是保存了多条SQL语句的集合体,类似于函数的封装
			语法:(在此之前需要将分隔符重新设置)
						CREATE PROCEDURE 存储过程名(形参列表) 
						BEGIN 
								存储过程体
						END 分隔符
			调用: CALL 存储过程名(实参)
			注意:经过测试,我们发现在存储过程中用到的变量以就近原则为准,即先查找形参,再看SQL语句中有关表的相对应的名字
			形参分为以下模式:
						- in模式:需要调用者传入一个实际的参数来供存储过程体使用
						- out模式:该参数将作为返回值返回
						- inout模式:既是由调用者传入实际参数来使用,也是函数的返回值
			删除存储过程: DROP PROCEDURE 存储过程名 (注意:不支持一次删除多个)
			查看存储过程的一些信息:show CREATE PROCEDURE 存储过程名

*/

#设置分隔符
delimiter !


# 空参模式
#案例->向admin表中插入五条数据
-- 创建存储过程体
CREATE procedure myp1()
BEGIN
	INSERT into admin(username,password) VALUES
	('Mike','0000'),('Amy','0000'),('mogs','0000'),('tom','0000'),('sdaad','0000');
END!

-- 调用
call myp1()!


#带in模式参数
-- 根据女神名输出对应的男神信息

CREATE PROCEDURE myp2(in gName varchar(20))
BEGIN 
	#获取所有女神名对应的男神信息
	SELECT g.name,b.* 
	FROM beauty AS g
	LEFT JOIN boys AS b
	ON g.boyfriend_id = b.id
	WHERE g.name = gName;
END!

-- 调用
call myp2('柳岩')!

DESC admin;
#创建存储过程,判断用户是否登录成功
#创建一个用户变量用于保存登录次数
SET @countTime!
CREATE PROCEDURE myp6(in username varchar(10),in password varchar(10))
BEGIN 
	SELECT COUNT(*) INTO @countTime
	FROM admin 
	WHERE admin.username = username
	AND admin.password = password;
	SELECT if(@countTime > 0,'登录成功','登录失败') AS 登录状况;
END!

#调用
CALL myp6('lyt','6666')!





#带一个out模式参数
-- 根据女神名返回对应的男神名(先用内连接使用一次)
#定义一个变量用于接受返回值
SET @boyfriend_name!
CREATE PROCEDURE myp9(in gName varchar(20),OUT bName varchar(20))
BEGIN
	SELECT boyName INTO bName
	FROM beauty g
	INNER JOIN boys b
	on b.id = g.boyfriend_id
	WHERE g.name = gName;
END !
 

#调用
CALL myp7('柳岩',@boyfriend_name)!


#带多个out模式参数
#根据女神名返回对应的男神名和魅力值
#创建两个变量
SET @bName='';
SET @bCP=0;
CREATE PROCEDURE myp10(in gName varchar(10),OUT bName varchar(10),OUT userCp INT)
BEGIN
	SELECT b.boyName,b.userCP INTO bName,userCp
	FROM beauty AS g
	INNER JOIN boys AS b
	ON g.boyfriend_id = b.id
	WHERE g.name = gName;
END!

#调用
CALL myp10('柳岩',@bName,@bCP)!


#带inout模式参数
-- #案例1：传入a和b两个值，最终a和b都翻倍并返回
SET @x = 15!
SET @y = 25!
create PROCEDURE myp11(INOUT a INT,INOUT b INT)
BEGIN
		SET a = a*2;
		SET b = b*2;
END!

#调用
CALL myp11(@x,@y)!


#删除存储过程
DROP PROCEDURE myp1;
DROP procedure myp2;
DROP PROCEDURE myp3,myp4;  -- 不支持

#查看存储过程的一些信息
SHOW CREATE PROCEDURE myp3;



##四、创建存储过程或函数实现传入一个日期，格式化成xx年xx月xx日并返回
create PROCEDURE myp5(in date datetime,out mydate varchar(20))
BEGIN
	select DATE_FORMAT(date,'%Y年%m月%d日') INTO mydate;
END $

CALL myp4(NOW(),@mydate)$


/*
五、创建存储过程或函数实现传入女神名称，返回：女神 and 男神  格式的字符串
如 传入 ：小昭
返回： 小昭 AND 张无忌
*/
create procedure myp6(in gName varchar(20),OUT str varchar(20))
BEGIN
		DECLARE boyName varchar(20);
		#根据女神名查询男神名
		select b.boyName into boyName
		FROM beauty as g
		inner JOIN boys as b
		ON b.id = g.boyfriend_id
		WHERE g.name = gName;
		#拼接
		set str = CONCAT(gName,' and ',boyName);
END $
SET @returnName = ''$

CALL myp6('小昭',@returnName)


#六、创建存储过程或函数，根据传入的条目数和起始索引，查询beauty表的记录
DROP procedure myp7$
CREATE PROCEDURE myp7(in indexs INT, in lengths INT)
BEGIN
		select b.* 
		from beauty as b
		LIMIT indexs,lengths;
END $

CALL myp7(0,3)$
























