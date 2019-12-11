-- 检索单个列
SELECT prod_name from products;
-- 检索多个列
SELECT prod_id,prod_name,prod_price from products;
-- 检索所有列,'*'通配符返回表中所有列
SELECT * from products;
-- 检索不同的行
SELECT vend_id from products;
-- DISTINCT关键字指示MySQL只返回不同的值，去重作用
SELECT DISTINCT vend_id from products;
-- LIMIT 5指示MySQL返回指定的行数,5行
SELECT prod_name from products LIMIT 5;
-- LIMIT 5,5指示MySQL返回从行5开始的5行。第一个数为开始位置，第二个数为要检索的行数。检索出来的第一行为行0，而不是行1
SELECT prod_name from products LIMIT 5,5;
-- 使用完全限定的名字来引用列，限定列名
SELECT products.prod_name from products;
-- 限定表名
SELECT products.prod_name from crashcourse.products;
