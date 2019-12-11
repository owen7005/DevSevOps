-- 使用数据处理函数
-- 文本处理函数:Upper()函数将文本转换为大写
SELECT vend_name,UPPER(vend_name) AS vend_name_upcase FROM vendors ORDER BY vend_name;
-- 日期和事件处理函数
SELECT cust_id,order_num FROM orders WHERE order_date='2005-09-01';
-- 如果要的是日期，请使用Date()
SELECT cust_id,order_num FROM orders WHERE DATE(order_date)='2005-09-01';
SELECT cust_id,order_num FROM orders WHERE DATE(order_date) BETWEEN '2005-09-01' AND '2005-09-30';
SELECT cust_id,order_num FROM orders WHERE YEAR(order_date)=2005 AND MONTH(order_date)=9;
