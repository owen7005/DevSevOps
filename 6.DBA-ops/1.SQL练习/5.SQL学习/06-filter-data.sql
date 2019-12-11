-- 过滤数据
-- 使用WHERE子句，指定搜索条件，也称为过滤条件
-- 这个语句从products表中检索两个列，但不返回所有行，只返回prod_price值为2.50的行
SELECT prod_name,prod_price from products WHERE prod_price=2.5;
-- 检查单个值
-- 检查WHERE prod_name='fuses'语句，它返回prod_name的值为Fuses的一行。MySQL在执行匹配时默认不区分大小写，所以fuses与Fuses匹配
SELECT prod_name,prod_price from products WHERE prod_name='fuses';
-- 列出价格小于10美元的所有产品
SELECT prod_name,prod_price FROM products WHERE prod_price <10;
-- 下一条语句检索价格小于等于10美元的所有产品
SELECT prod_name,prod_price FROM products WHERE prod_price <= 10;
-- 不匹配检查,列出不是由供应商1003制造的所有产品
SELECT vend_id,prod_name from products WHERE vend_id <> 1003;
-- 下面是相同的例子，其中使用!=而不是<>操作符
SELECT vend_id,prod_name from products WHERE vend_id != 1003;
-- 范围值检查,检索价格在5美元和10美元之间的所有产品。BETWEEN匹配范围中所有的值，包括指定的开始值和结束值
SELECT prod_name,prod_price FROM products WHERE prod_price BETWEEN 5 AND 10;
-- 空值检查,IS NULL子句用来检查具有NULL值得列。这条语句返回没有价格(空prod_price字段，不是价格为0)的所有产品，由于表中没有这样的行，所有没有返回数据
SELECT prod_name from products WHERE prod_price IS NULL;
SELECT cust_id from customers where cust_email IS NULL;
