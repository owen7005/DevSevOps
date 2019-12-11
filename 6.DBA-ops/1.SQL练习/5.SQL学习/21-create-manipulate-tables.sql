-- 创建和操纵表
-- 创建表
create table customers
(
	cust_id int		not null auto_increment,
	cust_name char(50) not null,
	cust_address char(50) null,
	cust_city char(50) null,
	cust_state char(50) null,
	cust_zip char(50) null,
	cust_country char(50) null,
	cust_contact char(50) null,
	cust_email char(255) null,
	PRIMARY KEY (cust_id)
) ENGINE=INNODB;
create table orders
(
	order_num int not null auto_increment,
	order_state datetime not null,
	cust_id int not null,
	PRIMARY KEY (order_num)
)ENGINE=INNODB;
create table vendors
(
	vend_id	int	not null auto_increment,
	vend_name char(50)	not null,
	vend_address	char(50)	null,
	vend_city char(50)	null,
	vend_state char(5)	null,
	vend_zip	char(10)	null,
	vend_country	char(50) null,
	PRIMARY KEY (vend_id)
)ENGINE=INNODB;
-- 理解NULL，不要把NULL值与空串相混淆。NULL值是没有值，它不是空串。如果指定''(两个单引号，其间没有字符)，这在NOT NULL列中是允许的。空串是一个有效的值，它不是无值。NULL值用关键字NULL而不是空串指定
-- 主键介绍
-- 为创建由多个列组成的主键，应该以逗号分隔的列表给出各列名
create table orderitems
(
	order_num	INT	NOT	NULL,
	order_item	INT	NOT	NULL,
	prod_id	CHAR(10)	NOT	NULL,
	quantity	INT	NOT	NULL,
	item_price	DECIMAL(8,2)	NOT	NULL,
	PRIMARY	KEY (order_num,order_item)
) ENGINE=INNODB;

-- 使用AUTO_INCREMENT
-- AUTO_INCREMENT告诉MySQL，本列每当增加一行时自动增量。每次执行一个INSERT操作时，MySQL自动对该列增量，给该列赋予下一个可用的值。这样给每个行分配一个唯一的cust_id，从而可以用作主键值。
-- 每个表只允许一个AUTO_INCREMENT列，而且它必须被索引
-- 指定默认值
CREATE	TABLE	orderitems
(
	order_num	INT	NOT	NULL,
	order_item	INT	NOT	NULL,
	prod_id	CHAR(10)	NOT	NULL DEFAULT 1,
	item_price DECIMAL(8,2)	NOT	NULL,
	PRIMARY	KEY	(order_num,order_item)
) ENGINE=INNODB;

-- 引擎类型
-- InnoDB是一个可靠的事务处理引擎，它不支持全文本搜索
-- MEMORY在功能等同于MyISAM，但由于数据存储在内存(不是磁盘)中，速度很快（特别适合于临时表）
-- MyISAM是一个性能极高的引擎，它支持全文本搜索，但不支持事务处理。
-- 更新表
-- 这条语句给vendors表增加一个名为vend_phone的列，必须明确其数据类型
ALTER	TABLE	vendors	ADD	vend_phone CHAR(20);
-- 删除刚刚添加的列，可以这样做：
ALTER	TABLE	vendors	DROP	COLUMN	vend_phone;
-- ALTER TABLE的一种常见用途是定义外键
ALTER	TABLE	orderitems	ADD	CONSTRAINT fk_orderitems_orders FOREIGN	KEY	(order_num) REFERENCES	orders	(order_num);

-- 删除表
DROP TABLE customers2;
-- 重命名表
RENAME	TABLE	customers2 TO	customers;
