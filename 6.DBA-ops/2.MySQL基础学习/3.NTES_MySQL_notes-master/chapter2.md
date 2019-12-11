# MySQL数据库对象与应用

## 2.1-MySQL数据类型

### Number不止一种

* 整形
* 浮点型

### 整形

* INT
* SMALLINT
* MEDIUMINT
* BIGINT

| type | Storage | Minumun Value | Maximum Value|
| :------------- | :------------- | :------------- | :------------- |
||(Bytes)|(Signed/Unsigned)|(Signed/Unsigned)|
|TINYINT|1|-128|127|
|||0|255|
|SMALLINT|2|-32768|32767|
|||0|65535|
|MEDIUMINT|3|-8388608|8388607|
|||0|16777215|
|INT|4|-2147483648|2147483647|
|||0|4294967295|
|BIGINT|8|-9223372036854775808|9223372036854775807|
|||0|18446744073709551615|

### 老生常谈的问题

**int(11) VS int(21)**
存储空间，还是存储范围有区别？

答案是：**两者完全一样**，只是在显示的时候补全0的位数不一样。

可以通过下面的例子来验证：

```sql
create table t(a int(11) zerofill, b int(21) zerofill);
insert into t values (1, 1);
select * from t;
```

MySQL默认是不带0补全的。

只是在一些特殊情况下两者显示有区别，其本质完全一样。

### 浮点型

* FLOAT(M, D)
* DOUBLE(M, D)

| 属性 | 存储空间 | 精度 | 精确性 |
| :------------- | :------------- | :------------- | :------------- |
|Float|4 bytes|单精度|非精确|
|Double|8 bytes|双精度|比Float精度高|

### 精度丢失问题

* 精度丢失

一个例子：
```sql
create table t(a int(11), b float(7, 4));
insert into t values (2, 123.12345);
select * from t;
```

### 定点数-更精确的数字类型

* DECIMAL
  * 高精度的数据类型，常用来存储交易相关的数据
  * DECIMAL(M,N).M代表总精度，N代表小数点右侧的位数（标度）
  * 1 < M < 254, 0 < N < 60;
  * 存储空间变长

### 性别、省份信息

一般使用tinyint、char(1)、enum类型。

### 经验之谈

* 存储性别、省份、类型等分类信息时选择TINYINT或者ENUM
* BIGINT存储空间更大，INT和BIGINT之间通常选择BIGINT
* 交易等高精度数据选择使用DECIMAL

### 存储用户名的属性

* CHAR
* VARCHAR
* TEXT

### CAHR与VARCHAR

* CHAR和VARCHAR存储的单位都是字符
* CHAR存储定长，容易造成空间的浪费
* VARCHAR存储变长，节省存储空间

### 字符与字节的区别

|编码\输入字符串   | 网易            | netease        |
| :------------- | :------------- | :------------- |
| gbk(双字节)     | varchar(2)/4 bytes|varchar(7)/7 bytes|
| utf8(三字节)     | varchar(2)/6 bytes|varchar(7)/7 bytes|
| utf8mb4(四字节)     | varchar(2) ?|varchar(7)/7 bytes|

对于utf8mb4号称占用四字节但是并不绝对。如果在utf8可以覆盖到的范围则仍然占用3字节。

utf8mb4最有优势的应用场景是用于存储emoji表情

### emoji表情

* MySQL版本 > 5.5.3
* JDBC驱动版本 > 5.1.13
* 库和表的编码设为utf8mb4

### TEXT与CHAR和VARCHAR的区别

* CHAR和VARCHAR存储单位为字符
* TEXT存储单位为字节，总大小为65535字节，约为64KB
* CHAR数据类型最大为255字符
* VARCHAR数据类型为变长存储，可以超过255个字符
* TEXT在MySQL内部大多存储格式为溢出页，效率不如CHAR

一个例子：

```sql
create table t (a char(256));
create table t (a varchar(256));
```

### 存储头像

* BLOB
* BINARY

性能太差，不推荐

### 经验之谈

* CHAR与VARCHAR定义的长度是字符长度不是字节长度
* 存储字符串推荐使用VARCHAR(N),N尽量小
* 虽然数据库可以存储二进制数据，但是性能低下，不要使用数据库存储文件音频等二进制数据

### 存储生日信息

* DATE
* TIME
* DATETIME
* TIMESTAMP
* BIGINT

### 时间类型的区别在哪里

* 存储空间上的区别
  * DATE三字节，如：2015-05-01
  * TIME三字节，如：11:12:00
  * TIMESTAMP，如：2015-05-01 11::12:00
  * DATETIME八字节，如：2015-05-01 11::12:00

* 存储精度的区别
  * DATE精确到年月日
  * TIME精确到小时分钟和秒
  * TIMESTAMP、DATETIME都包含上述两者

### TIMESTAMP VS DATETIME

* 存储范围的区别
  * TIMESTAMP存储范围：1970-01-01 00::00:01 to 2038-01-19 03:14:07
  * DATETIME的存储范围：1000-01-01 00:00:00 to 9999-12-31 23:59:59

MySQL在5.6.4版本之后，TimeStamp和DateTime支持到微妙

* 字段类型与市区的关联关系
  * TIMESTAMP会根据系统时区进行转换，DATETIME则不会

### 字段类型和时区的关系

* 国际化的系统

一个例子：
```sql
create table test (a datetime, b timestamp);
select now();
insert into test values (now(), now());
select * from test;
set time_zone = '+00:00';
select * from test;
```

### BIGINT如何存储时间类型

* 应用程序将时间转换为数字类型


## 2.2-MySQL数据对象

### MySQL常见的数据对象有哪些

* DataBase/Schema
* Table
* Index
* View/Trigger/Function/Procedure

### 库、表、行层级关系

* 一个DataBase对应一个Schema
* 一个Schema包含一个或多个表
* 一个表里面包含一个或多个字段
* 一个表里包含一条或多条记录
* 一个表包含一个或多个索引

### 多DataBase用途

* 业务隔离
* 资源隔离

### 表上有哪些常用的数据对象

* 索引
* 约束
* 视图、触发器、函数、存储过程

### 什么是数据库索引

* 读书的时候如何快速定位某一章节
  * 查找书籍目录
  * 在自己喜欢的章节加书签，直接定位
* 索引就是数据库中的数据的目录（索引和数据是分开存储的）
  * 索引和数据是两个对象
  * 索引主要是用来提高数据库的查询效率
  * 数据库中数据变更同样需要同步索引数据的变更

## 如何创建索引（一）

```sql
CREATE [UNIQUE|FULLTEXT|SPATIAL] INDEX index_name
  [index_type]
  ON tbl_name (index_col_name,...)
  [index_option]
  [algorithm_option | lock_option] ...

index_col_name:
  col_name [(length)] [ASC | DESC]

index_type:
  USING {BTREE | HASH}
```

## 如何创建索引（二）

