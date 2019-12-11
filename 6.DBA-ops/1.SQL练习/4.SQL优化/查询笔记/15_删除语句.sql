/*
		删除语句:(因为删除是删除整行,而不会只删除一个值,所以这里只需要筛选条件即可)
					方式一:
							单表删除:
									DELETE FROM 表名 WHERE 筛选条件 [limit]
							多表删除:
									DELETE 别名 FROM 表名 别名
									[连接类型] JOIN 表名 别名
									ON 连接条件
									WHERE 筛选条件
							(对于多表删除时,必须规定删除哪个表的信息)
					方式二:(删除整个表,清空表,不需要筛选条件)
							TRUNCATE 表名
		两种方式的比较:
					<1>方式一可以规定删除的个数,而方式二是直接清空表(不能加where筛选)
					<2>TRUNCATE删除时的效率略微要高一点,因为不用去筛选
					<3>对于有自增类型的值时:
							①truncate删除信息后就等于清空了表,那么再重新添加信息的时候
										自增的值将会从1开始
							②而对于delete来说,删除了信息后,自增的值会从断点处开始
										(比如删了最后一个值,那么添加值的自增则在删除那个值的基础上自增)
					<4>truncate删除的时候是没有返回值的,而对于delete来说是有返回值(几个信息受到影响)
					<5>truncate删除不能回滚,而delete能够回滚


*/					
USE girls;
SELECT * FROM beauty;
#案例：删除手机号以9结尾的女神信息
DELETE FROM beauty WHERE phone LIKE '%9';


#案例：删除张无忌的女朋友的信息
DELETE g FROM beauty AS g
INNER JOIN boys AS b
ON g.boyfriend_id = b.id
WHERE b.boyName = '张无忌';


#删除最后一个
		DELETE FROM beauty
		WHERE id = 13;





			