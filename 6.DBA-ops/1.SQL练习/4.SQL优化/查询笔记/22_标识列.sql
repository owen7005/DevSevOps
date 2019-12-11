/*
	标识列:(也叫自增列)
			语法: 
					CREATE TABLE 表名(
							字段名 字段类型[字段长度] 主键/唯一键 auto_increment
					)
			通过 SHOW variables LIKE '%auto_increment%'语句,我们可以获取有关自增的两个变量
				变量(auto_increment_increment):自增的步长
				变量(auto_increment_offset):自增的起始值
			改变步长: SET auto_increment_increment = 2
			改变起始值: SET auto_increment_offset = 10 注意:即使变量里面改变了,但是其实不会生效的！
				总结:步长可以改变,起始值不能改变,只能通过自己主动添加第一个值来控制起始值
		特点:
				<1>自增列必须与约束键一起使用,否则会报错
				<2>在整个表的结构中,自增只能有一个
				<3>可以改变自增的起始值和步长
				<4>自增只能用于数据类型是数值型的字段
		删除标识符:
					ALTER TABLE 表名 MODIFY COLUMN 字段名 字段类型[字段长度] 约束键
*/

CREATE DATABASE IF NOT EXISTS test;

USE test;


DROP TABLE IF EXISTS stu;
CREATE TABLE stu(
	id INT UNIQUE auto_increment,
	NAME VARCHAR(10)
);
DESC stu;
SHOW INDEX FROM stu;
SELECT * FROM stu;

SHOW VARIABLES LIKE '%auto_increment%';
SHOW INDEX FROM stu;
SET auto_increment_increment = 1;
SET auto_increment_offset = 1;

INSERT INTO stu(name) VALUE 
('张三'),('李四'),('王五')
INSERT INTO stu(id,name) VALUE
(4,'二狗');

ALTER TABLE stu MODIFY COLUMN id INT PRIMARY KEY;
ALTER TABLE stu DROP INDEX id;












