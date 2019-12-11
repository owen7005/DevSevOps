-- 汇总数据
-- 聚集函数 aggregate function
-- AVG函数:使用AVG()返回products表中所有产品的平均价格
SELECT AVG(prod_price) AS avg_price FROM products;
-- AVG()也可以用来确定特定列或行的平均值
SELECT AVG(prod_price) AS avg_price FROM products WHERE vend_id=1003;
-- COUNT函数
SELECT COUNT(*) AS num_cust FROM customers;
-- 对cust_email列中有值得行进行计数
SELECT COUNT(cust_email) AS num_cust FROM customers;
-- MAX函数
SELECT MAX(prod_price) AS max_price FROM products;
-- MIN函数
SELECT MIN(prod_price) AS min_price FROM products;
-- SUM函数:SUM()用来返回指定列值的和
SELECT SUM(quantity) AS items_ordered FROM orderitems WHERE order_num=20005;
-- SUM()也可以用来合计计算值
SELECT SUM(item_price*quantity) AS total_price FROM orderitems WHERE order_num=20005;
-- 聚集不同值
SELECT AVG(DISTINCT prod_price) AS avg_price FROM products WHERE vend_id=1003;
-- 组合聚集函数
SELECT COUNT(*) AS num_items,MIN(prod_price) AS price_min,MAX(prod_price) AS price_max,AVG(prod_price) AS price_avg FROM products;
