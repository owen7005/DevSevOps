-- 使用触发器
-- 触发器是MySQL响应以下任意语句而自动执行的一条MySQL语句(或位于BEGIN和END语句之间的一组语句)
-- DELETE;INSERT;UPDATE
-- 创建触发器
-- 创建触发器，需要给出4条信息
-- 唯一的触发器名；触发器关联的表；触发器应该响应的活动(DELETE、INSERT、UPDATE)；触发器何时执行
-- 触发器用CREATE TRIGGER语句创建
CREATE TRIGGER	newproduct AFTER	INSERT	ON	products FOR	EACH	ROW	SELECT	'Product added' INTO	@asd;
SELECT @asd;
DROP	TRIGGER	newproduct;
-- 使用触发器
DROP	TRIGGER	neworder;
CREATE	TRIGGER	neworder after insert on orders for each row select NEW.order_num INTO	@ee;
insert into orders(order_date,cust_id) VALUES(NOW(),10001);
SELECT	@ee;
-- DELETE触发器
CREATE	TRIGGER	deleteorder BEFORE	DELETE	ON	orders for each row
BEGIN
	INSERT	INTO	archive_prders(order_num,order_date,cust_id) values (old.order_num,old.order_date,old.cust_id);
END;
-- UPDATE触发器
CREATE	TRIGGER	updatevendor BEFORE	UPDATE	ON	vendors for each row SET	NEW.vend_state = UPPER(NEW.vend_state);