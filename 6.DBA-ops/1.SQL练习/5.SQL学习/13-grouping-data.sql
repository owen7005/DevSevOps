-- 分组数据
-- 创建分组：分组是在SELECT语句的GROUP BY子句中建立的
SELECT vend_id,COUNT(*) AS num_prods FROM products GROUP BY vend_id;
-- 过滤分组：WHERE过滤行，HAVING过滤分组
SELECT cust_id,COUNT(*) AS orders FROM orders GROUP BY cust_id HAVING COUNT(*)>=2;
-- HAVING和WHERE的差别。WHERE在数据分组前进行过滤，HAVING在数据分组后进行过滤。WHERE排除的行不包括在分组中
SELECT vend_id,COUNT(*) AS num_prods FROM products WHERE prod_price>=10 GROUP BY vend_id HAVING COUNT(*)>=2;
SELECT vend_id,COUNT(*) AS num_prods FROM products GROUP BY vend_id HAVING COUNT(*) >=2;
-- 分组和排序
-- 一般在使用GROUP BY子句时，应该也给出ORDER BY子句。这是保证数据正确排序的唯一方法。千万不要仅依赖GROUP BY排序数据
SELECT order_num,SUM(quantity*item_price) AS ordertotal FROM orderitems GROUP BY order_num HAVING SUM(quantity*item_price)>=50;
-- 为按总计订单价格排序输出，需要添加ORDER BY子句
SELECT order_num,SUM(quantity*item_price) AS ordertotal FROM orderitems GROUP BY order_num HAVING SUM(quantity*item_price)>=50 ORDER BY ordertotal;