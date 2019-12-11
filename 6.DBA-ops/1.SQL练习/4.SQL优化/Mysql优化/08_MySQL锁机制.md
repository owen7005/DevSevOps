## 锁的分类
```
按照锁的实现原理不同分为: 悲观锁, 乐观锁
按照锁的粒度不同分为: 表锁, 行锁
按照锁的形式不同分为: 读锁, 写锁
按照锁的形式不同分为: 共享锁, 排他锁
```

## 悲观锁和乐观锁
```
乐观锁: 以无锁实现有锁的操作, 一般这样来实现, 我们会在数据库中对表增加一个version字段, 当我们需要
        修改一个字段时, 比如[update product set stock = stock - 1 where product_id = 1;]表示
        将产品id为1的产品的库存减少1个, 那么就有可能出现这么一种情况, 库存只剩下一个了, 然后两个请
        求同时去修改这个库存, 导致库存数量最后变成了-1个, 在两个请求修改这个库存之前会先查询库存数
        量, 当数量为0的时候就不能去修改了, 下面我们先演示一下问题出现的情况, 然后通过增加的version
        字段来演示通过乐观锁防止问题的发生
  情景一(stock为1):
    请求一: select stock from product where product_id = 1; // 得到stock为1
    请求二: select stock from product where product_id = 1; // 得到stock也为1

    请求一: 发现库存为1, 则去修改库存, update product set stock = stock - 1 where product_id = 1
            此时库存数量变为0了
    请求二: 因为之前查询的时候库存为1, 其也去执行修改库存的操作:
            update product set stock = stock - 1 where product_id = 1;
            然而因为请求一已经修改过了, 库存应该是0, 此时请求二执行了更新操作后, 库存就变为了0了
  情景二(stock为1):
    请求一: select stock,version from product where product_id = 1; // 得到stock为1,version为1
    请求二: select stock,version from product where product_id = 1; // 得到stock也为1,version也为1

    请求一: 发现库存为1(此时version为1), 则去修改库存:
            update product set stock = stock - 1, version = version + 1 where product_id = 1 and version = 1;
            此时库存数量变为0了, version变为了2
    请求二: 发现库存为1(此时version为1), 则去修改库存:
            update product set stock = stock - 1, version = version + 1 where product_id = 1 and version = 1;
            因为请求一在修改库存的时候修改了版本号, 所以此时数据库中product_id为1的条目的版本为2了,
            所以请求二的修改失败
    情景二就是乐观锁的实现了, 即利用数据库的一个字段来实现了数据的一致性

悲观锁: 即真正意义上的锁, 下面讲解的表锁, 行锁, 间隙锁, 共享锁, 排他锁都是悲观锁
```

## 读锁和写锁
```
对于读锁和写锁来说, 在我的github的并发编程笔记上对Java层面的读写锁进行了实现, 并且实现了写优先原则,
同样在我的github的计算机操作系统笔记上关于进程间的通信中对读写锁也进行了详细的描述, 读写锁, 读读不
互斥, 读写互斥, 写写互斥, 一个线程在写, 其它线程不能进行读和写, 这就是读写锁的特征, 而MySQL的表锁
就是利用读锁和写锁来进行加锁的, 对一个表加锁可以加读锁, 也可以加表锁, 下面关于表锁的描述中我会对这些
进行验证
```

## 表锁
```sql
特点: 开销小, 加锁快; 无死锁; 锁定粒度大, 发生锁冲突的概率最高, 并发度最低(因为锁的是一个表, 每个
      会话的操作都需要获取锁)

查看有哪些表加锁:
  show open tables;
增加表锁(可以增加读锁/写锁):
  lock table 表名字1 read(write), 表名字2 read(write);
解锁:
  unlock tables;
分析表锁定:
  show status like "table%";
  结果分析:
    Table_locks_immediate: 产生表级锁定的次数, 表锁可以立即获取锁的查询次数, 每立即获取锁值加1,
                            当我们对一个表进行增删改之后, Table_locks_immediate值就会加1, 增删
                            改之后的查询也会使得该值加1
    Table_locks_waited: 出现表级锁定争用而发生等待的次数(不能立即获取锁的次数, 每等待一次锁值加1),
                        此值越高说明存在着较严重的表级锁争用情况

表锁的实验:
一、建表
Create Table: CREATE TABLE `mylock` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8

二、插入数据
insert into mylock(name) values("a"),("b"),("c"),("d"),("e");

表锁之读锁:
  创建两个会话, 分别为1, 2, 会话1给该表增加一个读锁[lock table mylock read;], 执行sql查询其它表
  [select * from students], 发现查询失败, 执行sql查询mylock表[select * from mylock], 查询成功,
  执行sql更新mylock表[update mylock set name = "aa" where id = 1], 更新失败

  会话2执行sql查询其它表[select * from students], 查询成功, 执行sql查询mylock表[select * from mylock],
  查询成功, 执行sql更新mylock表[update mylock set name = "aa" where id = 1], 更新失败

表锁之写锁:
   创建两个会话, 分别为1, 2, 会话1给该表增加一个写锁[lock table mylock write;], 执行sql查询其它表
  [select * from students], 发现查询失败, 执行sql查询mylock表[select * from mylock], 查询成功,
  执行sql更新mylock表[update mylock set name = "aa" where id = 1], 更新成功

  会话2执行sql查询其它表[select * from students], 查询成功, 执行sql查询mylock表[select * from mylock],
  查询失败, 执行sql更新mylock表[update mylock set name = "aa" where id = 1], 更新失败

总结:
  表锁偏向MyISAM存储引擎, MyISAM在执行查询语句(select)前, 会自动给涉及的所有表加读锁, 在执行增删
  改操作前, 会自动给涉及的表加写锁, 对MyISAM表的读操作(加读锁), 不会阻塞其它进程对同一表的读请求,
  但会阻塞对同一表的写请求,只有当读锁释放后, 才会执行其它进程的写操作, 对MyISAM表的写操作(加写锁),
  会阻塞其它进程对同一表的读和写操作, 只有当写锁释放后, 才会执行其它进程的读写操作, 简而言之, 就是
  读锁会阻塞其它会话对该表的写, 但是不会阻塞读, 而写锁会把其它会话对该表的读和写都阻塞

MyISAM的读写锁调度是写优先, 这也是该引擎不适合做写为主表的引擎, 因为写锁后, 其它线程不能做任何操作,
大量的更新会使得查询很难得到锁, 从而造成永远阻塞
```

