drop table account;

create table account (
	id int PRIMARY KEY auto_increment,
	name varchar(10) unique not null,
	money double not null
);

insert into account(name, money) 
values ("张三", 10000), ("李四", 10000),
("王五", 10000);

select * from account;

 