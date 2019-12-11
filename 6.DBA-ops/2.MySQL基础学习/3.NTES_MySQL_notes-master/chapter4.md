# MySQL应用优化

## 4.1-MySQL索引优化与设计

### 什么是索引

* 索引的意义 —— 快速定位要查找的数据

### 数据库索引查找

* 全表扫描 VS 索引查找

### 如何根据首字母找到所在行

* 二分查找
* B+tree

### InnoDB表聚簇索引

索引中只放着排序字段和ID

### 创建索引

* 单列索引

```sql
create index idx_test1 on tb_student (name);
```

* 联合索引

```sql
create index idx_test2 on tb_student (name, age);
```
  * 索引中先根据name排序，name相同的情况下，根据age排序

### 索引维护

* 索引维护由数据库自动完成
* 插入/修改/删除每一个索引行都会变成一个内部封装的事务
* 索引越多，事务越长，代价越高
* 索引越多对表的插入和索引字段修改就越慢
* 控制表上索引的数量，切忌胡乱添加无用索引

### 如何使用索引

* 依据WHERE查询条件建立索引

```sql
select a, b from tab_a where c=? ;
idx_c (c)
select a, b from tab_a where c=? and d=?;
idx_cd (c, d)
```

* 排序order by, group by, distinct字段添加索引

```sql
select * from tb_a order by a;
select a, count(*) from tb_a group by a;
idx_a (a)

select * from tb_a order by a, b;
idx_a_b (a, b)

select * from tb_a order where c=? by a;
idx_c_a (c, a)
```

### 索引与字段选择性

* 某个字段其值的重复程度

* 选择性很差的字段通常不适合创建单列索引
  * 男女比例相仿的列表中性别不适合创建单列索引
  * 如果男女比例极不平衡，要查询的又是少数方(理工院校查女生)可以考虑使用索引
* 联合索引中选择性好的字段应该排在前面

```sql
select * from tab_a where gender=? and name=?;
idx_a1 (name, gender)
```

### 联合索引与前缀查询

* 联合索引能为前缀单列，复列查询提供帮助

```sql
idx_smp (a, b, c)
where a=? ;
where a=? and b=? ;
where a=? and c=? ;(部分ok)
```

* 合理创建联合索引，避免冗余
(a) , (a, b) , (a, b, c) X
(a, b, c) ok

### 长字段上的索引

* 在非常长的字段上建立索引影响性能
* InnoDB索引单字段(utf8)只能取前767 bytes
* 对长字段处理的方法
  * Email类，建立前缀索引
  ```sql
  Mail_addr varchar(2048)
  idx_mailadd (Mail_addr(30)) ok
  ```
  * 住址类，拆分字段
  ```sql
  Home_address varchar(2048)
  idx_mailadd (Mail_addr(30)) ? -- 很可能前半段都是相同的省市区街道名称
  Province varchar(1024), City varchar(1024), District varchar(1024), Local_address varchar(1024) ... -- 建立联合索引或单列索引
  ```

### 索引覆盖扫

* 最核心SQL考虑索引覆盖
  ```sql
  select Name from tb_user where UserID=?
  Key idx_uid_name(UserID, Name)
  ```
* 不需要回表获取name字段，IO最小，效率最高

### 无法使用索引的情况

* 索引列进行数学运算或函数运算
  ```sql
  where id+1=10; X
  where id = (10-1); ok
  year(col) < 2007; X
  col < '2007-01-01'; ok
  ```
* 未含符合索引的前缀字段
  ```sql
  Idx_abc (a, b, c):
  where b=? and c=?; X
  (b, c) ok
  ```
* 前缀通配,'\_'和'%'通配符
  ```sql
  Like '%xxx%'; X
  Like 'xxx%'; ok
  ```
* where 条件使用NOT, <>, !=
* 字段类型匹配
  * 并不绝对，但是无法预测地会造成问题，不要使用
  ```sql
  a int(11), idx_a (a)
  where a = '123'; X
  where a = 123 ; ok
  ```

