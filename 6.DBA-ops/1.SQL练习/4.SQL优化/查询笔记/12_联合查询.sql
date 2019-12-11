/*
	联合查询:用于查询多个表中的相同信息,并且这多个表中没有连接条件
			语法:
							SELECT 查询列表 FROM 表 WHERE 查询条件 . . . .
							UNION [ALL] 
							SELECT 查询列表 FROM 表 WHERE 查询条件 . . . .
			ALL关键字用于规定合并查询的时候不进行去重操作,因为默认是去重的
			特点:
					<1>联合查询可以对两个表示相同信息但是查询列表名不同的表进行查询合并
					<2>查询列表必须保持一致的个数,而顺序最好是一致的,这样查询出来的结果
									才能对应的上指定的列表名
*/


#案例：查询中国用户中男性的信息以及外国用户中年男性的用户信息

SELECT id,cname FROM t_ca WHERE csex='男'
UNION ALL
SELECT t_id,tname FROM t_ua WHERE tGender='male';