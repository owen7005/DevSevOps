create table students (
	id int primary key auto_increment,
	name varchar(10) unique not null,
	age int not null,
	borndate datetime default "1997-11-23"
);


insert into students(name, age, borndate)values ("张三", 18, STR_TO_DATE("1997-5-8","%Y-%c-%e")),
("王五", 28, STR_TO_DATE("1967-8-8","%Y-%c-%e")),
("李四", 19, STR_TO_DATE("1996-3-18","%Y-%c-%e")),
("二狗", 15, STR_TO_DATE("2000-7-21","%Y-%c-%e")),
("二哈", 17, STR_TO_DATE("1998-6-13","%Y-%c-%e")),
("呆子", 36, STR_TO_DATE("1958-10-8","%Y-%c-%e"))


