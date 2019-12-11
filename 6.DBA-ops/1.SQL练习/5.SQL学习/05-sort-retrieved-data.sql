-- 排序检索数据
-- 为了明确地排序用SELECT语句检索出的数据，可使用ORDER BY子句。ORDER BY子句取一个或多个列的名字，据此对输出进行排序
-- 对prod_name列以字母顺序排序数据的ORDER BY子句
SELECT prod_name from products ORDER BY prod_name;
-- 按多个列排序
-- 下面的代码检索3个列，并按其中两个列对结果进行排序，首先按照prod_price，然后再按prod_name排序
SELECT prod_id,prod_price,prod_name from products ORDER BY prod_price,prod_name;
-- 指定排序方向。数据排序不限于升序排序(从A到Z)。这只是默认的排序顺序，还可以使用ORDER BY子句以降序(从Z到A)顺序排序。为了进行降序排序，必须指定DESC关键字
-- 按价格以降序排序产品
SELECT prod_id,prod_price,prod_name from products ORDER BY prod_price DESC;
-- 以降序排序产品价格，然后再对产品名升序排序。DESC关键字只应用到直接位于其前面的列名。下面代码中只对prod_price列指定DESC，对prod_name列不指定
-- 如果想在多个列上进行降序排序，必须对每个列指定DESC关键字
SELECT prod_id,prod_price,prod_name from products ORDER BY prod_price DESC,prod_name;
-- 使用order by和LIMIT组合，能够找出一个列中最高或最低的值。
SELECT prod_price from products ORDER BY prod_price DESC LIMIT 1;