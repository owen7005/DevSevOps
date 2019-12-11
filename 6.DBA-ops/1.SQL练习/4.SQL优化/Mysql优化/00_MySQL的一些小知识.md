## Linux安装MySQL及一些基本设置
```
<1> yum -y install mysql-server 或者下载mysql-client以及mysql-server的rpm包并执行rpm -ivh xx
    安装mysql, 执行mysql --version查看是否安装成功
<2> 设置root密码:
      方式一: set password for root@fightzhong=password('abcdef');
      方式二: update mysql.user set password = password('abcdef') where user = 'root';
      方式三: /usr/bin/mysqladmin -u root password abcdef
<3> 设置mysql的自启动: [chkconfig mysqld on], 通过chkconfig --list | grep mysqld来查看是否设置
                      成功, 2-5均为on则设置成功
<4> 将/usr/share/mysql中的my-huge.cnf配置文件复制一份成my.cnf放在/etc/下
<5> 修改字符集编码: vim /etc/my.cnf
    <1> 在[client]栏下添加default-character-set=utf8
    <2> 在[mysqld]栏下添加:
          character_set_server=utf8
          character_set_client=utf8
          collation-server=utf8_general_ci
    <3> 在[mysql]栏下添加default-character-set=utf8

```

## MySQL之Linux目录
```
/var/lib/mysql: MySQL数据库文件的存放位置
/usr/share/mysql: MySQL配置文件目录
/usr/bin: MySQL相关命令目录
/etc/init.d/mysql: 启停相关脚本, 等价于service mysqld xxx;
```
## MySQL配置文件
```
二进制日志log-bin: 一般用于主从复制
错误日志log-error: 默认是关闭的, 记录严重的警告和错误信息, 以及每次启动和关闭的信息
以上两个可以通过在/etc/my.cnf配置文件中进行配置路径和文件名

查询日志log: 默认关闭, 记录查询的sql语句, 开启会降低mysql的整体性能
数据文件(创建一张表后进入/usr/lib/数据库名/目录):
  frm文件: 存放表结构
  myd文件: 存放表数据
  myi文件: 存放表索引
```

## MySQL逻辑架构
```
连接层: 最上层, 主要完成一些类似于连接处理、授权认证及相关的安全方案

服务层: 主要完成大部分的核心服务功能, 如SQL接口, SQL的解析, SQL的优化, 缓存的查询等, 以及部分内置
        函数的执行, 所有跨存储引擎的功能也在这一层实现, 如过程、函数等, 解析查询并创建响应的内部解
        析树, 进行相应的优化如确定查询表的顺序, 是否利用索引等, 最后生成相应的执行操作

引擎层: 存储引擎真正的负责了MySQL中数据的存储和提取, 服务器通过API与存储引擎进行通信, 不同的存储引
        擎具有的功能不同, 可以根据自己的实际需要进行选取

存储层: 主要讲数据存储在计算机的文件系统上, 并完成与存储引擎的交互
```

## MySQL存储引擎
```
查看数据库默认存储引擎:
	show engines;
	show variables like "%storage_engine%";

查看表的存储引擎:
show create table mylock;

修改表的存储引擎:
alter table mylock enigne=innodb;

MylSAM:
	不支持外键, 事务, 表锁, 即使操作一条记录也会锁住整个表, 不适合高并发的操作, 只缓存索引, 不缓存真
	实数据, 表空间小, 关注点是性能
InnoDB:
	支持外键, 事务, 行锁, 操作时只锁某一行, 不对其它行有影响, 适合高并发的操作, 不仅缓存索引还缓存真
	实数据, 对内存要求较高, 而且内存大小对性能有决定性的影响, 表空间大, 关注点是事务
```

## 性能下降SQL慢, 执行时间长, 等待时间长原因分析
```
假设一个表中有ID, name, email字段
<1> 查询语句写的不好, 比如在条件中用name = xxx这样的, 而不是id = xxx
<2> 索引失效
<3> 关联查询太多join
<4> 服务器调优及各个参数设置(缓冲、线程数等)
```


