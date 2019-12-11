-- 高级数据过滤
-- 组合WHERE子句
-- AND操作符：这条SELECT语句中的WHERE子句包含两个条件，并且用AND关键字联结它们。
SELECT prod_id,prod_price,prod_name from products WHERE vend_id = 1003 AND prod_price <= 10;
-- OR操作符：指示MySQL检索匹配任一条件的行
SELECT prod_name,prod_price from products WHERE vend_id = 1002 OR vend_id = 1003;
-- 计算次序：WHERE可包含任意数目的AND和OR操作符。允许两者以进行复杂和高级的过滤
-- 但是组合AND和OR也带来了一个有趣的问题,SQL在处理OR操作符前，优先处理AND操作符。
SELECT vend_id,prod_name,prod_price from products WHERE vend_id=1002 OR vend_id = 1003 AND prod_price>=10;
-- 此问题的解决方法是使用圆括号明确地分组相应的操作符
SELECT prod_name,prod_price from products WHERE (vend_id=1002 OR vend_id=1003) AND prod_price>=10;
-- IN操作符:IN操作符用来指定条件范围，范围中的每个条件都可以进行匹配。IN取合法值的由逗号分隔的清单，全部在圆括号中
SELECT prod_name,prod_price from products WHERE vend_id IN (1002,1003) ORDER BY prod_name;
-- IN操作符完成与OR相同的功能
SELECT prod_name,prod_price from products WHERE vend_id=1002 OR vend_id=1003 ORDER BY prod_name;
-- NOT操作符：为了列出除1002和1003之外的所有供应商制造的产品，可编写以下代码
SELECT prod_name,prod_price from products WHERE vend_id NOT IN (1002,1003) ORDER BY prod_name;