-- 用通配符进行过滤
-- LIKE操作符
-- 百分号(%)通配符：%表示任何字符出现任意次数
SELECT prod_id,prod_name from products WHERE prod_name LIKE 'jet%';
-- 通配符可在搜索模式中任意位置使用，并且可以使用多个通配符
SELECT prod_id,prod_name from products WHERE prod_name LIKE '%anvil%';
-- 通配符也可以出现在搜索模式的中间
SELECT prod_name from products WHERE prod_name LIKE 's%e';
-- 下划线(_)通配符:只匹配单个字符而不是多个字符
SELECT prod_id,prod_name from products WHERE prod_name LIKE '_ ton anvil';

