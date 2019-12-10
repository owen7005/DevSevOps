# MySQL数据库基础

## 1.1-认识MySQL

### 什么是数据库

* 计算机处理和存储的一切信息都是数据。
* 计算机系统中一种用于存取数据的程序。
* 一种：
  * 计算机系统中有很多种能够存取数据的程序
  * 它们各有特征和长处，有自己的适用范围。
* 存取：
  * 能够保存数据避免丢失。
  * 能够按照需求找到符合条件的数据。

### 为什么要使用数据库

数据库帮助我们解决一下数据存取难题：

* 较大数据量
* 网络控制
* 并发访问
* 高性能要求
* 事务控制
* 持久化和数据安全
* 查询数据需求逻辑复杂

### 数据库分类

* 关系型数据库
  * MySQL
  * Oracle
  * SQL Server
  * PostgreSQL

* 非关系型数据库
  * hadoop：存放大数据
  * mongoDB： 文档型数据库
  * redis：键值型数据库
  * Cassandra：分布式数据库

**最显著的区别：是否使用结构化查询语句（SQL）**

### 为什么学习MySQL

MySQL：The world's most popular open source database

* 最流行
* 开源
* 并不是最先进

* 前三强中唯一的开源数据库。
* 在互联网企业中占据绝对主流地位。

* 基于GPL协议开放源代码
* 社区版完全免费
* 代码允许自由的进行修改

* 易于学习：
  * MySQL具备关系型数据库核心功能但是特性并不繁多。
  * 架构设计上趋于精简。
  * 非常适合新手学习关系型数据库，入门后可向其他数据库发展。

### 谁需要学习MySQL

* 应用开发者
* DBA

### 学习目标 - 应用开发者

有助于利用MySQL开发出性能优异的应用程序

### 学习目标 - DBA

为企业提供可靠的数据库技术保障

## 1.2-轻松安装MySQL

### 轻松部署MySQL

* Windows下安装MySQL
  * 图形化工具安装， MySQL Installer
* Linux（Ubuntu）下安装MySQL
  * 包管理安装，apt-get

**Windows安装时在安装中间starting server时报错解决办法是手动进入服务管理把MySQL服务的登录方式改为用本地账户且允许与桌面交互**

在Ubuntu下可以用`apt-cache search mysql-server`查看可用的软件包

使用`sudo apt-get install mysql-server-5.6`安装MySQL5.6

启动与停止MySQL服务：

```bash
# 启动
sudo /etc/init.d/mysql start
# 或者
sudo service mysql start

# 停止
sudo /etc/init.d/mysql stop
# 或者
sudo service mysql stop

# 重启
sudo service mysql restart

# 查看状态
sudo /etc/init.d/mysql status
```


## 1.3-MySQL数据库连接

### 工作中常用到的三种连接方式

* Java App + JDBC client（其他语言也有，比如Python的MySQLdb）
* MySQL client
* "MySQL" utility

### 使用应用程序连接MySQL

* 应用程序使用驱动（connector/driver）客户端连接MySQL
* MySQL驱动程序涵盖各种主流语言

### 使用命令行连接MySQL

* 安装MySQL客户端软件包
* 设置环境变量（Linux）

#### 如何安装MySQL-client

* 从软件源安装`sudo apt-get install mysql-client`

#### 验证MySQL的安装

`mysql -V`

### 命令行连接MySQL的两种方式

* Socket连接（本地连接）
* TCP/IP连接（远程连接）

### 使用Socket连接

```bash
# 需要指定socket文件和用户名、密码
mysql -S/tmp/mysql.sock -uroot -p
```

### 远程连接

```bash
# 需要指定IP和端口
mysql -h127.0.0.1 -P3306 -uroot -p
```

### 本地连接VS远程连接

* 本地连接只能在MySQL服务器上创建，常用作为MySQL状态检查，或程序和MySQL部署在一台机器上。
* 远程连接在MySQL服务器内外都能生效，适合应用服务器和MySQL部署在不同机器上的场景。

### 在Windows下用命令行连接MySQL

```cmd
mysql -hlocalhost -P3306 -uroot -p
```

### 连接进入之后可以做什么

```sql
# 数据库状态
status;

# 展示当前连接
show processlist;
```

### 使用命令行连接MySQL的注意事项

* socket一般存储路径为：/tmp/mysql.sock
```sql
# 如果找不到文件可以通过tcp连接进来然后通过如下命令查找
show global variables like 'socket';
```
* socket文件的权限必须是777
* 不要将密码直接输入在命令行里，存在安全风险！

### 命令行连接MySQL的特点

* MySQL命令行里有丰富的扩展参数
* DBA运维管理工具大多使用命令行方式
* 多台机器可以同时操作，对于DBA来说非常有效率

### 使用图形客户端连接MySQL

* 常用的图形客户端工具
  * Navicat
  * MySQLWorkBench

