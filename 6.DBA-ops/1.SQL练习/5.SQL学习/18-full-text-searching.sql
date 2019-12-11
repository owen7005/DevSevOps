-- 全文本搜索
-- MySQL支持几种基本的数据库引擎。并非所有的引擎都支持本书所描述的全文本搜索。两个最常使用的引擎为MyISAM和InnoDB，前者支持全文本搜索，而后者不支持。如果你的应用中需要全文本搜索功能，应该记住这一点
-- 为了进行全文本搜索，必须索引被搜索的列，而且要随着数据的改变不断地重新索引。在对表列进行适当设计后，MySQL会自动进行所有的索引和重新索引
-- 在索引之后，SELECT可与Match()和Against()一起使用以实际执行搜索
-- 启动全文本搜索支持，一般在创建表时启动全文本搜索
-- 进行全文本搜索，使用两个函数Match()和Against()执行全文本搜索，其中Match()指定被搜索的列，Against()指定要使用的搜索表达式
SELECT
	note_text 
FROM
	productnotes 
WHERE
	MATCH ( note_text ) Against ( 'anvils' );
SELECT note_text from productnotes WHERE Match(note_text) Against('anvils' WITH QUERY EXPANSION);
SELECT note_text from productnotes WHERE Match(note_text) Against('heavy -rope*' IN BOOLEAN MODE);
SELECT note_text FROM productnotes WHERE Match(note_text) Against('+rabbit +bait' IN BOOLEAN MODE);