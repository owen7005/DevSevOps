/*
	表的管理:
				- 创建一个表
							CREATE TABLE 表名(列一 类型【(最大长度)】,列二 类型。。。)
				- 删除一个表
							DROP TABLE 表名
				- 修改一个表
							①修改表名
										ALTER TABLE 表名 RENAME TO 新的表名(不用加引号)
							②增加列
										ALTER TABLE 表名 ADD COLUMN 列名 列类型(最大长度) [first/after 列名]
														first:表示将该列添加到第一列,after表示将该列添加到某个列的后面(均意义不大,可以在查询时规定顺序)
							③删除列
										ALTER TABLE 表名 DROP COLUMN 列名
							④修改列(修改列名,修改列的类型/约束)
										ALTER TABLE 表名 CHANGE COLUMN 原列名 新列名 类型(最大长度)
										ALTER TABLE 表名 MODIFY COLUMN 列名 列类型(最大长度)
				- 复制一个表		
							<1>只复制表的结构
										两种方式:
													① create table 表名 like 表名
													② create table 表名
														select * from 表名 where 1=2;
							<2>复制表的一些字段
										create table 表名 
										select 字段一,字段二。。 from 表名 where 1=2
							<3>复制表的结构+数据
										create table 表名 
										select * from 表名
							<4>复制表的结构+部分数据
										create table 表名
										select * from 表名 where 筛选条件


			注意:当我们在客户端往服务器上创建库或者表的时候,会遇到服务器里面已经存在该表或者该库时,需要进行容错性处理
						先删除该表/库
							DROP database IF EXISTS 库名
							DROP table IF EXISTS 表名
						再创建该表/库
							create database 库名
							create table 表名(字段 类型(最大长度/约束)
*/
USE book;
SHOW tables;
#增加一个books表
CREATE TABLE books(
	id INT,
	bookName VARCHAR(20),
	price DOUBLE,
	author_id INT,
	publishDate DATETIME
);
#增加一个作者表
CREATE TABLE author(
	id int,
	author_name VARCHAR(20),
	nation VARCHAR(10)
)

#删除一个表
DROP TABLE books;

#修改表名
ALTER TABLE author RENAME TO book_author;

#增加列
ALTER TABLE book_author ADD COLUMN sex VARCHAR(5);

#删除列
ALTER TABLE book_author DROP COLUMN sex;
DESC book_author;

#修改列名
ALTER TABLE book_author CHANGE COLUMN sex gender VARCHAR(5);

#修改列的类型/约束
ALTER TABLE book_author MODIFY COLUMN gender INT;


#往books表和book_author表里面添加内容
DESC books;
DESC book_author;

INSERT INTO book_author
VALUE(1,'天蚕土豆','中国','男'),
(2,'唐家三少','中国','男'),
(3,'莫默','中国','男');

INSERT INTO books 
VALUE(1,'斗罗大陆',10,2,'2000-1-1'),
(2,'绝世唐门',20,2,'2000-2-1'),
(3,'斗破苍穹',30,1,'2000-3-1'),
(4,'完美世界',40,3,'2000-4-1');

#复制一个books表的结构
CREATE TABLE copy1 LIKE books;
CREATE TABLE copy1_1 
SELECT * FROM books WHERE 0;

#复制books表的结构和所有数据
CREATE TABLE copy2 
SELECT * FROM books;

#复制books表的结构和部分数据
CREATE TABLE copy3 
SELECT * FROM books WHERE author_id = 2;

#复制表的部分结构
CREATE TABLE copy4
SELECT bookName,price
FROM books
WHERE 0;
