### 利用索引排序

idx_a_b (a, b)

* 能够使用索引帮助排序的查询：

```sql
order by a
a = 3 order by b
order by a, b
order by a desc, b desc
a > 5 order by a
```

* 不能使用索引帮助排序的查询：

```sql
order by b
a > 5 order by b
a in (1, 3) order by b
order by a asc, b desc
```

### 如何确定一个查询走没走索引，走了哪个索引

* explain是确定一个查询如何走索引最简便有效的方法
  `explain select * from tb_test ;`
* 关注的项目
  * type:查询access的方式
  * key:本次查询最终选择使用哪个索引，NULL为未使用索引
  * key_len:选择的索引使用的前缀长度或者整个长度
  * rows:可以理解为查询逻辑读，需要扫描过的记录行数
  * extra:额外信息，主要指的fetch data的具体方式


## 4.2-MySQL数据库设计

### 什么是Schema设计

* 设计数据库的表，索引，以及表和表的关系
  * 在数据模型的基础上将关系模型转化为数据库表
  * 满足业务模型需要基础上根据数据库和应用特点优化表结构

### 为什么Schema需要设计

* Schema关系到应用程序功能与性能
  * 满足业务功能需要
  * 同性能密切相关
  * 数据库扩展性
  * 满足周边需求(统计，迁移等)
* 关系型数据库修改Schema经常是高危操作
  * Schema设计要体现一定的前瞻性

### 完全由开发者主导的Schema设计

* 着眼于实现当前功能
* 完全基于功能的设计可能存在一些隐患
  * 不合理的表结构或索引设计造成性能问题
  * 没有合理评估到数据量的增长造成空间紧张而且难以维护
  * 需求频繁修改造成表结构经常变更
  * 业务重大调整导致数据经常需要重构订正

### 基于性能的表设计

* 根据查询需要设计好索引
* 根据核心查询需求，适当调整表结构
* 基于一些特殊业务需求，调整实现方式

### 索引

* 正确使用索引
* 更新尽可能使用主键或唯一索引
* 主键尽可能使用自增ID字段
* 核心查询覆盖扫描
  * 用户登录需要根据用户名返回密码用于验证`create index idx_uname_passwd on tb_user (username, password);`
  * 建立联合索引避免回表取数据

### 反范式，冗余必要字段

* 针对核心SQL保留查询结果所必须的冗余字段，避免频繁join
  * 例：消息表中冗余了每次读消息必须返回的nickname字段，避免每次读消息都变成join操作。代价是用户修改nickname成本变高。

### 拆分大字段

* 拆分大字段到单独表中，避免范围扫描代价大
  * 例：博文表拆分两份，标题表只保留标题和内容缩略部分，用于快速批量返回标题列表，正文表保存大段博文内容，用于点开文章单个读取

### 避免过多字段或过长行

* 根据SQL必要返回设计字段，有必要就拆表，避免过多字段
* 一次没有必要获取那么多列数据
* 行过长导致表数据页记录变少，范围扫描性能降低
* 更新数据也代价增加
* 16K也最少放2行，可能出现行迁移

### 分页查询

* 避免limit + offset过大
* 应该使用自增主键ID模拟分页
  * 第一页，直接查
  * 得到第一页的max(id)=123(一般是最后一条记录)
  * 第二页，带上id>123查询：where id>123 limit 100
  * 这样每次只需要扫描100条数据
* 要求业务上禁止查询XX页之后的数据

### 热点读数据特殊处理

* 根据数据获取的频率或数量不同对热点数据做特殊处理
  * 例1：论坛系统中置顶帖、公告贴，可以单独拆分存储，由于每次访问都要全部读出来，单独放在一起，避免每次都到普通表中随机找出来

### 热点写数据特殊处理

