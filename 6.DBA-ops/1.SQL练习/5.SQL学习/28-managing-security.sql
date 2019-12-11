-- 安全管理
-- 访问控制
-- MySQL用户账号和信息存储在名为mysql的MySQL数据库中。一般不需要直接访问mysql数据库和表，但有时需要直接访问。需要直接访问它的时机之一是在需要获得所有用户账号列表时。为此，可以使用以下代码：
USE	mysql;
SELECT	user from user;
-- 创建用户账号
CREATE	USER	ben IDENTIFIED	by 'p@$$w0rd';
-- 重命名一个用户账号，使用RENAME USER语句
RENAME	USER	ben TO	bforta;
-- 删除用户账号
DROP	USER	bforta;
-- 设置访问权限
SHOW	GRANTS	FOR	bforta;
-- GRANT用法
GRANT	SELECT	ON	crashcourse.* TO	bforta;
-- SHOW GRANTS反映这个更改
SHOW	GRANTS	FOR	bforta;
-- GRANT的反操作为REVOKE，撤销特定权限
REVOKE	SELECT	ON	crashcourse.* FROM	bforta;
-- 更改口令
SET	PASSWORD FOR	bforta=Password('n3w p@$$w0rd');
-- SET PASSWORD还可以用来设置你自己的口令
SET PASSWORD = Password('n3w p@$$w0rd');