```sql
ALTER [IGNORE] TABLE tbl_name
  [alter_specification [, alter_specification] ...]
  [partition_options]

alter_specification:
    table_options
  | ADD [COLUMN] col_name column_definition
        [FIRST | AFTER col_name]
    ADD [COLUMN] (col_name column_definition,...)
    ADD {INDEX|KEY} [index_name]
        [index_type] (index_col_name,...) [index_option] ...
  | ADD [CONSTRAINT [symbol]] PRIMARY KEY
        [index_type] (index_col_name,...) [index_option] ...
  | ADD [CONSTRAINT [symbol]]
        UNIQUE [INDEX|KEY] [index_name]
```

### 约束

* 生活中的约束有哪些
  * 每个人的指纹信息必须唯一
  * 每个人的身份证要求唯一
  * 网上购物需要先登录才能下单
* 唯一约束
  * 对一张表的某个字段或者某几个字段设置唯一键约束，保证在这个表里对应的数据必须唯一，如：用户ID、手机号、身份证等。

### 创建唯一约束

* 唯一约束是一种特殊的索引
* 唯一约束可以是一个或者多个字段
* 唯一约束可以在创建表的时候建好，也可以后面再补上
* 主键也是一种唯一约束

### 唯一约束

以如下这张表为例

```sql
CREATE TABLE `order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `orderid` int(10) unsigned NOT NULL,
  `bookid` int(10) unsigned NOT NULL DEFAULT '0',
  `userid` int(10) unsigned NOT NULL DEFAULT '0',
  `number` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `address` varchar(128) NOT NULL DEFAULT '',
  `postcode` varchar(128) NOT NULL DEFAULT '',
  `orderdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` tinyint(3) unsigned zerofill DEFAULT '000',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_orderid` (`orderid`),
  UNIQUE KEY `idx_uid_orderid` (`userid`, `orderid`),
  KEY `bookid` (`bookid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```

* 索引有哪些
  * 主键索引 ID
  * 单键索引 orderid
  * 单键索引 bookid
  * 组合索引 (userid + orderid)
* 唯一约束有哪些
  * 主键约束      (ID)
  * 单键唯一索引   (orderid)
  * 组合唯一索引   (userid + orderid)

### 添加唯一约束

* 添加主键
  * alter table \`order\` add primary key (id);
* 添加唯一索引
  * alter table \`order\` add unique key idx_uk_orderid (orderid);

### 外键约束
  * 外键指两张表的数据通过某种条件关联起来

### 创建外键约束

* 将用户表和订单表通过外键关联起来
  * alter table \`order\` add CONSTRAINT constraint_uid FOREIGN KEY (userid) REFERENCES user(userid);
* 使用外键的注意事项
  * 必须是INNODB表，Myisam和其他引擎不支持外键
  * 相互约束的字段类型必须要求一样
  * 主表的约束字段要求有索引
  * 约束名称必须要唯一，即使不在一张表上

### View

* 产品需求
  * 假如有其他部门的同事想查询我们数据库里的数据，但是我们并不想暴露表结构，并且只提供给他们部分数据

### View的作用

* 视图将一组查询语句构成的结果集，是一种虚拟结构，并不是实际数据
* 视图能简化数据库的访问，能够将多个查询语句结构化为一个虚拟结构
* 视图可以隐藏数据库后端表结构，提高数据库安全性
* 视图也是一种权限管理，只对用户提供部分数据

### 创建View

* 创建已完成订单的视图
  * create view order_view as select * from \`order\` where status=1;

### Trigger

* 产品需求
  * 随着客户个人等级的提升， 系统需要自动更新用户的积分，其中一共有两张表，分别为：用户信息表和积分表
* Trigger俗称触发器，指可以在数据写入表A之前或者之后可以做一些其他动作
* 使用Trigger在每次更新用户表的时候出发更新积分表

### 除此之外还有哪些

* Function
* Procedure


## 2.3-MySQL权限管理

### 连接MySQL的必要条件

* 网络要通畅
* 用户名和密码要正确
* 数据库需要加IP白名单
* 更细粒度的验证（库、表、列权限类型等等）

### 数据有哪些权限

`show privileges`命令可以查看全部权限

### 权限粒度

* Data Privileges
  * DATA: SELECT, INSERT, UPDATE, DELETE
* Definition Privileges
  * DataBase: CREATE, ALTER, DROP
  * Table: CREATE, ALTER, DROP
  * VIEW/FUNCTION/TRIGGER/PROCEDURE: CREATE, ALTER, DROP
* Administrator Privileges
  * Shutdown DataBase
  * Replication Slave
  * Replication Client
  * File Privilege

### MySQL赋权操作

```sql
GRANT
  priv_type [(column_list)]
    [, priv_type [column_list]] ...
  ON [object_type] priv_level
  TO user_specification [, user_specification] ...
  [REQUIRE {NONE | ssl_option [[AND] ssl_option] ...}]
  [WITH with_option ...]
GRANT PROXY ON user_specification
  TO user_specification [, user_specification] ...
  [WITH GRANT OPTION]