### 图形GUI工具的优势

* 操作简单易于上手
* 支持图形化的导入、导出
* 可视化界面输出，输出可视化

### 总结

* 应用程序需要使用API接口连接MySQL
* 开发工程师可以使用图形工具连接MySQL
* 命令行客户端才是DBA的最爱


## 1.4-SQL语言入门

### 关系型数据库

* 数据存放在表中
* 表的每一行被称为记录
* 表中所有记录都有相同的字段（列）

### SQL是什么

* Structured Query Language
* 是一种特殊目的的编程语言，用于关系型数据库中的标准数据存取操作
* 与数据库进行沟通的钥匙

### SQL语言与数据库

* 用SQL创建表，定义表中的字段
* 用SQL向表中增加，删除，修改记录
* 用SQL从表中查询到想要的记录
* 用SQL操作数据库的一切

### SQL语句的分类

|SQL语句的分类|大致用途|
|----|----|
|DDL(Data Definition Language)|创建表，删除表，修改表……|
|DML(Data Manipulation Language)|向表中插入记录，修改或者删除表中的记录……|
|select|根据条件从表中查询出想要得到的记录|
|DCL(Data Control Language)|控制数据库的访问权限等设置|
|TCL(Transaction Control Language)|控制事务进展|

* DDL
  * CREATE TABLE
  * DROP TABLE
  * ALTER TABLE
* DML
  * SELECT FROM TABLE
  * INSERT INTO TABLE
  * UPDATE TABLE SET
  * DELETE FROM TABLE
* DCL
  * GRANT
  * REVOKE
* TCL
  * COMMIT
  * ROLLBACK


example:
```sql
# 查看当前有哪些数据库
show databases;
# 使用名为test的数据库
use test;
# 创建一张学生表
create table stu(
  id int(10),
  name varchar(20),
  age int(10),
  primary key(id));
# 每一张表都需要包含一个主键，主键唯一标识一条记录，唯一的字段，不可重复不能为空，通过`primary key`关键字来定义。

# 查看创建好的表
show create table stu;
# 新加一个字段
alter table stu add column gender varchar(20);
# 修改一个字段
alter table stu modify column gender varchar(40);
# 删除一个字段
alter table stu drop column gender;
# 删除表
drop table stu;
# 查看当前数据库中的表
show tables;

# 向表中插入数据
insert into stu(id,name,age) values(1,'pw',28);
# 插入全部字段时可以只写表名
insert into stu values(2,'nss',29);
# 查看刚才添加的数据,"*"代表查询全部字段
select * from stu;
# 如果只想查询两个字段，则只写要查询的字段名
select name, age from stu;
# 也可以根据某个条件进行查询，比如只查询id为1的记录
select name age from stu where id=1;

# 更新语句
update stu set age=29 where id=1;

# 删除表中的数据
delete from stu where id=1;
```


## 1.5-认识DBA

### 什么是DBA

DBA是数据库管理员，就像是足球队的守门员，是业务最后一道屏障，是业务稳定运行的基石，可以提供更畅快的用户体验

### 为什么需要DBA

* 小公司
  * 没有专职DBA
  * 但肯定有懂数据库的人
* 大公司
  * 专职DBA
  * 数据存储技术专家

互联网业务有以下严格要求：

* 高性能（数据库是重要的一环）
* 高可用（需要业务不中断的运行）
* 可扩展（支撑海量数据和业务，数据库拓展）
* 安全性（核心业务数据敏感）

没有DBA，就没有稳定的数据库，请求变慢，数据丢失，安全问题，用户投诉，无穷无尽

### DBA要做哪些工作

* 基础运维工作
  * 安装部署
  * 监控
  * 故障处理
* 安全运维工作
  * 数据备份与恢复
  * 安全访问、安全漏洞
  * 审计
* 性能调优
  * 数据库优化
  * 容量评估、软硬件升级
* 开发支持工作
  * 存储方案制定
  * 数据库设计
  * 数据库变更、SQL Review
* 流程与培训
  * 数据库开发规范
  * 运维流程标准化
  * 业务培训

### DBA需要哪些技能

* 专业技能
  * 数据库原理
  * Linux与Shell
  * 计算机体系结构
  * 网络原理
  * 数据库系统与操作
  * 服务器硬件
  * 业务架构设计
* 软技能
  * 责任心、执行力
  * 坚韧、抗压
  * 学习与沟通能力
  * 正直、诚信
  * 耐心，注重细节
  * 分析能力
  * 团队协作

### DBA如何发展

* 小公司or大公司
* 发展通道：
  * DBA -> 业务架构师
  * DBA -> 运维专家
  * DBA -> 数据库研发

### 小结

* 认识DBA
  * 管理好数据库
  * DBA工作很重要
  * 专业技能与软技能并重
  * 不错的发展前景
  * 互联网公司很缺优秀的DBA
