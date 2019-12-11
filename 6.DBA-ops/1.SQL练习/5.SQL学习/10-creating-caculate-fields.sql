-- 创建计算字段
-- 拼接字段Concat()函数来拼接两个列：Concat()拼接串，即把多个串连接起来形成一个较长的串。各个串之间用逗号分隔
SELECT CONCAT(vend_name,'(',vend_country,')') FROM vendors ORDER BY vend_name;
-- RTrim()函数删除数据右侧多余的空格来整理数据
SELECT Concat(RTRIM(vend_name),'(',RTRIM(vend_country),')') FROM vendors ORDER BY vend_name;
-- 使用别名
SELECT Concat(RTRIM(vend_name),'(',RTRIM(vend_country),')') AS vend_title FROM vendors ORDER BY vend_name;
-- 执行算术计算
SELECT prod_id,quantity,item_price FROM orderitems WHERE order_num = 20005;
SELECT prod_id,quantity,item_price,quantity*item_price AS expanded_price FROM orderitems WHERE order_num=20005;