## 行锁
```
行锁:
  偏向InnoDB存储引擎, 开销大, 加锁慢; 会出现死锁; 锁定粒度最小, 发生锁冲突的概率最低, 并发度也最高
  InnoDB与MyISAM的最大不同有两点: 一是支持事务, 二是采用了行级锁, 对于表锁来说, 在两种引擎中均适用,
  只不过在MyISAM引擎中会自动对CRUD操作增加表锁, 但是在InnoDB中不会而已, 当然我们可以手动对一个表进
  行加表锁,对于行锁来说, 只有在InnoDB引擎中才会生效, 并且必须是在事务中, 即autocommit为0的情况下

建表&插入数据:
  create table mylock(a int, b varchar(10)) engine=innodb;
  create index mylock_a_idx on mylock(a);

  insert into mylock values(1, "a");
  insert into mylock values(3, 3000);
  insert into mylock values(4, 4000);
  insert into mylock values(5, 5000);
  insert into mylock values(6, 6000);
  insert into mylock values(7, 7000);
  insert into mylock values(8, 8000);
  insert into mylock values(1, "b");

实验一: 行锁的演示
  <1> 开启两个会话, 均执行set autocommit = 0;开启手动提交
  <2> 会话1执行[select * from mylock where a = 3], 会话2执行[select * from mylock where a = 3]
      执行正常, 不会发生阻塞的情况, 两者执行commit提交
  <3> 会话1执行[update mylock set b = 3001 where a = 3], 会话2执行[select * from mylock where a = 3],
      执行正常, 不会发生阻塞的情况, 两者执行commit提交
  <4> 会话1执行[update mylock set b = 3002 where a = 3], 会话2执行[update mylock set b = 4001 where  a= 4]
      执行正常, 没有发生阻塞, 说明表锁肯定是没触发的, 会话2继续执行[update mylock set b = 3003 where a = 3]
      , 结果会话2进入阻塞, 行锁生效了, 因为会话1还没有commit, 当会话1commit的时候, 会话2才会执行
      成功

无索引行锁升级为表锁:
  可以根据我们创建表的sql得知, 给字段a创建了一个单值索引, 那么我们在update语句中where是会用到该
  索引的, 如果此时我们将该索引删除, 再重复上述的实验, 则会因为无索引行锁升级为表锁
  <1> drop index mylock_a_idx on mylock; commit;
  <2> 开启两个会话, 均执行set autocommit = 0;开启手动提交
  <3> 会话1执行[update mylock set b = 3002 where a = 3], 会话2执行[update mylock set b = 4001 where  a= 4],
      会话2进入阻塞状态, 因为行锁只是锁定一行而已, 所以会话1锁定的一定是a为3的那一行, 而不会锁住a
      为4的那一行, 所以会话2锁住证明了是表锁的原因, 继而得出无索引行锁升级为表锁
  <4> 索引需要被用到才能防止行锁升级为表锁, 假设我们删除了a索引, 而建立了b索引, 由于where语句中没有
      用到b, 所以b索引是没有生效的, 则仍然会触发行锁升级为表锁
```

