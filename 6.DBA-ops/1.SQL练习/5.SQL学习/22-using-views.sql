-- 使用视图
-- 视图是虚拟的表。与包含数据的表不一样，视图只包含使用时动态检索数据的查询
SELECT
	cust_name,
	cust_contact 
FROM
	customers,
	orders,
	orderitems 
WHERE
	customers.cust_id = orders.cust_id 
	AND orderitems.order_num = orders.order_num 
	AND prod_id = 'TNT2';
-- 视图性能问题：因为视图不包含数据，所以每次使用视图时，都必须处理执行时所需的任一个检索。如果你用多个联结和过滤创建了复杂的视图或者嵌套了视图，可能会发现性能下降得很厉害。因此，在部署使用了大量视图的应用前，应当进行测试
-- 视图是数据库数据的特定子集。可以禁止所有用户访问数据表，而要求用户只能通过视图操作数据，这种方法可以保护用户和应用程序不受某些数据库修改的影响。
-- 视图是抽象的，它在使用时，从表里提取出数据，形成虚的表。不过对它的操作有很多的限制
-- 视图是永远不会自己消失的，除非手动删除它
-- 视图有时会对提高效率有帮助，一般随该数据库存放在一起，临时表永远都是在tempdb里。视图适合于多表连接浏览时使用；不适合增、删、改，这样可以提高执行效率
SELECT
	cust_name,
	cust_contact 
FROM
	productcustomers 
WHERE
	prod_id = 'TNT2';
-- 用视图重新格式化检索出的数据
SELECT	CONCAT(RTRIM(vend_name),'(',RTRIM(vend_country),')') AS	vend_title FROM	vendors	ORDER BY	vend_name;

SELECT	*	FROM	vendorlocations;

-- 用视图过滤不想要的数据
SELECT	*	FROM	customeremaillist;
-- 使用视图与计算字段
SELECT	*	FROM	orderitemsexpanded	WHERE	order_num=20005;