* 根据数据获取的频率或数量不同对热点数据做特殊处理
  * 例2：微博系统中对于大量关注的热点账号消息从"推"改为"拉"，避免过量insert操作。

### 准实时统计

* 对不需要精确结果的计数等统计要求，建立定期更新结果表
  * 例：首页要求展示动态成交总金额，维护一个计数表，每分钟根据原表注册时间获取增量sum值更新计数表，避免每次用户刷新都要扫描交易全记录表

### 实时统计改进1 - 触发器实时统计

* 对需要精确统计的计数利用数据库触发器维护计数表
  * 例：用户量冲亿活动要求实时统计，用户表上加触发器，每次有新用户插入就同时在计数表+1

### 实时统计改进2 - 缓存实时统计

* 对需要精确统计的计数利用前端缓存实时维护计数
  * 例：用户量冲亿活动要求实时统计，注册数量在缓存中实时维护，每注册一个就+1，完全避免数据库读写操作。缓存万一故障失效，可从数据库整体count重新获取。

### 实时统计改进2 - 最大自增ID获取总数

* 很多逻辑可以利用自增ID主键最大值直接作为总数
  * 例：用户量冲亿活动要求实时统计，用户表加上自增ID作为主键，只要取当时max(ID)就可以得到用户总数

### 课拓展性设计

* 可拓展性
  * 硬件资源增长有极限的情况下处理尽可能久的线上业务
* 数据分级，冷数据归档与淘汰
  * 可以不断释放空间供新数据使用
* 为数据分布式做准备
  * 分库分表
  * 水平拆分
  * 牺牲一定的关系模型支持

### 分区表与数据淘汰

* range分区
* 适合数据需要定期过期的大表
* 单个分区扫描迁移数据到历史库避免全表扫描IO开销
* 删除单个分区非常高效

### 分区表与垂直分区

* list分区
* 适合将来可能要基于地区，类目等方式垂直拆分数据的方式
* 清理节点上不要的数据非常高效

### 分区表与水平分区

* hash分区
* 适合将来需要做水平拆分的表
* 清理节点上不要的数据非常高效

### MySQL分区表的局限

* 主键或唯一键必须包含在分区字段内
* 分区字段必须是整数类型，或者加上返回整数的函数

### 满足周边需求

* 为周边需求额外增加表设计
  * 为后台统计任务增加特殊索引
  * 为数据迁移或统计需求增加时间戳

### 统计和后台需求

* 统计运行SQL往往和线上有很大不同
  * 利用MySQL——主多从，主从可以建不同索引的特性将统计分流到特定从库
  * 包括一些特殊用户批量查询等，所有对线上有IO压力的查询都要读写分离

### 自动更新时间戳

* 统计需求经常要求从线上读走增量数据
* 表的第一个timestamp类型字段再写入时如果不填值，会自动写入系统时间戳
* 表的第一个timestamp类型字段每次记录发生更新后都会自动更新
* 在update_time字段上建索引用于定时导出增量数据

### Schema设计与前瞻性

* 基于历史经验教训，预防和解决同类问题
* 把折腾DBA够呛的所有Schema改造的原因记录并分析总结
例：
* 业务为例用户信息加密做了大改造
  * 数据库结果大量改动，增加了加密字段，验证策略表，所有表重新订正数据等等
  * 是否所有用到用户信息管理的应用都要去上线就用密文？
* 程序bug误删数据，线上风险大
  * 改造业务流程，不再删除数据，加入is_deleted标记位，经常给各种表加
  * 今后的类似表是否一上线就都用标记位的方式，并加上修改原因字段？
* 支付类应用后期做了风控改造
  * 对线上订单大表改造，加了限额，终端类型等字段
  * 遇到支付类应用，是否一上线就提示业务是否需要考虑风控并留好相关字段？


## 4.3-MySQL容量评估

### 性能容量评估

* 分析线上业务场景
* 评估数据库服务器所需性能指标
* 预估可能成为瓶颈的服务器资源
* 帮助数据库性能调优

