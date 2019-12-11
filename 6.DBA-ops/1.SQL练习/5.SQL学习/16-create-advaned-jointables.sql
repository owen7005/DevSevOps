-- 创建高级联结
-- 使用表别名
SELECT cust_name,cust_contact FROM customers AS C,orders AS o,orderitems AS oi WHERE c.cust_id=o.cust_id AND oi.order_num = o.order_num AND prod_id='TNT2';
-- 使用不同类型的联结:自联结、自然联结和外部联结
-- 自联结
SELECT prod_id,prod_name from products WHERE vend_id=(SELECT vend_id from products WHERE prod_id='DTNTR');
SELECT p1.prod_id,p1.prod_name FROM products AS p1,products AS p2 WHERE p1.vend_id=p2.vend_id AND p2.prod_id='DTNTR';
-- 自然联结:你只能选择那些唯一的列。这一般是通过对表使用通配符(SELECT *)，对所有其他表的列使用明确地子集来完成的
SELECT c.*,o.order_num,o.order_date,oi.prod_id,oi.quantity,oi.item_price from customers AS c,orders AS o,orderitems AS oi WHERE c.cust_id=o.cust_id AND oi.order_num=o.order_num AND prod_id='FB';
-- 事实上，目前为止我们建立的每个内部联结都是自然联结，很可能我们永远都不会用到不是自然联结的内部联结
-- 外部联结:联结包含了那些在相关表中没有关联行的行
SELECT customers.cust_id,orders.order_num FROM customers INNER JOIN orders ON customers.cust_id=orders.cust_id;
-- 这条语句使用了关键字OUTER JOIN来指定联结的类型。但是与内部联结关联两个表中的行不同的是，外部联结还包括没有关联行的行。在使用OUTER JOIN语法时，必须使用RIGHT或LEFT关键字指定包括其所有行的表(RIGHT指出的是OUTER JOIN右边的表，而LEFT指出的是OUTER JOIN左边的表)
-- 下面的代码中使用LEFT OUTER JOIN从FROM子句的左边表中选择所有行。为了从右边的表中选择所有行，应该使用RIGHT OUTER JOIN
SELECT customers.cust_id,orders.order_num FROM customers LEFT OUTER JOIN orders ON customers.cust_id=orders.cust_id;
-- 使用带聚集函数的联结
SELECT customers.cust_name,customers.cust_id,COUNT(orders.order_num) AS num_ord FROM customers INNER JOIN orders ON customers.cust_id=orders.cust_id GROUP BY customers.cust_id;
-- 使用左外部联结来包含所有客户，甚至包含那些没有任何下订单的客户
SELECT customers.cust_name,customers.cust_id,COUNT(orders.order_num) AS num_ord FROM customers LEFT OUTER JOIN orders ON customers.cust_id=orders.cust_id GROUP BY customers.cust_id;