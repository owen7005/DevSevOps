-- 组合查询
-- 多数SQL查询都只包含从一个或多个表返回数据的单条SELECT语句。MySQL也允许执行多个查询，并将结果作为单个查询结果集返回
-- 这些组合查询通常称为并(union)或复合查询(compound query)
-- 创建组合查询：可用UNION操作符来组合数条SQL查询。利用UNION可给出多条SELECT语句，将它们的结果组合成单个结果集
-- 使用UNION
SELECT vend_id,prod_id,prod_price FROM products WHERE prod_price<=5 UNION SELECT vend_id,prod_id,prod_price FROM products WHERE vend_id IN (1001,1002);
-- 作为参考，这里给出使用多条WHERE子句而不是使用UNION的相同查询
SELECT vend_id,prod_id,prod_price FROM products WHERE prod_price <=5 OR vend_id IN (1001,1002);
-- 包含或取消重复的行
-- UNION从查询结果集中自动去除了重复的行。在使用UNION时，重复的行被自动取消。这是UNION的默认行为，但是如果需要，可以改变它。事实上，如果想返回所有匹配行，可使用UNION ALL而不是UNION
SELECT vend_id,prod_id,prod_price FROM products WHERE prod_price <= 5 UNION ALL SELECT vend_id,prod_id,prod_price FROM products WHERE vend_id IN (1001,1002);
-- 对组合查询结果排序
-- 在用UNION组合查询时，只能使用一条ORDER BY子句，它必须出现在最后一条SELECT语句之后。对于结果集，不存在用一种方式排序一部分，而又用另一种方式排序另一部分的情况，因此不允许使用多条ORDER BY子句
SELECT vend_id,prod_id,prod_price FROM products WHERE prod_price <= 5 UNION SELECT vend_id,prod_id,prod_price FROM products WHERE vend_id IN (1001,1002) ORDER BY vend_id,prod_price;