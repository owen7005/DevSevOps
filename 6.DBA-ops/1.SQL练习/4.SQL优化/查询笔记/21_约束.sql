/*
	约束:-->六大类型(SHOW INDEX FROM 表名;)
			<1>NOT NULL(非空约束):规定该列的值不能为空
			<2>default(默认值约束):规定一个默认值,当在添加数据未指定时采用默认值
			<3>primary key(主键约束):具有唯一性,并且该列的值不能为空,一般用于学号,姓名等之类的
			<4>unique:具有唯一性,但是该列的值可以为空,一般用于具有唯一性但是可以为null的
			<5>foreign key(外键约束):从表中该列的值必须是主表某列所有值中的一个,使用外键约束可以增加数据的可靠性
			<6>check(检查约束):检查是否符合指定的要求,比如设置该约束为年龄在18-66,那么不在指定范围的数据添加时会报错
	添加约束只允许在两种情况:(前提:数据还没有插入！)
				<1>在创建表的时候	
				<2>	在修改表的时候
	根据放置的位置可以分为:
				<1>列级约束
							* NOT NULL
							* DEFAULT 
							* PRIMARY KEY
							*	UNIQUE
					语法:CREATE TABLE 表名(
								字段一 字段类型[字段长度] 约束类型 [约束值]	
						)
	
				<2>表级约束
							* PRIMARY KEY 
							* UNIQUE
							*	FOREIGN KEY
					 语法:create TABLE 表名(
								字段一 字段类型[字段长度] 约束类型(NOT NULL / DEFAULT) [约束值],
								字段一 字段类型[字段长度],
								[constraint 约束别名] 约束类型(约束字段) [REFERENCES 主表(字段名)]	
						)
			主键(primary key)和唯一键(unique):
								<1>两者都是表示数据只能出现一次,但是设置了主键则默认不可以为null,而唯一键虽然只能出现一次,但是null值却可以出现多次
								<2>在一个表中,主键只能拥有一个,而唯一键可以设置到多个字段中
								<3>这两个键都可以设置为组合形式,即在表级设置时,可以为这两个键设置多个字段,这几个字段只有所有信息都相同的情况下才会触发唯一性(不推荐)
			外键的特点:
								<1>创建表的时候必须先创建主表,再创建从表,这样从表才能引用主表的信息
								<2>删除表的时候必须先删除从表,才能删除主表,否则报错,因为从表还引用这主表的内容
								<3>外键应该设置在从表上面,并且主表和从表以外键关联的信息数据类型必须要一致或者兼容
								<4>主表中被从表关联的外键对应的字段必须是主键类型(❤)
			修改表时添加/删除约束:
							<1>对于只能在列级添加的两个约束not NULL,DEFAULT,同样在修改时也只能通过列级添加或删除
								#添加/删除not NULL,DEFAULT
										ALTER TABLE stu MODIFY COLUMN 字段名 字段类型[长度] 约束 [默认值]
							<2>添加/删除主键
									添加:
									ALTER TABLE stu MODIFY COLUMN 字段名 字段类型[长度] 主键约束
									ALTER TABLE stu ADD COLUMN 主键约束(字段名)
									删除:(只能通过该方式删除)
									ALTER TABLE stu DROP PRIMARY KEY;
							<3>添加/删除unique
									添加:
									ALTER TABLE stu MODIFY COLUMN 字段名 字段类型[长度] UNIQUE
									ALTER TABLE stu ADD UNIQUE(字段名)
									删除:(只能通过该方式删除)
									ALTER TABLE stu DROP INDEX 唯一键名字
							<4>添加/删除外键
									添加:
									ALTER TABLE stu ADD FOREIGN KEY(字段名) REFERENCES 主表(主键) 
									删除:
									ALTER TABLE stu DROP FOREIGN KEY 外键名称 外键名--->注意:虽然已经删除了,但是通过desc查询结构时仍然能看见,但是能够正常的插入数据

						SHOW INDEX FROM class;

*/
#列级约束
		
DROP DATABASE test;
CREATE DATABASE test;

DROP TABLE major;
DROP TABLE stu;
#创建一个主表
DESC major;


CREATE TABLE major(
	id INT PRIMARY KEY,
	majorName VARCHAR(20) NOT NULL
);

DESC stu;
SHOW INDEX FROM stu;
DROP table stu;
TRUNCATE TABLE stu;
CREATE TABLE stu(
	id INT PRIMARY KEY,
	stuName VARCHAR(10) NOT NULL,
	gender CHAR DEFAULT '女',
	age INT UNIQUE
)
INSERT into major
VALUES(101,'语文'),(106,'数学'),(109,'英语'),(115,'物理')
SELECT * FROM stu;
INSERT INTO stu VALUES
(1,'李四','男',18),(2,'唐三','女',19),(3,'张飞','男',21);

INSERT INTO stu(id,stuName) VALUE (4,'王五');


#设置表级约束:
DESC major;
DROP TABLE major;
DROP stu;
CREATE TABLE major(
	id INT,
	marjorName varchar(10),
	#设置表级约束
	CONSTRAINT primaryKey PRIMARY KEY(id),
	CONSTRAINT mustName UNIQUE (marjorName)
);

DESC stu;
SHOW INDEX from stu;


CREATE TABLE stu(
		id INT,	
		stuName varchar(10),
		gender char(1) DEFAULT '女',
		majorId INT,
		#开始设置约束
		constraint primaryK PRIMARY KEY (id),
		constraint must UNIQUE (stuName),
		constraint outKey FOREIGN KEY (majorId) REFERENCES major(id) 		
)


INSERT INTO major VALUE(1,'语文');

INSERT into stu(id,stuName,majorId) VALUE (1,'张三',1)
SELECT * FROM stu;
INSERT into stu VALUE (3,'王五','男',1)