### 数据库服务器硬件性能指标

* 磁盘IO性能
* 内存容量
* CPU
* 网络吞吐量
* 磁盘容量

### 数据库业务特点关键词

* OLTP/OLAP类型
* 并发请求
* 读写比例
* 数据量
* 冷热数据比
* 数据分级存储

### OLTP/OLAP

* T = Transaction
* 面向广大用户，高并发，较短事务操作
* 互联网应用绝大部分属于OLTP
* OLTP看重服务器CPU，内存，写事务较多或内存不够则依赖磁盘IO
* A = Analytical
* 通常面向内部人员，大规模复查询
* OLAP看重磁盘扫描的IO能力，部分依赖内存排序

### 并发请求 - 衡量线上业务繁忙程度

* 业务高峰时数据库的每秒并发访问量是多少
* 通过应用服务器数量，连接池配置判断
* 通过产品估算初上线用户规模和用户增长速度判断
* 通过实际业务业务类型判断
* 并发量相关资源：CPU

### 读写比例 - 描述应用程序如何使用数据库

* 线上业务select只读与update/delete/insert写操作比例
* delete/update通常都是先读再写
* insert需要区分数据写入时持续insert还是大量导入数据
* 根据业务实际场景分析
* 多读场景相关资源：内存
* 多写场景相关资源：磁盘IO

### 数据量 - 总量

* 数据库服务器存储设备可扩容能力的上限
* 根据估算的业务量，写入模式，分析数据增长量
* 预估一个硬件升级周期内数据库可存放数据的总量，上线时要留好余量
* 数据总量相关资源：磁盘容量

### 冷数据与热数据 - 有用数据的实时集合

* 热数据，线上最新一定周期内将被反复访问的数据
* 冷数据，线上保存着的，最近不会被在线用户用到的数据
* 估算活跃用户量，数据增长量等预估热数据量
* 内存大小尽可能足够存放线上实时热数据
* 热数据相关资源：内存

### 线上数据分层存储 - 缓解线上磁盘空间压力

* 最新热数据确保放在内存中
* 还可能访问到的较早数据存放在线上库磁盘中
* 更早的不会常规访问的数据定期迁移至历史库中
* 区分哪些数据时效性强可以迁移

### 服务器资源选型 - 将可选方案列出来

| 资源指标 | 可选方案 |
| :------------- | :------------- |
| 磁盘IO性能 | 单盘 -> 盘阵; SATA -> SAS; HDD -> SSD |
| 内存容量 | 较小内存 -> 较大内存 |
| CPU | 普通 -> 多核，超线程 |
| 网络吞吐量 | 千兆 -> 万兆; 单网卡 -> 多路; |
| 磁盘容量 | 单盘 -> 盘阵; 单盘 -> LVM |

### 案例一，网易云音乐曲库数据库服务器评估

* 用于存放线上数千万歌曲信息
* 确定属于OLTP线上类型数据库
* 并发请求量
  * 50台应用服务器，每台最大连接数100
  * 可能峰值5000qps，并发请求量较大
* CPU需求高
* 读写比例
  * 访问模式以用户列出歌单和播放歌曲时查询歌曲信息为主，用户只有只读查询
  * 写数据发生在录入新歌或修改歌曲信息时后台操作，写比例小，且为批量导入
  * 读写比100:1
* 数据总量
  * 估算每首歌信息8K，总计5000万，总量400G
  * 数据总量增长相对缓慢
* 冷热数据
  * 5000万歌曲中大约40%可能被访问，10%属于热点歌曲
  * 热数据大约<=40G
* 数据分级存储需求
  * 由于没有用户产生的数据，歌曲信息无法分级存储
* 内存需求一般，>=40G
* 磁盘IO能力需求一般
* 网络流量要求，8k*2500/1024 ≈ 20MB/S，一般

