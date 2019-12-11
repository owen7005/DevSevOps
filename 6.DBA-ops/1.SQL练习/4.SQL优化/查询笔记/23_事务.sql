/*
	事务:
			含义:一组或者一个SQL语句组成的一个执行单元,要么全部执行,要么全部不执行

			存储引擎:不是所有的存储引擎都能够支持事务的,可以通过SHOW ENGINES 语句来查看当前数据库支持的存储引擎以及默认引擎

			事务的特点(ACID):
						<1>原子性:事务作为一个执行单元是不可再分割的,要么全部执行,要么全部不执行
						<2>一致性:事务执行前后,会保持数据的一致性,如转账为例,转账前和转账后双方的钱加起来是相等的
						<3>隔离性:一个事务的执行不会被其他事务所影响
						<4>持久性:事务一旦被提交,则会永久的改变数据库中的数据
			事务支持的SQL语句: INSERT DELETE UPDATE SELECT --->即对表中数据进行增删改查的四个语句,其他语句在事务中执行没有意义

			事务:根据是否显示事务开启和结束将事务分为隐式事务和显示事务
						隐式事务:自动提交
						显示事务:手动提交	
								通过语句SHOW VARIABLES LIKE ('autocommit')查看自动提交是开启或关闭状态	
								
			显示事务:
					语法:
							SET autocommit = 0
							START transaction;
							SQL 语句。。。
							SQL 语句。。。
							COMMIT (提交)
							ROLLBACK(回滚)
			对于事务产生的并发问题:
								<1>脏读:事务A读取了事务B尚未提交的数据,这时如果事务B发生回滚,那么事务A读取的数据是无效的
								<2>不可重读:事务A在执行过程中多次读取同一数据,同时事务B操作了这些数据,那么事务A读取的数据会因为事务B的操作而不同
			<3>幻读:事务A读取了一次数据,然后事务B插入或者删除了数据,此时事务A对所有数据做出更改,会发现更改的数据个数与前面读取的个数不同;
			
			事务的隔离等级: read uncommitted;可以读取未提交的数据,会产生脏读,不可重复读,幻读问题
											read committed:可以读取提交后的数据,会产生不可重复读,幻读问题
											repeatable read(可重复读的):可在同一事务中多次读取相同的数据,会产生幻读问题
											serializable(串形化的) :最高等级,不会产生以上问题,但是效率低下
			事务的相关语句:
						查询当前事务的隔离级别:	SELECT @@tx.isolation (8.0版本以后用SELECT @@transaction_isolation) 
						设置当前事务/全局的隔离级别: SET SESSION|GLOBAL transaction isolation level 隔离级别名
			
			savepoint:保存节点,与事务一起使用,一旦使用后,回滚时则到此停止,在此节点上面的内容不会被回滚(即一定会执行)

			事务中delete和truncate的对比:
						delete是支持回滚的,而truncate不支持回滚,所以在事务中用truncate清空数据后是不能够通过回滚恢复的


*/

SHOW ENGINES;
SHOW VARIABLES LIKE 'autocommit';
create TABLE tab(
	id INT PRIMARY KEY,
	NAME VARCHAR(10)
)


TRUNCATE tab;
SET autocommit = 0;#将自动提交设置为off
START TRANSACTION ;#开启事务

#SQL语句
INSERT into tab VALUES(1,'张三'),(2,'李四'),(3,'王五');
UPDATE tab SET name = '二狗' WHERE id = 2;
DELETE FROM tab WHERE id = 3;
SELECT * from tab;
commit #提交

SELECT * from tab;

ROLLBACK #回滚



DROP DATABASE test;
use test;

set autocommit = 0;
select * from major;
delete from major WHERE id = 3;
SAVEPOINT a1;
update major set age = 10;
ROLLBACK to a1;

SELECT * from major;



