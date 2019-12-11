-- 为了使用crashcourse
use crashcourse;
-- 数据库、表、列、用户、权限等的信息被存储在数据库和表中，MySQL的SHOW命令来显示这些信息(MySQL从内部表中提取这些信息)
show DATABASES;
show TABLES;
-- SHOW也可以用来显示表列
show COLUMNS from customers;
-- 用于显示广泛的服务器状态信息
show STATUS;
-- 显示授予用户的安全权限
show GRANTS;
-- 显示服务器错误
show ERRORS;
-- 显示警告信息
show WARNINGS;