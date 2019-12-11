-- 全球化和本地化
-- 字符集为字母和符号的集合；编码为某个字符集成员的内部表示；校对为规定字符如何比较的指令
-- 为查看所支持的字符集完整列表，使用以下语句：这条语句显示所有可用的字符集以及每个字符集的描述和默认校对
show CHARACTER	SET;
-- 为了查看所支持校对的完整列表，使用以下语句：
SHOW	COLLATION;
-- 为了给表指定字符集和校对，可使用带子句的CREATE TABLE
CREATE	TABLE	mytable
(
	column1 INT,
	column2 VARCHAR(10)
)DEFAULT	CHARACTER	SET	hebrew COLLATE	hebrew_general_ci;
-- 此语句创建一个包含两列的表，并且指定一个字符集和一个校对顺序
-- 除了能指定字符集和校队的表范围外，MySQL还允许对每个列设置它们，如下所示：
CREATE	TABLE	mytable
(
	column1 INT,
	column2 VARCHAR(10),
	column3 VARCHAR(10) CHARACTER	SET	latin1 COLLATE	latin1_general_ci
)DEFAULT	CHARACTER	SET	hebrew COLLATE	hebrew_general_ci;