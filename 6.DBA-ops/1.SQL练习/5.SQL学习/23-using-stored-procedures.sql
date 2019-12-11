-- 使用存储过程
-- 存储过程就是为以后的使用而保存的一条或多条MySQL语句的集合。可将其视为批文件，虽然它们的作用不仅限于批处理
-- 存储过程通过把处理封装在容易使用的单元中，简化复杂的操作；由于不要求反复建立一系列处理步骤，这保证了数据的完整性。如果所有开发人员和应用程序都使用同一存储过程，则所使用的代码都是相同的；简化对变动的管理。如果表名、列名或业务逻辑有变化，只需要更改存储过程的代码。使用它的人员不需要知道这些变化
-- 提高性能。使用存储过程比使用单独的SQL语句快
-- 创建存储过程
-- 使用参数
DROP	PROCEDURE	productpricing;
CREATE	PROCEDURE	productpricing(OUT	p1 DECIMAL(8,2),OUT ph	DECIMAL(8,2),OUT pa DECIMAL(8,2))
BEGIN	
	SELECT	Min(prod_price)
	INTO p1
	FROM products;
	SELECT	Max(prod_price)
	INTO	ph
	FROM	products;
	SELECT	AVG(prod_price)
	INTO pa
	FROM	products;
END;
CALL productpricing(@pricelow,@pricehigh,@priceaverage);
SELECT @priceaverage;
SELECT	@pricehigh,@pricelow,@priceaverage;
DROP	PROCEDURE	ordertotal;
CREATE	PROCEDURE	ordertotal(IN	onumber INT,OUT	ototal DECIMAL(8,2))
BEGIN
	SELECT	SUM(item_price*quantity)
	FROM	orderitems
	WHERE	order_num=onumber
	INTO	ototal;
END;
CALL	ordertotal(20005,@total);
SELECT	@total;

DROP	PROCEDURE	ordertotal;

-- Name:ordertotal
-- Parameters:onumber=order number
-- 						taxable= 0 if not taxable,1 if taxable
-- 						ototal= order total variable
CREATE	PROCEDURE	ordertotal(IN	onumber INT,IN taxable BOOLEAN,OUT ototal DECIMAL(8,2)) COMMENT 'Obtain order total,optionally adding tax'
BEGIN
	-- Declare variable for total
	DECLARE	total DECIMAL(8,2);
	-- Declare tax percentage
	DECLARE	taxrate INT	DEFAULT 6;
	
	-- Get the order total
	SELECT	SUM(item_price*quantity)
	FROM orderitems
	WHERE	order_num=onumber
	INTO	total;
	
	-- Is this taxable?
	IF taxable THEN
		-- Yes,so add taxarate to the total
		SELECT	total+(total/100*taxrate) INTO	total;
	END IF;
	-- And finally,save to out variable
	SELECT	total INTO	ototal;
END;
CALL	ordertotal(20005,0,@total);
SELECT	@total;
CALL	ordertotal(20005,1,@total);
SELECT	@total;
-- 检查存储过程
SHOW	CREATE	PROCEDURE	ordertotal;
