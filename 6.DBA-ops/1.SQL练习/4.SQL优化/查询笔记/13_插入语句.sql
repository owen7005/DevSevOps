USE girls;
DESC beauty;
/*
	插入语句:
			方式一(经典方式):
						insert into 表名 (列名,列名。。) value[VALUES] (值1,值2。。)
							<1>往里面插入数据的时候,必须列和值的个数相同,并且
										值应该采用对应的类型,或者兼容的类型
							<2>对于插入的值可以为空的,我们可以采取两种方式解决
										1.在插入该值时以null代替
										2.在列名中不选择该列,,有默认值的会自动采取默认值
							<3>插入信息时的列名的顺序可以随意,但是值必须和列名的顺序相同
							<4>可以插入多条信息,每条信息之间用逗号隔开
			方式二:
						INSERT INTO 表名 
						set 列名=值,列名 = 值
			两种方式的比较:
						<1>第一种方式能够添加多行,而第二种方式不行
						<2>方式一支持子查询,方式二不支持子查询
			对于子查询:
						SELECT 得到的结果集会依次对应列名,然后插入进去

*/
SELECT * FROM beauty;
#往beauty中插入数据
INSERT INTO beauty (id, name,sex,borndate,phone,photo,boyfriend_id)
VALUE (13,'赵小臭','女','1995-1-1','1381385438',NULL,6)

#往beauty中插入数据,列名顺序不一样
INSERT into beauty(name,ID,phone,boyfriend_id) VALUE('杨幂',14,'1388888888',NULL)
INSERT into beauty(name,ID,phone,boyfriend_id) VALUES('asd',12,'55555',NULL)
INSERT into beauty(name,ID,phone,boyfriend_id) VALUE('hsg',13,'66666',NULL)
#插入多条信息
INSERT INTO beauty 
VALUE (15,'王思纯','女',NULL,'110',NULL,8),
			(16,'张美玲','女','1994-1-1','120',NULL,3)

#方式二插入信息
INSERT INTO beauty
SET id = 17,name = '刘涛',phone = '1156420';


#方式一子查询
INSERT INTO beauty(id,name,phone)
SELECT 18,boyname,'1737082'
FROM	boys
WHERE id = 3









