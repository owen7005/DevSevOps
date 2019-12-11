## Explain
```
一、是什么
  使用EXPLAIN关键字可以模拟优化器执行SQL查询语句, 从而直到MySQL是如何处理你的SQL语句的, 分析你的查
	询语句或者表结构的性能瓶颈

二、能干嘛
	<1> 表的读取顺序
	<2> 数据读取操作的操作类型
	<3> 哪些索引可以使用
	<4> 哪些索引被实际使用
	<5> 表之间的引用
	<6> 每张表有多少行被优化器查询

三、怎么玩: Explain + SQL语句
		执行计划包含的信息:
			id 	select_type  table  type  possible_keys  key  key_len  ref  rows  Extra

四: 执行计划包含的信息的各个字段分析:
	id: select查询的序列号, 包含一组数字, 表示查询中执行select字句或者操作表的顺序
			分为三种情况:
					id相同, 执行顺序由上至下(表的加载顺序)
					id不同, 如果是子查询, id的序号会递增, id值越大优先级越高, 优先被执行(id越大的表优先加载)
					id相同不同, 同时存在(相同者从上到下加载, 不同者从大到小加载)

	select_type: 查询的类型, 主要用来区别普通查询、联合查询、子查询等的复杂查询
			常见有六个: simple, primary, subquery, derived, union, union result
			simple: 简单的select查询, 查询中不包含子查询或者UNION
			primary: 查询中包含任何复杂的子部分, 最外层查询则标记为primary
			subquery: 在select或者where列表中包含了子查询
			derived: 在From列表中包含的子查询被标记为derived(衍生), mysql会递归执行这些子查询, 把结果
							 放在临时表中
			union: 如果第二个select出现在union之后, 则被标记为union, 若union包含在from字句的子查询中,
						 外层select将被标记为: derived
			union result: 从union表获取结果的select

	table: 显示这一行的数据是关于哪张表的

	type: 显示查询使用了何种类型, 即访问类型, 是较为重要的一个指标
				有七种值, 从最好到最差依次是system > const > eq_ref > ref > range > index > ALL
				system: 表只有一行记录(等于系统表), 这时const类型的特例, 平时不会出现
				const: 表示通过索引一次就找到了, const用于比较primary key 或者unique索引, 因为只匹配一行
							 数据, 所以很快, 如将主键置于where列表中, MySQL就能将该查询转换为一个常量
				eq_ref: 唯一性索引扫描, 对于每个索引键, 表中只有一条记录与之匹配, 常见于主键或唯一索引扫描
				ref: 非唯一性索引扫描, 返回匹配某个单独值得所有行, 本质上也是一种索引访问,  它返回所有匹配
						 单个单独值的行, 然而, 它可能会找到多个符合条件的行, 所以它应该属于查找和扫描的混合体
				range: 只检索给定范围的行, 使用一个索引来选择行, key列显示使用了哪个索引, 一般就是在你的
								where语句中出现了between、<、>、in等的查询, 这种范围扫描索引扫描比全表扫描要好,
								因为它只需要开始于索引的某一点, 而结束于另一点, 不用扫描全部索引
				index: Full Index Scan, index与All区别为index类型只遍历索引树, 这通常比ALL快, 因为索引
							文件通常比数据文件小, 也就是说虽然all和index都是读取全表, 但是index是从索引中读取的,
							而all是从磁盘中读的
				all: Full Table Scan, 将遍历全表以找到匹配的行

	possible key: 显示可能应用在这张表中的索引, 一个或多个, 查询涉及到的字段上若存在索引, 则该索引
								将被列出, 但不一定被查询实际使用

	key: 实际使用的索引, 如果为null, 则没有使用索引, 查询中若使用了覆盖索引, 则该索引仅出现在key列表
			 中(查询两个索引字段, 而不是全部字段)

	key_ len: 表示索引中使用的字节数, 可通过该列计算查询中使用的索引的长度, 在不损失精确性的情况下, 长
				 	 度越短越好, key_len显示的值为索引字段的最大可能长度, 并非实际使用长度, 即ken_len是根据
					 表定义计算而得, 不是通过表内检索出的

	ref: 显示索引的哪一列被使用了, 如果可能的话, 是一个常数, 哪些列或常量被用于查找索引列上的值

	rows: 根据表统计信息及索引选用情况, 大致估算出找到所需的记录所需要读取的行数

	Extra: 包含不适合其它列显示但是又很重要的额外信息
			using filesort: 说明mysql会对数据使用一个外部的索引排序, 而不是按照表内的索引顺序进行读取,
											mysql中无法利用索引完成的排序操作称为"文件排序"
			using temporary: 使用了临时表保存中间结果, MySQL在对查询结果排序时使用临时表, 常见于排序
												order by和分组查询group by
			using index: 表示相应的select操作中使用了覆盖索引, 避免访问了表的数据行, 如果同时出现了
									using where, 表名索引被用来执行索引键值的查找, 如果没有出现using where, 表明
									索引用来读取数据而非执行查找动作
			using where: 表示使用了where过滤数据
			using join buffer:使用了连接缓存(三表inner join)
			impossible where: where字句的值总是false, 不能用来获取任何元组
											  比如where name = x and name = y
			select tables optimized away: 在没有groupby字句的情况下, 基于索引优化MIN/MAX操作或者对于
																		MyISAM存储引擎优化COUNT(*)操作, 不必等到执行阶段再进行计算,
																		查询执行计划生成的阶段即完成优化
			distinct: 优化distinct操作, 再找到第一匹配的元组后即停止找回同样值的动作

覆盖索引(Convering Index): 就是select的数据列只用从索引中就能够取得, 不必读取数据行, MySQL可以利
													用索引返回select列表中的字段, 而不必根据索引再次读取数据文件, 换句话说
													查询列要被所建的索引覆盖
```