```

### 如何新建一个用户并赋权

* 使用MySQL自带的命令
  * `CREATE USER 'netease'@'localhost' IDENTIFIED BY 'netease163';`
  * `GRANT SELECT ON *.* TO 'netease'@'localhost' WITH GRANT OPTION;`

### 其他方法

* 更改数据库记录
  * 首先向User表里面插入一条记录，根据自己的需要选择是否向db和table_pirv表插入记录
  * 执行`flush privileges`命令，让权限信息生效

### 更简单的办法

* GRANT语句会判断是否存在该用户，如果不存在则新建
  * `GRANT SELECT ON *.* TO 'NETEASE'@'localhost' IDENTIFIED BY 'netease163' WITH GRANT OPTION;`

### 查看用户的权限信息

* 查看当前用户的权限
  * `show grants;`
* 查看其它用户的权限
  * `show grants for netease@'localhost';`

### 如何更改用户的权限

* 回收不需要的权限
  * `revoke select on *.* from netease@'localhost';`
* 重新赋权
  * `grant insert on *.* to netease@'localhost';`

### 如何更改用户密码

* 用新密码，grant语句重新授权
* 更改数据库记录，Update User表的Password字段
  * 注意：用这种办法，更改完需要flush privileges刷新权限信息，不推荐

### 删除用户

```sql
DROP USER user [, user] ...
```

### With Grant Option

* 允许被授予权利的人把这个权利授予其他的人

### MySQL权限信息存储结构

* MySQL权限信息是存在数据库表中
* MySQL账号对应的密码也加密存储在数据库表中
* 每一种权限类型在元数据里都是枚举类型，表明是否有该权限

### 有哪些权限相关的表

* user
* db
* table_pirv
* columns_pirv
* host

### 权限验证流程

查询时从user->db->table_pirv->columns_pirv依次验证，如果通过则执行查询。

### 小结

* MySQL权限信息都是以数据记录的形式存储在数据库的表中。
* MySQL的权限验证相比网站登录多了白名单环节，并且粒度更细，可以精确到表和字段。

### MySQL权限上有哪些问题

* 使用Binary二进制安装管理用户没有设置密码
* MySQL默认的test库不受权限控制，存在安全风险

### mysql_secure_installation

* You can set a Password for root accounts.
* You can remove root accounts that are accessible from outside the localhost.
* You can remove anonymous-user accounts.
* You can remove the test database.

### 小结

* 权限相关的操作不要直接操作表，统一使用MySQL命令。
* 使用二进制安装MySQL安装后，需要重置管理用户(root)的密码。
* 线上数据库不要留test库


## 实践课：数据库对象

### 何为表结构设计

* 表结构设计需要在正式进行开发之前完成
* 根据产品需求将复杂的业务模型抽象出来

### 设计表的时候需要注意哪些

* 理解各个表的依赖关系
* 理解各个表的功能特点
  * 字段之间的约束、索引
  * 字段类型、字段长度

### 收集表属性

* 昵称
* 生日
* 性别
* 手机号码
* 住宅号码
* 邮编
* 住宅地址
* 注册地址
* 登录IP
* 上一次登录时间
* 邮件地址

### 理解表的功能特点——数据用途

```sql
create table tb_account(
  account_id int not null auto_increment primary key,
  nick_name varchar(20),
  true_name varchar(20),
  sex char(1),
  mail_address varchar(50),
  phone1 varchar(20) not null,
  phone2 varchar(20),
  password varchar(30) not null,
  create_time datetime,
  account_state tinyint,
  last_login_time datetime,
  last_login_ip varchar(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4

create table tb_goods(
  good_id bigint not null auto_increment primary key,
  goods_name varchar(100) not null,
  pic_url varchar(500) not null,
  store_quantity int not null,
  goods_note varchar(4096),
  producer varchar(500),
  category_id int not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4

create table tb_goods_category(
  category_id int not null auto_increment primary key,
  category_level smallint not null,
  category_name varchar(500),
  upper_category_id int not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4

create table tb_order(
  order_id bigint not null auto_increment primary key,
  account_id int not null,
  create_time datetime,
  order_amount decimal(12,2),
  order_state tinyint,
  update_time datetime,
  order_ip varchar(20),
  pay_method varchar(20),
  user_notes varchar(500)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4

create table tb_order_item(
  order_item_id bigint not null auto_increment primary key,
  order_id bigint not null,
  goods_id bigint not null,
  goods_quantity int not null,
  goods_amount decimal(12,2),
  uique key uk_order_goods(order_id, goods_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
```

### 数据类型——命名规范

* 所有表名，字段名全部使用小写字母
* 不同业务，表名使用不同前缀区分。
* 生成环境表名字段名要有实际意义
* 单个字段尽量使用字段全名；多个字段之间用下划线分隔

### 字段设计规范

* 字段类型选择，尽量选择能满足应用要求的最小数据类型
* 尽量使用整形代替字符型。整形在字段长度、索引大小等方面开销小效率更高，如邮编字段，手机号码等
* 注释，每个字段必须以comment语句给出字段的作用
* 经常访问的大字段需要单独放到一张表中，避免降低sql效率，图片、电影等大文件数据禁止存数据库
* 新业务统一建议使用utf8mb4字符集

### 用户赋权

* 理解用户到底需要什么权限
  * 普通用户只有数据读写权限
  * 系统管理员具有super权限
* 权限粒度要做到尽可能的细
  * 普通用户不要设置with grant option属性
  * 权限粒度：系统层面>库层面>表层面>字段层面
* 禁止简单密码
  * 线上密码要求随机

## 2.4-SQL语言进阶

本课程涉及建表SQL

```SQL
-- ----------------------------
-- Table structure for `play_fav`
-- ----------------------------
DROP TABLE IF EXISTS `play_fav`;
CREATE TABLE `play_fav` (
  `userid` bigint(20) NOT NULL COMMENT '收藏用户id',
  `play_id` bigint(20) NOT NULL COMMENT '歌单id',
  `createtime` bigint(20) NOT NULL COMMENT '收藏时间',
  `status` int(11) DEFAULT '0' COMMENT '状态，是否删除',
  PRIMARY KEY (`play_id`,`userid`),
  KEY `IDX_USERID` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='歌单收藏表';

-- ----------------------------
-- Records of play_fav
-- ----------------------------
INSERT INTO play_fav VALUES ('2', '0', '0', '0');
INSERT INTO play_fav VALUES ('116', '1', '1430223383', '0');
INSERT INTO play_fav VALUES ('143', '1', '0', '0');
INSERT INTO play_fav VALUES ('165', '2', '0', '0');
INSERT INTO play_fav VALUES ('170', '3', '0', '0');
INSERT INTO play_fav VALUES ('185', '3', '0', '0');
INSERT INTO play_fav VALUES ('170', '4', '0', '0');
INSERT INTO play_fav VALUES ('170', '5', '0', '0');

-- ----------------------------
-- Table structure for `play_list`
-- ----------------------------
DROP TABLE IF EXISTS `play_list`;
CREATE TABLE `play_list` (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `play_name` varchar(255) DEFAULT NULL COMMENT '歌单名字',
  `userid` bigint(20) NOT NULL COMMENT '歌单作者账号id',
  `createtime` bigint(20) DEFAULT '0' COMMENT '歌单创建时间',
  `updatetime` bigint(20) DEFAULT '0' COMMENT '歌单更新时间',
  `bookedcount` bigint(20) DEFAULT '0' COMMENT '歌单订阅人数',
  `trackcount` int(11) DEFAULT '0' COMMENT '歌曲的数量',
  `status` int(11) DEFAULT '0' COMMENT '状态,是否删除',
  PRIMARY KEY (`id`),
  KEY `IDX_CreateTime` (`createtime`),
  KEY `IDX_UID_CTIME` (`userid`,`createtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='歌单';

-- ----------------------------
-- Records of play_list
-- ----------------------------
INSERT INTO play_list VALUES ('1', '老男孩', '1', '1430223383', '1430223383', '5', '6', '0');
INSERT INTO play_list VALUES ('2', '情歌王子', '3', '1430223384', '1430223384', '7', '3', '0');
INSERT INTO play_list VALUES ('3', '每日歌曲推荐', '5', '1430223385', '1430223385', '2', '4', '0');
INSERT INTO play_list VALUES ('4', '山河水', '2', '1430223386', '1430223386', '5', null, '0');
INSERT INTO play_list VALUES ('5', '李荣浩', '1', '1430223387', '1430223387', '1', '10', '0');
INSERT INTO play_list VALUES ('6', '情深深', '5', '1430223388', '1430223389', '0', '0', '1');

-- ----------------------------
-- Table structure for `song_list`
-- ----------------------------
DROP TABLE IF EXISTS `song_list`;
CREATE TABLE `song_list` (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `song_name` varchar(255) NOT NULL COMMENT '歌曲名',
  `artist` varchar(255) NOT NULL COMMENT '艺术节',
  `createtime` bigint(20) DEFAULT '0' COMMENT '歌曲创建时间',
  `updatetime` bigint(20) DEFAULT '0' COMMENT '歌曲更新时间',
  `album` varchar(255) DEFAULT NULL COMMENT '专辑',
  `playcount` int(11) DEFAULT '0' COMMENT '点播次数',
  `status` int(11) DEFAULT '0' COMMENT '状态,是否删除',
  PRIMARY KEY (`id`),
  KEY `IDX_artist` (`artist`),
  KEY `IDX_album` (`album`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='歌曲列表';

-- ----------------------------
-- Records of song_list
-- ----------------------------
INSERT INTO song_list VALUES ('1', 'Good Lovin\' Gone Bad', 'Bad Company', '0', '0', 'Straight Shooter', '453', '0');
INSERT INTO song_list VALUES ('2', 'Weep No More', 'Bad Company', '0', '0', 'Straight Shooter', '280', '0');
INSERT INTO song_list VALUES ('3', 'Shooting Star', 'Bad Company', '0', '0', 'Straight Shooter', '530', '0');
INSERT INTO song_list VALUES ('4', '大象', '李志', '0', '0', '1701', '560', '0');
INSERT INTO song_list VALUES ('5', '定西', '李志', '0', '0', '1701', '1023', '0');
INSERT INTO song_list VALUES ('6', '红雪莲', '洪启', '0', '0', '红雪莲', '220', '0');
INSERT INTO song_list VALUES ('7', '风柜来的人', '李宗盛', '0', '0', '作品李宗盛', '566', '0');

-- ----------------------------
-- Table structure for `stu`
-- ----------------------------
DROP TABLE IF EXISTS `stu`;
CREATE TABLE `stu` (
  `id` int(10) NOT NULL DEFAULT '0',
  `name` varchar(20) DEFAULT NULL,
  `age` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of stu
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_proc_test`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_proc_test`;
CREATE TABLE `tbl_proc_test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `num` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_proc_test
-- ----------------------------
INSERT INTO tbl_proc_test VALUES ('11', '1');
INSERT INTO tbl_proc_test VALUES ('12', '2');
INSERT INTO tbl_proc_test VALUES ('13', '6');
INSERT INTO tbl_proc_test VALUES ('14', '24');
INSERT INTO tbl_proc_test VALUES ('15', '120');
INSERT INTO tbl_proc_test VALUES ('16', '720');
INSERT INTO tbl_proc_test VALUES ('17', '5040');
INSERT INTO tbl_proc_test VALUES ('18', '40320');
INSERT INTO tbl_proc_test VALUES ('19', '362880');
INSERT INTO tbl_proc_test VALUES ('20', '3628800');
INSERT INTO tbl_proc_test VALUES ('21', '1');
INSERT INTO tbl_proc_test VALUES ('22', '2');
INSERT INTO tbl_proc_test VALUES ('23', '6');
INSERT INTO tbl_proc_test VALUES ('24', '24');
INSERT INTO tbl_proc_test VALUES ('25', '1');
INSERT INTO tbl_proc_test VALUES ('26', '2');
INSERT INTO tbl_proc_test VALUES ('27', '6');
INSERT INTO tbl_proc_test VALUES ('28', '24');
INSERT INTO tbl_proc_test VALUES ('29', '120');

-- ----------------------------
-- Table structure for `tbl_test1`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_test1`;
CREATE TABLE `tbl_test1` (
  `user` varchar(255) NOT NULL COMMENT '主键',
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`user`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='行列转换测试';

-- ----------------------------
-- Records of tbl_test1
-- ----------------------------
INSERT INTO tbl_test1 VALUES ('li', 'age', '18');
INSERT INTO tbl_test1 VALUES ('li', 'dep', '2');
INSERT INTO tbl_test1 VALUES ('li', 'sex', 'male');
INSERT INTO tbl_test1 VALUES ('sun', 'age', '44');
INSERT INTO tbl_test1 VALUES ('sun', 'dep', '3');
INSERT INTO tbl_test1 VALUES ('sun', 'sex', 'female');
INSERT INTO tbl_test1 VALUES ('wang', 'age', '20');
INSERT INTO tbl_test1 VALUES ('wang', 'dep', '3');
INSERT INTO tbl_test1 VALUES ('wang', 'sex', 'male');

-- ----------------------------
-- Procedure structure for `proc_test1`
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_test1`;
DELIMITER ;;
CREATE DEFINER=`root` PROCEDURE `proc_test1`(IN total INT,OUT res INT)
BEGIN   
    DECLARE i INT;  
    SET i = 1;
    SET res = 1;
    IF total <= 0 THEN   
        SET total = 1;   
    END IF;   
    WHILE i <= total DO
        SET res = res * i;
        INSERT INTO tbl_proc_test(num) VALUES (res);  
        SET i = i + 1;
    END WHILE;
END
;;
DELIMITER ;
```

### 说明

* 本课程介绍以MySQL SQL语法为基础，不同数据库SQL语法存在差异，并未完全遵照ANSI标准。
* 本课程结合一个实际项目（云音乐），介绍各种SQL语言在实际应用中如何实现业务功能。

### SQL进阶语法——order by

场景1：歌单按时间排序

```sql
-- 查看全部歌单
select * from play_list;

-- 按创建时间排序
select * from play_list order by createtime;
-- MySQL默认升序，如果按降序排列，则使用如下语句。
select * from play_list order by createtime desc;
-- 也可以按照多个字段来排序
select * from play_list order by bookedcount, trackcount;
```

### SQL进阶语法——distinct

场景2：统计云音乐创建歌单的用户

```sql
-- 有重复
select userid from play_list;

-- 去重
select distinct userid from play_list;

-- 多个字段
select distinct userid, play_name from play_list;
```

* distinct用于返回唯一不同的值
* 可以返回多列的唯一组合
* 底层实现使用排序，如果数据量大会消耗较多的IO和CPU

### SQL进阶语法——group by

场景3-1：统计云音乐创建歌单的用户列表和每人创建歌单的数量。

```sql
-- 每个用户歌单的最大订阅数
select userid, max(bookedcount) from play_list group by userid;

-- 每个用户歌单的数量
select userid, count(*) from play_list group by userid;
```

* group by 根据单列或多列对数据进行分组，通常结合聚合函数使用，如count(\*).

### SQL进阶语法——group by having

场景3-2：统计云音乐创建歌单的用户列表和每人创建歌单的数量，并且只显示歌单数量排序大于等于2的用户

```sql
select userid, count(*) from play_list group by userid having count(*) >= 2;
```

* having 是对结果进行过滤

SQL进阶语法-like

```sql
select * from play_list where play_name like '%男孩%';
```

| 通配符 | 描述 |
| :------------- | :------------- |
| % | 代替一个或多个字符 |
| _ | 代替单个字符      |
| [charlist] | 中括号中的任何一个字符 |
| [^charlist] 或者 [!charlist] | 不在中括号中的任何单一字符 |

* 除了百分号在最右面的情况以外，他会对这个表中所有的记录进行一次查询匹配，而没办法使用索引，效率较低。大表中需要慎用like。可以使用全文检索的手段。

### SQL进阶语法-limit, offset

场景4：查询一个月内创建歌单（从第6行开始显示10条记录）

```sql
select * from play_list where (createtime between 1427791323 and 1430383307) limit 10 offset 6;
```

* offset后的值不建议太大，需要消耗的IO较大

### case when

* case when 实现类似编程语言的if else功能，可以对SQL的输出结果进行选择判断。

场景5：对于未录入歌曲的歌单(trackcount = null)，输出结果时歌曲数返回0.

```sql
select case when play_name, trackcount is null then 0 else trackcount end from play_list;
```

### select相关进阶语法

```sql
SELECT
  [DISTINCT]
  select_expr [, select_expr ...]
  [FROM table_references
  [WHERE where_condition]
  [GROUP BY {col_name | expr | position}
    [ASC | DESC], ... [WITH ROLLUP]]
  [HAVING where_condition]
  [ORDER BY {col_name | expr | position}
    [ASC | DESC], ...]
  [LIMIT { [offset, ] row_count | row_count OFFSET offset}]
    [FOR UPDATE | LOCK IN SHARE MODE]]
```

### 连接-Join

连接的作用是用一个SQL语句把多个表中相互关联的数据查出来

场景6：查询收藏“老男孩”歌单的用户列表

```sql
select * from play_list, play_fav where play_list.id=play_fav.play_id;
select play_fav.userid from play_list, play_fav where play_list.id=play_fav.play_id and play_list.play_name='老男孩';
-- 另一种写法
select f.userid from play_list lst join play_fav f on lst.id=f.play_id where lst.play_name = '老男孩';
```

### 子查询

* MySQL还有另一种写法，可以实现同样的功能。
```sql
select userid from play_fav where play_id=(select id from play_list where play_name = '老男孩');
```

子查询：内层查询的结果作为外层的比较条件。一般子查询都可以转换成连接，推荐使用连接。

* 不利于MySQL的查询优化器进行优化，可能存在性能问题
* 连接的实现是嵌套循环，选择一个驱动表，遍历驱动表，查询内层表，依次循环。驱动表会至少查询一边，如果有索引等，内层表可以非常快，查询优化器会选择数据小的表作为驱动表。
* 子查询由人为规定驱动表和内层表

### 连接- left Join

```sql
select lst.play_name from play_list lst left join play_fav f on lst.id = f.play_id where f.play_id is null;
```

* LEFT JOIN从左表(play_list)返回所有的行，即使在右表中(play_fav)中没有匹配的行。
* 与LEFT JOIN相对应的有RIGHT JOIN关键字，会从右表那里返回所有的行，即使在左表中没有匹配的行。

场景7：查询出没有用户收藏的歌单

### SQL进阶语法-union

场景8：老板想看创建和收藏歌单的所有用户，查询play_list和play_fav两表中所有的userid

```sql
select userid from play_list union select userid from play_fav;
-- 默认会去重， 不想去重的话使用union all代替union。
```

### DML进阶语法

* 多值插入： insert into table values(....),(....)
  * 可以一次插入多行数据，减少与数据库的交互提高效率
  * eg： `insert into A values(4, 33), (5, 33);`
* 覆盖插入： replace into table values (....)
  * 可以简化业务逻辑的判断
* 忽略插入： insert ignore into table value (....)
  * 可以简化业务逻辑的判断
* 查询插入： insert into table_a select \* from table_b
  * 常用于导表操作
* insert主键重复则update
  * `INSERT INTO TABLE tbl VALUES (id, col1, col2) ON DUPLICATE KEY UPDATE col2=....;`
  * eg: `insert into A values(2, 40) on duplicate key update age=40;`
  * 可以简化前端业务逻辑的判断
* 连表update
  * A表：id, age
  * B表：id, name, age
  * A表id与B表id关联，根据B表的age值更新A表的age。
  * eg: `update A,B set A.age=B.age where A.id=B.id;`
* 连表删除
  * A表：id, age
  * B表：id, name, age
  * A表id与B表id关联，根据B表的age值删除A表的数据。
  * eg: `delete A from A,B where A.id=B.id and B.name='pw';`

### 总结

* select查询进阶语法
  * order by/distinct/group by having (聚合函数) /like (%前缀后缀)
* 连接语法
  * 内连接、左连接、右连接、 Union [ALL]
* DML进阶语法
  * insert/连表update/连表delete


## 2.5-内置函数

### 聚合函数

* 聚合函数面向一组数据，对数据进行聚合运算后返回单一的值。
* MySQL聚合函数的基本语法：`SELECT function(列) from 表`
* 常用聚合函数：

| 函数 | 描述 |
| :------------- | :------------- |
| AVG() | 返回列的平均值 |
| COUNT(DISTINCT) | 返回列去重后的行数 |
| COUNT() | 返回列的行数 |
| MAX() | 返回列的最大值 |
| MIN() | 返回列的最小值 |
| SUM() | 返回列的总和 |
| GROUP_CONCAT() | 返回一组值的连接字符串(MySQL独有) |

*实例还是上节中的那些表*

场景1：查询每张专辑总的点播次数和每首歌的平均点播次数。

```sql
select album, sum(playcount), avg(playcount) from song_list group by album;
```

场景2：查询全部歌曲中的最大的播放次数和最小的播放次数。

```sql
select max(playcount), min(playcount) from song_list;
```

场景2续：查询播放次数最多的歌曲

```sql
-- 错误查法
select song_name, max(playcount) from song_list;
-- 正确查法
select song_name, playcount from song_list order by playcount desc limit 1;
```

* `select count(*) from song_list;`
* `select count(1) from song_list;`
* `select count(song_name) from song_list;`

`count(*)`和`count(1)`基本一样，没有明显的性能差异。
`count(*)`和`count(song_name)`差别在于`count(song_name)`会除去song_name is null的情况

场景3：显示每张专辑的歌曲列表

```sql
select album, GROUP_CONCAT(song_name) from song_list group by album;
-- 默认最大只能连接1024个字符，但是可以通过改数据库参数来改变。
```

### 使用聚合函数做数据库行列转换

```sql
select user,
max(case when 'key'='age' then value end) age,
max(case when 'key'='sex' then value end) sex,
max(case when 'key'='dep' then value end) dep,
from tbl_test1
group by user;
```

### 预定义函数

* 预定义函数面向单值数据，返回一对一的处理结果(聚合函数可以理解成多对一)。
* 预定义函数基本语法：
  ```sql
  select function(列) from 表;
  select * from 表 where 列 = function(value) ...
  ```

### 预定义函数-字符串函数

| 函数 | 描述 |
| :------------- | :------------- |
| LENGTH() | 返回列的字节数 |
| CHAR_LENGTH() | 返回列的字符数 |
| TRIM()/RTRIM()/LTRIM() | 去除两边空格/去除右边空格/去除左边空格 |
| SUBSTRING(str, pos, [len]) | 从pos位置截取字符串str，截取len长度 |
| LOCATE(substr, str, [pos]) | 返回substr在str字符串中的位置 |
| REPLACE(str, from_str, to_str) | 将str字符串中的from_str替换成to_str |
| LOWER(), UPPER() | 字符串转换为小写/大写 |

* 字符串函数 - 实例

```sql
SELECT SUBSTRING('abcdef', 3);
-- 'cdef'
SELECT SUBSTRING('abcdef', -3);
-- 'def'
SELECT SUBSTRING('abcdef', 3, 2);
-- 'cd'
SELECT LOCATE('bar', 'foobarbar');
-- 4
SELECT LOCATE('xbar', 'foobar');
-- 0
SELECT LOCATE('bar', 'foobarbar', 5);
-- 7
```

### 预定义函数-时间处理函数

| 函数  | 描述 |
| :------------- | :------------- |
| CURDATE() | 当前日期 |
| CURTIME() | 当前时间 |
| NOW() | 显示当前时间日期(常用) |
| UNIX_TIMESTAMP() | 当前时间戳 |
| DATE_FORMAT(date, format) | 按指定格式显示时间 |
| DATE_ADD(date, INTERVAL unit) | 计算指定日期向后加一段时间的日期 |
| DATE_SUB(date, INTERVAL unit) | 计算指定日期向前减一段时间的日期 |

* 实例：

```sql
SELECT NOW() + INTERVAL 1 MONTH;
SELECT NOW() - INTERVAL 1 WEEK;
```

### 预定义函数-数字处理函数

| 函数 | 描述 |
| :------------- | :------------- |
| ABS() | 返回数值的绝对值 |
| CEIL() | 对小数向上取整 CEIL(1.2)=2 |
| ROUND() | 四舍五入 |
| POW(num, n) | num的n次幂 POW(2, 2)=4 |
| FLOOR() | 对小数向下取整 CELL(1.2)=1 |
| MOD(N, M) | 取模(返回n除以m的余数)=N % M |
| RAND() | 取0~1之间的一个随机数 |

### 算数、逻辑运算

* 比较运算

| 函数 | 描述 |
| :------------- | :------------- |
| IS, IS NOT | 判定布尔值 IS True, IS NOT False, IS NULL |
| >, >= | 大于，大于等于 |
| <, <= | 小于，小于等于 |
| = | 等于 |
| !=, <> | 不等于 |
| BETWEEN M AND N | 取M和N之间的值 |
| IN, NOT IN | 检查是否在或不在一组值之中 |

实例：查询一个月内userid为1,3,5的用户创建的歌单
```sql
select * from play_list where (createtime between 1427791323 and 1430383307) and userid in (1,3,5);
```

* `*,/,DIV,%,MOD,-,+`
* `NOT, AND, &&, XOR, OR, ||`


## 2.6-触发器与存储过程

### 触发器

* 是什么
  * 触发器是加在表上的一个特殊程序，当表上出现特定的事件(INSERT/UPDATE/DELETE)时触发该程序执行。
* 做什么
  * 数据订正；迁移表；实现特定的业务逻辑。

### 触发器-基本语法

```sql
CREATE
[DEFINER = { user | CURRENT_USER }]
TRIGGER trigger_name trigger_time
trigger_event ON tbl_name
FOR EACH ROW
trigger_body t

trigger_time: { BEFORE | AFTER }
trigger_event: { INSERT | UPDATE | DELETE }
```

### 触发器-实例

学生表：

```sql
CREATE TABLE `stu` (
  `name` varchar(50),
  `course` varchar(50),
  `score` int(11),
  PRIMARY KEY (`name`)
) ENGINE=InnoDB;
```

用于更正成绩的触发器：

```sql
DELIMITER //
CREATE TRIGGER trg_upd_score
BEFORE UPDATE ON `stu`
FOR EACH ROW
BEGIN
  IF NEW.score < 0 THEN
    SET NEW.score = 0;
  ELSEIF NEW.score > 100 THEN
    SET NEW.score = 100;
  END IF;
END; //
DELIMITER ;
```

### 注意事项

* 触发器对性能有损耗，应慎重使用。
* 同一类事件在一个表中只能创建一次。
* 对于事务表，触发器执行失败则整个语句回滚。
* Row格式的主从复制，触发器不会在从库上执行。
* 使用触发器时应防止递归执行。

### 存储过程

* 定义：存储过程是存储在数据库的一组SQL语句集，用户可以通过存储过程名和传参多次调用的程序模块。
* 特点：
  * 使用灵活，可以使用流控制语句，自定义变量等完成复杂的业务逻辑。
  * 提高数据安全性，屏蔽应用程序直接对表的操作，易于进行审计。
  * 减少网络传输。
  * 提高代码维护的复杂度，实际使用中要评估场景是否适合。

### 存储过程-基本语法

```sql
CREATE
  [DEFINER = { user | CURRENT_USER }]
  PROCEDURE sp_name ([proc_parameter[,...]])
  [characteristic ...] routine_body

proc_parameter:
  [ IN | OUT | INOUT ] param_name type
type:
  Any valid MySQL data type
characteristic:
    COMMENT 'string'
  | [NOT] DETERMINISTIC
routine_body:
  Valid SQL routine statement
```

### 存储过程-实例

```sql
CREATE PROCEDURE proc_test1
(IN total INT, OUT res INT)
BEGIN
  DECLARE i INT;
  SET i = 1;
  SET res = 1;
  IF total <= 0 THEN
    SET total = 1;
  END IF;
  WHILE i <= total DO
    SET res = res * i;
    INSERT INTO tbl_proc_test(num) VALUES (res);
    SET i = i + 1;
  END WHILE;
END;
```

### 存储过程-流控制语句

| 流控制 | 描述 |
| :------------- | :------------- |
| IF | IF search_condition THEN statement_list [ELSEIF search_condition THEN statement_list][ELSE statement_list] END IF |
| CASE | CASE case_value WHEN when_value THEN statement_list [ELSE statement_list] END CASE |
| WHILE | WHILE search_condition DO statement_list END WHILE |
| REPEAT | REPEAT statement_list UNTIL search_condition END REPEAT |

### 存储过程-调用

```sql
set @total=10;
set @res=1;
call proc_test1(@total, @res);
select @res;
```

### 自定义函数

* 自定义函数与存储过程类似，但是必须带有返回值(RETURN)。
* 自定义函数与sum(), max()等MySQL原生函数使用方法类似：
  ```sql
  SELECT func(val);
  SELECT * from tbl where col=func(val);
  ```
* 由于自定义函数可能在遍历数据中使用，要注意性能损耗

### 自定义函数-基本语法

```sql
CREATE
  [DEFINER = { user | CURRENT_USER}]
  FUNCTION sp_name ([func_parameter[,...]])
  RETURNS type
  [characteristic ...] routine_body
func_parameter:
  param_name type
type:
  Any valid MySQL data type
characteristic:
    COMMENT 'string'
  | [NOT] DETERMINISTIC
routine_body:
  Valid SQL routine statement
```

### 自定义函数-实例

```sql
CREATE FUNCTION func_test1 (total INT)
RETURNS INT
BEGIN
  DECLARE i INT;
  DECLARE res INT;
  SET i = 1;
  SET res = 1;
  IF total <= 0 THEN
    SET total = 1;
  END IF;
  WHILE i < total DO
    SET res = res * i;
    SET i = i + 1;
  END WHILE;
  RETURN res;
END;
```

### 自定义函数-调用

```sql
select func_test1(4);
```

### 小结

* 知识点：触发器、存储过程、自定义函数
* 互联网场景：触发器和存储过程不利于水平扩展，多用于统计和运维操作中。


## 2.7-MySQL字符集

### 字符集基础

* 字符集：数据库中的字符集包含两层含义
  * 各种文字和符号的集合，包括各国家文字、标点符号、图形符号、数字等。
  * 字符的编码方式，即二进制数据与字符的映射规则。

### 字符集-分类

* ASCII：美国信息互换标准编码；英语和其他西欧语言；单字节编码，7位表示一个字符，共128字符。
* GBK：汉字内码扩展规范；中日韩汉字、英文、数字；双字节编码；共收录了21003个汉字，GB2312的扩展。
* UTF-8:Unicode标准的可变长度字符编码；Unicode标准（统一码），业界统一标准，包括世界上数十种文字的系统；UTF-8使用一至四个字节为每个字符编码。
* 其他常见字符集：UTF-32，UTF-16，Big5，latin1

### MySQL字符集

* 查看字符集

```sql
SHOW CHARACTER SET;
```

* 新增字符集

```bash
# 编译时加入： --with-charset=
./configure --prefix=/usr/local/mysql3 --with-plugins=innobase --with-charset=gbk
```

### 字符集与字符序

* charset和collation
  * collation：字符序，字符的排序与比较规则，每个字符集都有对应的多套字符序。
  * 不同的字符序决定了字符串在比较排序中的精度和性能不同。

查看字符序

```sql
show collation;
```

mysql的字符序遵从命名惯例：以_ci(表示大小写不敏感)，以_CS(表示大小写敏感)，以_bin(表示用编码值进行比较)。

### 字符集设置级别

* charset和collation的设置级别：
  * 服务器级 >> 数据库级 >> 表级 >> 列级
* 服务器级
  * 系统变量(可动态设置)：
    * character_set_server：默认的内部操作字符集
    * character_set_system：系统元数据(各字段名等)字符集

### 字符集设置级别

* 服务器级

```
配置文件

[mysqld]
character_set_server=utf8
collation_server=utf8_general_ci
```

* 数据库级

```sql
CREATE DATABASE db_name CHARACTER SET latin1 COLLATE latin1_swedish_ci;
```

- character_set_database：当前选中数据库的默认字符集

主要影响load data等语句的默认字符集，CREATE DATABASE的字符集如果不设置，默认使用character_set_server的字符集。

* 表级

```sql
CREATE TABLE tbl1 (....) DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_bin;
```

* 列级

```sql
CREATE TABLE tbl1 (col1 VARCHAR(5) CHARACTER SET latin1 COLLATE latin1_german1_ci);
```

### 字符集设置级别

* 数据存储字符集使用规则：
  * 使用列集的CHARACTER SET设定值；
  * 若列级字符集不存在，则使用对应表级的DEFAULT CHARACTER SET设定值；
  * 若表级字符集不存在，则使用数据库级的DEFAULT CHARACTER SET设定值；
  * 若数据库级字符集不存在，则使用服务器级character_set_server设定值。

```sql
-- 查看字符集
show [global] variables like 'character%';
show [global] variables like 'collation%';

-- 修改字符集
set global character_set_server=utf8; -- 全局
alter table xxx convert to character set xxx; -- 表
```

### 客户端连接与字符集

* 连接与字符集
  * character_set_client：客户端来源数据使用的字符集。
  * character_set_connection：连接层字符集。
  * character_set_results：查询结果字符集。

```
mysql > set names utf8;

配置文件设置：
[mysql]
default-character-set=utf8
```

* 字符转换过程

client > character_set_client > character_set_connection > Storage > character_set_results >client

推荐使用统一的字符集

* 常见乱码原因：
  * 数据存储字符集不能正确编码(不支持)client发来的数据：client(utf8)->Storage(latin1)
  * 程序连接使用的字符集与通知mysql的character_set_client等不一致或不兼容。

* 使用建议
  * 创建数据库/表时显式的指定字符集，不使用默认。
  * 连接字符集与存储字符集设置一致，推荐使用utf8。
  * 驱动程序连接时显式指定字符集(set names XXX).

* mysql CAPI:初始化数据库句柄后马上用mysql_options设定MYSQL_CHARSET_NAME属性为utf8.
* mysql php API:连接到数据库以后显式用SET NAMES语句设置一次连接字符集。
* mysql JDBC: url="jdbc:mysql://localhost:3306/blog_dbo?user=xx&password=xx&userUnicode=true&characterEncoding=utf8"

### 小结

* 字符集：表示的字符集和/字符编码方式
* 字符的设置级别：服务器/数据库/表/列
* 客户端字符集：乱码产生的原因与解决方式


## 2.8程序连接MySQL

### 程序连接MySQL基本原理

JDBC客户端应用 -> java.sql.\*或javax.sql.\* -> 驱动程序 -> SQLserver/Oracle/MySQL

### Java代码示例

结构：

DriverManager
-> Driver(是驱动程序对象的接口，指向具体数据库驱动程序对象)=DriverManager.getDriver(String URL)
-> Connectinon(是连接对象接口，指向具体数据库连接对象)=DriverManager.getConnection(String URL)
-> Statement(执行静态SQL语句接口)=Connection.CreateStatement()
-> ResultSet(是指向结果集对象的接口)=Statement.excuteXXX()


```java
import java.sql.*;

/**
 * 使用JDBC连接MySQL
 */
public class DBTest {

    public static Connection getConnection() throws SQLException,
            java.lang.ClassNotFoundException
    {
        //第一步：加载MySQL的JDBC的驱动
        Class.forName("com.mysql.jdbc.Driver");

        //设置MySQL连接字符串,要访问的MySQL数据库 ip,端口,用户名,密码
        String url = "jdbc:mysql://localhost:3306/blog";        
        String username = "blog_user";
        String password = "blog_pwd";

        //第二步：创建与MySQL数据库的连接类的实例
        Connection con = DriverManager.getConnection(url, username, password);        
        return con;        
    }


    public static void main(String args[]) {
        Connection con = null;
        try
        {
            //第三步：获取连接类实例con，用con创建Statement对象类实例 sql_statement
            con = getConnection();            
            Statement sql_statement = con.createStatement();

            /************ 对数据库进行相关操作 ************/                
            //如果同名数据库存在，删除
            sql_statement.executeUpdate("drop table if exists user;");            
            //执行了一个sql语句生成了一个名为user的表
            sql_statement.executeUpdate("create table user (id int not null auto_increment," +
                    " name varchar(20) not null default 'name', age int not null default 0, primary key (id) ); ");

            //向表中插入数据
            System.out.println("JDBC 插入操作:");
            String sql = "insert into user(name,age) values('liming', 18)";

            int num = sql_statement.executeUpdate("insert into user(name,age) values('liming', 18)");
            System.out.println("execute sql : " + sql);
            System.out.println(num + " rows has changed!");
            System.out.println("");

            //第四步：执行查询，用ResultSet类的对象，返回查询的结果
            String query = "select * from user";            
            ResultSet result = sql_statement.executeQuery(query);

            /************ 对数据库进行相关操作 ************/

            System.out.println("JDBC 查询操作:");
            System.out.println("------------------------");
            System.out.println("userid" + " " + "name" + " " + "age ");
            System.out.println("------------------------");

            //对获得的查询结果进行处理，对Result类的对象进行操作
            while (result.next())
            {
                int userid =   result.getInt("id");
                String name    =   result.getString("name");
                int age        =   result.getInt("age");
                //取得数据库中的数据
                System.out.println(" " + userid + " " + name + " " + age);                
            }

            //关闭 result,sql_statement
            result.close();
            sql_statement.close();

            //使用PreparedStatement更新记录
            sql = "update user set age=? where name=?;";
            PreparedStatement pstmt = con.prepareStatement(sql);

            //设置绑定变量的值
            pstmt.setInt(1, 15);
            pstmt.setString(2, "liming");

            //执行操作
            num = pstmt.executeUpdate();

            System.out.println("");
            System.out.println("JDBC 更新操作:");
            System.out.println("execute sql : " + sql);
            System.out.println(num + " rows has changed!");

            //关闭PreparedStatement
            pstmt.close();


            //流式读取result，row-by-row
            query = "select * from user";            
            PreparedStatement ps = (PreparedStatement) con.prepareStatement
            (query,ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);  

            ps.setFetchSize(Integer.MIN_VALUE);  

            result = ps.executeQuery();  

            /************ 对数据库进行相关操作 ************/

            System.out.println("JDBC 查询操作:");
            System.out.println("------------------------");
            System.out.println("userid" + " " + "name" + " " + "age ");
            System.out.println("------------------------");

            //对获得的查询结果进行处理，对Result类的对象进行操作
            while (result.next())
            {
                int userid =   result.getInt("id");
                String name    =   result.getString("name");
                int age        =   result.getInt("age");
                //取得数据库中的数据
                System.out.println(" " + userid + " " + name + " " + age);                
            }

            //关闭 result,ps
            result.close();
            ps.close();
            con.close();

        } catch(java.lang.ClassNotFoundException e) {
            //加载JDBC错误,所要用的驱动没有找到
            System.err.print("ClassNotFoundException");
            //其他错误
            System.err.println(e.getMessage());
        } catch (SQLException ex) {
            //显示数据库连接错误或查询错误
            System.err.println("SQLException: " + ex.getMessage());
        }


    }

}
```

### JDBC使用技巧

* Statement与PreparedStatement的区别
* connection, Statement与ResultSet关闭的意义
* jdbc连接参数的使用
* ResultSet游标的使用(setFetchSize)

### Statement与PreparedStatement的区别

* PreparedStatement在数据库端预编译，效率高，可以防止SQL注入。
* 对数据库执行一次性存取的时候，用Statement对象进行处理。
* 线上业务推荐使用PreparedStatement.

### PreparedStatement背后的故事

PREPARE -> EXECUTE -> DEALLOCATE PREPARE

```sql
PREPARE stmt1 FROM 'SELECT productCode, productName
                    From products
                    WHERE productCode = ?';
SET @pc = 'S10_1678';
EXECUTE stmt1 USING @pc;

DEALLOCATE PREPARE stmt1;
```

### connection, Statement与ResultSet关闭的意义

* MySQL数据库端为connection与ResultSet维护内存状态，一直不关闭会占用服务端资源。
* MySQL最大连接数受max_connections限制，不能无限创建连接，所以用完要及时关闭。
* JDBC connection关闭后ResultSet, Statement会自动关闭。但是如果使用连接池将不会关闭，因此推荐主动关闭。

### jdbc连接参数的使用

* 字符集设置：

url="jdbc:mysql://localhost:3306/blog_dbo?userUnicode=true&characterEncoding=utf8";

* 超时设置：

url="jdbc:mysql://localhost:3306/blog_dbo?connectionTimeout=1000&socketTimeout=30000";


### ResultSet游标的使用

* 默认的ResultSet对象不可更新，仅有一个向前移动的指针。因此，只能迭代它一次，并且只能按从第一行到最后一行的顺序进行。可以生成可滚动和/或可更新的ResultSet对象。
* setFetchSize()是设置ResultSet每次向数据库取的行数，防止数据返回量过大将内存爆掉。

### Python连接MySQL

* Python：脚本语言，无需编译、易开发
* DBA使用Python的一般场景是编写自动化运维工具、报表、数据迁移
* Python MySQL驱动：python-mysqldb


```python
import MySQLdb

# 建立和mysql数据库的连接
conn = MySQLdb.connect(host='localhost', port=3306,user='bloguser',passwd='xxxx')
# 获取游标
curs = conn.cursor()

# 选择数据库
conn.select_db('blog')

# 执行SQL，创建一个表
curs.execute("create table blog (id int, name varchar(200))")

# 插入一条记录
value = [1, 'user1']
curs.execute("insert into blog values(%s, %s)", value)

# 插入多条记录
values = [(2, "user2"), (3, "user3")]
curs.executemany("insert into blog values(%s, %s)", values)

# 提交
conn.commit()

# 关闭游标
curs.close()
# 关闭连接
conn.close()
```


## 2.9-DAO框架的使用

### DAO框架

* 在应用程序中使用数据访问对象(DAO),使我们可以将底层数据访问逻辑与业务逻辑分离开来。DAO框架构建了为每一个数据源提供CRUD(创建、读取、更新、删除)操作的类。
* DAO模式是标准J2EE设计模式之一。开发人员用这种模式将底层数据访问操作与高层业务逻辑分离开。一个典型的DAO框架实现有以下组操作：
  * 一个DAO工厂类
  * 一个DAO接口(select/insert/delete/update)
  * 一个实现了DAO接口的具体类
  * 数据传输对象

### DAO框架的特点

* 屏蔽底层数据访问细节，实现业务逻辑和数据访问逻辑的分离。
* 简化代码开发，提高代码复用率。
* 相较于原生的SQL可能会带来额外的 性能损耗(利用反射机制封装对象，SQL转换等)

### MyBatis简介

* MyBatis是一个主流的DAO框架，是apache的一个开源项目iBatis的升级版。
* MyBatis支持普通SQL查询，存储过程和高级映射，消除就几乎所有JDBC代码和参数的手工设置以及结果集的检索。
* 接口丰富、使用简单
* 相较于hibernate更加轻量级，支持原生的sql语句。
* 支持查询缓存

### MyBatis代码示例

* 环境搭建，数据源于映射配置文件的编写
* 单值、多值查询
* 增删改数据
* 连表查询

**示例代码在sorence/DAO框架代码示例.rar**

### MyBatis工作流程

* 加载配置并初始化，内部生成MappedStatement对象。
* 调用MyBatis提供的API(SqlSession.select/insert....)，将SQL ID与数据对象传递给处理层。
* 处理层解析MappedStatement对象，获取MySQL的连接，执行相应的SQL语句，接收返回结果。
* MyBatis将接收到的返回结果封装成对应的数据对象返回。

### MyBatis使用技巧

* 区分`#{}`和`${}`的不同应用场景：
  `#{}`会生成预编译SQL，会正确的处理数据的类型，而`${}`仅仅是文本替换。
* 注意MyBatis封装数据时的性能损耗：
  只返回需要的行数和字段。
* 使用MyBatis自带的连接池功能：
  `<dataSource type="POOLED">`
