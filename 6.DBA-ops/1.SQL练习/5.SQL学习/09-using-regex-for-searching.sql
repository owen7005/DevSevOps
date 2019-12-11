-- 用正则表达式进行搜索
-- 正则表达式的作用是匹配文本，将一个模式与一个文本串进行比较。MySQL用WHERE子句对正则表达式提供了初步的支持，允许你指定正则表达式，过滤SELECT检索出的数据
SELECT prod_name from products WHERE prod_name REGEXP '1000' ORDER BY prod_name;
-- 下面的代码中使用了正则表达式.000。.是正则表达式中一个特殊的字符，它表示匹配任意一个字符，因此1000和2000都匹配且返回
SELECT prod_name FROM products WHERE prod_name REGEXP '.000' ORDER BY prod_name;
-- 进行OR匹配:|为正则表达式的OR操作符，它表示匹配其中之一
SELECT prod_name FROM products WHERE prod_name REGEXP '1000|2000' ORDER BY prod_name;
-- 匹配几个字符之一:这里使用了正则表达式[123] Ton。[123]定义一组字符，它的意思是匹配1或2或3.因此1 ton和2 ton都匹配且返回
SELECT prod_name FROM products WHERE prod_name REGEXP '[123] Ton' ORDER BY prod_name;
-- []是另一种形式的OR语句
SELECT prod_name FROM products WHERE prod_name REGEXP '1|2|3 Ton' ORDER BY prod_name;
-- 匹配范围：集合可用来定义要匹配的一个或多个字符
SELECT prod_name FROM products WHERE prod_name REGEXP '[1-5] Ton' ORDER BY prod_name;
-- 匹配特殊字符:这不是期望的输出，.匹配任意字符，因此每个行都被检索出来
SELECT vend_name FROM vendors WHERE vend_name REGEXP '.' ORDER BY vend_name;
-- 为了匹配特殊字符，必须用\\为前导。\\-表示查找-，\\.表示查找.
SELECT vend_name FROM vendors WHERE vend_name REGEXP '\\.' ORDER BY vend_name;
-- 匹配字符类,匹配多个实例
SELECT prod_name FROM products WHERE prod_name REGEXP '\\([0-9] sticks?\\)';
SELECT prod_name FROM products WHERE prod_name REGEXP '[[0-9]]{4}';
-- 定位符
-- 如果想找出一个数(包括以小数点开始的数)开始的所有产品，简单搜索[0-9\\.](或[[0-9]\\.])不行，因为它将在文本内任意位置查找匹配。解决办法是使用^定位符。
SELECT prod_name from products WHERE prod_name REGEXP '^[0-9\\.]' ORDER BY prod_name;
