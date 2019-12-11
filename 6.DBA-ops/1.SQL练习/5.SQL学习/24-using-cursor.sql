-- 使用游标
-- cursor是一个存储在MySQL服务器上的数据库查询，它不是一条SELECT语句，而是被该语句检索出来的结果集。在存储了游标之后，应用程序可以感觉需要滚动或浏览其中的数据。
-- MySQL游标只能用于存储过程
-- 创建游标
-- 为了把这些内容组织起来，下面给出我们的游标存储过程样例的更进一步修改的版本，这次对取出的数据进行某种实际的处理：
DROP	PROCEDURE	processorders;
CREATE TABLE ordertotals (order_num INT,total DECIMAL ( 8, 2 ));
CREATE PROCEDURE processorders () BEGIN-- Declare local variables
	DECLARE
		done BOOLEAN DEFAULT 0;
	DECLARE
		o INT;
	DECLARE
		t DECIMAL ( 8, 2 );-- Declare the cursor
	DECLARE
		ordernumbers CURSOR FOR SELECT
		order_num 
	FROM
		orders;-- Declare continue handler
	DECLARE
		CONTINUE HANDLER FOR SQLSTATE '02000' 
		SET done = 1;-- Create a table to store the results
	-- Open the cursor
	OPEN ordernumbers;-- Loop through all rows;
	REPEAT-- Get order number
		FETCH ordernumbers INTO o;-- Get the total for this order
		CALL ordertotal ( o, 1, t );-- Insert order and total into ordertotals
		INSERT INTO ordertotals ( order_num, total )
		VALUES
			( o, t );-- End of Loop
		UNTIL done 
	END REPEAT;
	CLOSE ordernumbers;
	
END;
SHOW TABLES;
SELECT
	* 
FROM
	ordertotals;