| 资源指标 | 可选方案 |
| :------------- | :------------- |
| 磁盘IO性能 | 两块SAS做RAID1 |
| 内存容量 | 96G内存 |
| CPU | 2c8core超线程 相当于32核 |
| 网络吞吐量 | 千兆双网卡bunding |
| 磁盘容量 | 900G |

### 案例二，网易理财销售数据库服务器评估

* 用于存放理财用户线上订单
* 确定属于OLTP线上类型数据库
* 业务场景有明显特征
  * 特定高息产品秒杀销售时间窗有大量并发订单写入
  * 平时只有少量订单查询和请求，和较低的常规产品购买请求
* 评估应以满足最关键的业务高峰为基准
* 并发请求量
  * 秒杀期间持续时间短，但是并发量预估30台应用服务器约2000tps
* 读写比例
  * 高峰时写订单是主要开销操作
* CPU要求高
* 磁盘IO要求很高
* 数据总量
  * 根据业务分析，订单属于写入瞬时量大，总量较小，单笔金额较高
  * 总量预估一年成交百万级别，增长较稳定
  * 判断数据存储需求小于200G
* 冷热数据
  * 峰值写入为主，内存要求存放热点期间产生的脏数据即可
* 数据分级存储需求
  * 用户订单业务约定页面展示最近半年订单，半年前的需要到历史查询页面专门查询
  * 因此可以做分级存储，迁移所有半年前的订单至历史库
* 内存需求一般， >= 30G
* 磁盘空间需求一般， >=200G
* 磁盘IO能力需求很高
* 网络要求较高
  * 并发流量较高
  * 响应速度要求高

| 资源指标 | 可选方案 |
| :------------- | :------------- |
| 磁盘IO性能 | 两块SSD做RAID1 |
| 内存容量 | 64G内存 |
| CPU | 2c8core超线程 相当于32核 |
| 网络吞吐量 | 万兆双网卡bunding |
| 磁盘容量 | 600G |


## 4.4-MySQL性能测试

### 为什么需要性能测试

* 对线上产品缺乏心理预估
* 重现线上异常
* 规划未来的业务增长
* 测试不同硬件软件配置

### 性能测试的分类

* 设备层的测试
* 业务层的测试
* 数据库层的测试

### 设备层的测试

* 关注的指标
  * 服务器、磁盘性能
  * 磁盘坏块率
  * 服务器寿命

### 业务层测试

* 针对业务进行测试

### 数据库层测试

* 什么情况下要做MySQL的测试
  * 测试不同的MySQL分支版本
  * 测试不同的MySQL版本
  * 测试不同的MySQL参数搭配

### MySQL测试分类

* CPU Bound
* IO Bound

写入测试
更新测试
纯读测试
混合模式

### 常用的测试工具

* 开源的MySQL性能测试工具
  * sysbench
  * tpcc-mysql
  * mysqlslap
* 针对业务编写性能测试工具
  * blogbench

### 性能测试衡量指标

* 服务吞吐量(TPS, QPS)
* 服务响应时间
* 服务并发性

### Sysbench

* 业界较为出名的性能测试工具
* 可以测试磁盘、CPU、数据库
* 支持多种数据库：Oracle, DB2, MySQL
* 需要自己下载编译安装
* 建议版本：sysbench0.5

### 编译安装Sysbench

* 下载sysbench
  * `git clone https://github.com/akopytov/sysbench.git`
* 编译&安装
  * `./autogen.sh`
  * `./configure`
  * `make && make install`

### Sysbench流程

* 常见的做法

初始化数据 -> 运行测试 -> 清理数据

### Prepare语法

```bash
sysbench --test=parallel_prepare.lua --oltp_tables_count=1 --rand-init=on --oltp-table-size=500000000 --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=sys --mysql-password=netease --mysql-db=sbtest --max-requests=0 prepare
```