## 行锁之间隙锁
```
什么是间隙锁: 当我们用范围条件而不是相等条件检索数据, 并请求共享或排他锁时, InnoDB会给符合条件的已
有数据记录的索引项加锁;对于键值在条件范围内但并不存在的记录, 叫做"间隙(GAP)", InnoDB也会对这个
"间隙"加锁, 这种锁机制就是所谓的间隙锁

间隙的范围: 当我们执行了[update mylock set b = "6666" where a > 3 and a < 6]语句后, 间隙的范围
是(3, 6), 此时MySQL的间隙锁会将a在(3,6)范围内的数据(即使不存在)进行锁定, 所以此时我们假设执行插入
语句[insert into mylock values(3, "3000")], 则会被阻塞住, 而执行[insert into mylock values(2, "2000")]
则不会被阻塞, 经过测试, 如果对3,6进行update可以不被阻塞, 而插入是会的, 但是对于这两者之间的其它值
进行update和insert都会被阻塞

实验:
  事务一: update mylock set b = "6666" where a > 3 and a < 6;
  事务二: select * from mylock where a > 3 and a < 6; 执行成功
          insert into mylock values(2, "2000"); 执行成功
          insert into mylock values(7, "7000"); 执行成功
          insert into mylock values(3, "3000"); 执行失败, 间隙锁生效
          insert into mylock values(4, "4000"); 执行失败, 间隙锁生效
          insert into mylock values(6, "6000"); 执行失败, 间隙锁生效
          update mylock set b= "4001" where a = 4; 执行失败, 间隙锁生效
  只有当事务一commit后事务二的阻塞才会被取消, 另外, 以上的实验都是基于行锁生效的情况下, 即字段a必须
  存在索引, 无索引的情况下会导致全表扫描, 行锁不会生效, 而是升级为表锁
```

## 行锁之for update(排他锁)
```
我们直接利用一个案例来描述for update的用法:
事务一:
  select * from mylock where a = 3 for update;
事务二:
  update mylock set b = "4001" where a = 4; // 执行成功
  update mylock set b = "3001" where a = 3; // 执行失败, 处于阻塞状态, 排他锁生效
事务一:
  update mylock set b = "3002" where a = 3; // 执行成功
  commit;
事务二在事务一commit后退出阻塞状态, update语句执行成功, 这就是排他锁的作用, 可以确保一个事务在修改
一行数据前该行的数据和该事务在之前获取的数据是相同的, 也就是说, 假设我这个事务在修改该行数据前先进行
了select操作, 为了防止select之后其它事务对该数据进行操作, 我可以对该行加一个排他锁, 这样我就可以在
自己想要对该数据进行操作前能够保证该行数据不被修改, 不然就会出现下面的情况:
  事务一: select * from mylock where a = 3;
  事务二: delete from mylock where a = 3; => commit;
  事务一: update mylock set b = "3333" where a = 3;
          // 发现影响的行数为0, 即出现了幻读的问题, 因为此时事务一已经对该行进行了删除操作
  如果事务一想要自己的操作不被影响, 即想要select语句后的update语句仍然是原来的数据, 那么就可以通过
  在select语句后面增加for update来给该行加一个排他锁, 这样在该事务提交之前其它事务对该行的操作都会
  被阻塞了
```

## lock in share mode(共享锁)
```
共享锁的作用是允许该行被多个事务进行读取, 但是其它事务不能对该行进行修改

情景一:
  事务一: select * from mylock where a = 3 lock in share mode;
  事务二: select * from mylock where a = 3; // 读取成功
          update mylock set b = 3000 where a = 3; // 进入阻塞
  事务一: update mylock set b = 3001 where a = 3; // 修改成功
          commitl
  事务二退出阻塞, 执行update语句成功, 这个效果是跟排他锁一样的

情景二:
  事务一: select * from mylock where a = 3 lock in share mode;
  事务二: select * from mylock where a = 3 lock in share mode;
  事务一: update mylock set b = 3001 where a = 3;// 发现有其它人也对该行加了共享锁, 所以陷入等待
  事务二: update mylock set b = 3000 where a = 3;// 造成死锁, rollback

通过情景二, 我们发现一行数据可以由多个事务增加共享锁, 但是容易造成死锁
```

## 行锁分析
```
SQL语句: show status like "innodb_row_lock%";
  Inoodb_row_lock_current_waits: 当前正在等待锁定的数量
  Inoodb_row_lock_time  : 从系统启动到现在锁定总时间长度
  Inoodb_row_lock_time_avg: 每次等待所花平均时间
  Inoodb_row_lock_time_max: 从系统启动到现在等待最长的一次所花的时间
  Inoodb_row_lock_waits: 系统启动后到现在总共等待的次数

行锁总结:
  InnoDB存储引擎由于实现了行级锁定, 虽然在锁定机制的实现方面所带来的性能损耗可能比表级锁定会更高一
  些, 但是在整体并发处理能力方面要远远优于MyISAM的表级锁定的, 当系统并发量较高的时候, InnoDB的整体
  性能和MyISAM相比就会有比较明显的优势了,但是, InnoDB的行级锁定同样也有其脆弱的一面(索引失效行锁变
  表锁), 当我们使用不当的时候, 可能会让InnoDB的整体性能表现不仅不能比MyISAM高, 甚至可能会更差
```