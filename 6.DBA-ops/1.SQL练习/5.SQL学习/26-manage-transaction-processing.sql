-- 管理事务处理
-- 并非所有引擎都支持事务处理。MyISAM和InnoDB是两种最常使用的引擎。前者不支持明确地事务处理管理，而后者支持。
-- 事务处理(transaction processing)可以用来维护数据库的完整性，它保证成批的MySQL操作要么完全执行，要么完全不执行
 -- 事务处理是一种机制，用来管理必须成批执行的MySQL操作，以保证数据库不包含不完整的操作结果。利用事务处理，可以保证一组操作不会中途停止，它们或者作为整体执行，或者完全不执行。如果没有错误发生，整租语句提交给数据库表。如果发生错误，则进行回退以恢复数据库到某个已知且安全的状态
 -- 控制事务处理
 -- MySQL使用下面的语句来标识事务的开始
 -- START TRANSACTION	
 SELECT	* FROM	ordertotals;
 START	TRANSACTION;
 DELETE	FROM	ordertotals;
 SELECT	* FROM	ordertotals;
 ROLLBACK;
 SELECT	* FROM	ordertotals;
 -- 使用COMMIT
 -- 一般的MySQL语句都是直接针对数据库执行和编写的。这就是所谓的隐含提交，即提交操作是自动进行的。
 -- 但是在事务处理中，提交不会隐含地进行。为进行明确地提交，使用COMMIT语句
 START	TRANSACTION;
 DELETE	FROM	orderitems	WHERE	order_num=20010;
 DELETE	FROM	orders	WHERE	order_num=20010;
 COMMIT;
 -- 使用保留点
 -- 简单的ROLLBACK和COMMIT语句就可以写入或撤销整个事务处理。但是，只是对简单的事务处理才能这样做，更复杂的事务处理可能需要部分提交或回退
 -- 为了支持回退部分事务处理，必须能在事务处理块中合适的位置放置占位符。这样如果需要回退，可以回退到某个占位符
 -- 这些占位符称为保留点。为了创建占位符，可如下使用SAVEPOINT语句
 SAVEPOINT delete1;
 -- 每个保留点都取标识它的唯一名字，以便在回退时，MySQL知道要回退到何处。为了回退到本例给出的保留点，可如下进行：
 ROLLBACK	TO	delete1;
 -- 更改默认的提交行为
 -- 默认的MySQL行为是自动提交所有更改。任何时候你执行一条MySQL语句，该语句实际上都是针对表执行的，而且所做的更改立即生效。为指示MySQL不自动提交更改，需要使用以下语句：
 SET	autocommit=0;
 -- autocommit标志决定是否自动提交更改，不管有没有COMMIT语句。设置autocommit=0指示MySQL不自动提交更改