| 参数 | 含义 |
| :------------- | :------------- |
| --test=parallel_prepare.lua | 运行导数据的脚本 |
| --oltp_tables_count | 测试需要几张表 |
| --oltp-table-size | 每张表的大小 |
| --mysql-host | MySQL Host |
| --mysql-port | MySQL Port |
| --mysql-db | MySQL DB |
| --mysql-user | MySQL User |
| --mysql-password | MySQL Password |
| --rand-init | 是否随机初始化数据 |
| --max-requests | 执行多少个请求之后停止 |
| prepare | 执行导数据 |

### Sysbench表结构

```sql
create table 'sbtest1'(
  'id' int(10) unsigned not null AUTO_INCREMENT,
  'k' int(10) unsigned not null DEFAULT '0',
  'c' char(120) not null DEFAULT '',
  'pad' char(60) not null DEFAULT '',
  PRIMARY KEY ('id'),
  KEY 'k_1' ('k')
) ENGINE=InnoDB AUTO_INCREMENT=3000000001 DEFAULT CHARSET=utf8 MAX_ROWS=1000000
```

### Run语法

```bash
sysbench --test=oltp.lua --oltp_tables_count=1 --num-threads=100 --oltp-table-size=500000000 --oltp-read-only=off --report-interval=10 --rand-type=uniform --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=sys --mysql-password=netease --mysql-db=sbtest --max-time=1000 --max-requests=0 run
```

| 参数 | 含义 |
| :------------- | :------------- |
| --test=oltp.lua | 需要运行的lua脚本 |
| --oltp_tables_count | 测试需要几张表 |
| --oltp-table-size | 每张表的大小 |
| --num-threads | 测试并发线程数 |
| --oltp-read-only | 是否为只读测试 |
| --report-interval | 结果输出间隔 |
| --rand-type | 数据分布模式，热点数据或者随机数据 |
| --max-time | 最大运行时间 |
| --max-requests | 执行多少个请求之后停止 |
| prepare | 开始测试 |

### 特殊情况

* 写入测试

写入数据进行测试 -> 清理数据

### cleanup

* 手动drop掉表和database
* 使用sysbench提供的cleanup命令

```bash
sysbench --test=parallel_prepare.lua --oltp_tables_count=1 --rand-init=on --oltp-table-size=500000000 --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=sys --mysql-password=netease --mysql-db=sbtest --max-requests=0 cleanup
```

### Tpcc-mysql

* TPC-C是专门针对联机交易处理系统(OLTP系统)的规范
* Tpcc-mysql由percona根据规范实现

* 下载Tpcc-mysql
  * `bzr branch lp:~percona-dev/perconatools/tpcc-mysql`
* 编译安装

### 使用Tpcc-mysql的步骤

创建表结构和索引 -> 导数据 -> 运行测试 -> 数据清理

### 创建表结构

* create_table.sql
* add_fkey_idx.sql

### Tpcc-load

`tpcc_load [server] [DB] [user] [pass] [warehouse]`

| 函数 | 含义 |
| :------------- | :------------- |
| server | 数据库IP |
| DB | DB名称 |
| user | 用户名 |
| pass | 密码 |
| warehouse | 仓库数量 |

### Tpcc-start

```bash
tpcc_start -h server_host -P port -d database_name -u mysql_user -p mysql_password -w warehouse -c connections -r warmup_time -I running_time -i report-interval -f report-file
```

| 函数 | 含义 |
| :------------- | :------------- |
| warehouse | 仓库数量 |
| connections | 并发线程数 |
| warmup_time | 预热时间 |
| running_time | 运行时间 |
| report_interval | 输出时间间隔 |
| report_file | 输出文件 |

### 总结

* IO Bound测试数据量要远大于内存、CPU Bound测试数据量要小于内存
* 测试时间建议大于60分钟，减小误差
* Sysbench更倾向于测试MySQL性能、TPCC更接近于业务
* 运行测试程序需要同时监控机器负载，MySQL各项监控指标
