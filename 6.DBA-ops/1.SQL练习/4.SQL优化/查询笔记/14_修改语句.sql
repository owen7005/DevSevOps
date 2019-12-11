USE girls;
/*
	修改语句:
			- 单表修改
					语法:
							UPDATE 表名 SET 列名 = 值,列名=值 WHERE 筛选条件
			- 多表修改(因为多表,所以需要涉及到连接查询)			
					语法:
							sql99:
									UPDATE 表名 别名
									inner/left/right JOIN 表名 别名
									set 别名.列表名 = 值
									WHERE 筛选条件
										
				
		
*/
-- 单表查询
UPDATE beauty SET name = '程希',sex = '女' WHERE sex = '男';

-- 多表查询
#案例 1：修改张无忌的女朋友的手机号为114

UPDATE beauty AS g
INNER JOIN boys as b 
ON g.boyfriend_id = b.id
SET g.phone = '114'
WHERE b.boyname = '张无忌'



DESC beauty
SELECT * FROM beauty;


#案例2：修改没有男朋友的女神的男朋友编号都为2号
#查找
SELECT * FROM beauty;
UPDATE beauty g
LEFT OUTER JOIN boys b
ON g.boyfriend_id = b.id
SET g.boyfriend_id = 6
WHERE b.id is null;










