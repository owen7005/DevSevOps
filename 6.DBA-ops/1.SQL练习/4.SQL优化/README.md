**clear up some basis grammar of mysql, it's only let me to search some message of mysql**


 - 启动和关闭MySQL(window): 桌面 - 我的电脑右键 - 管理 - Services - 找到Mysql右键关闭
 - 登陆MySQL: mysql -u 用户名(root) -p密码    例如: mysql -u root -pabcdef;
 
 ### 数据库
 - 创建数据库:
    1. create database 数据库名 <default charset 编码格式(utf8)>
    2. create database if not exists 数据库名 <default charset 编码格式(utf8)>
 - 删除数据库: drop database 数据库名
 - 进入指定的数据库: use 数据库名   

 ### 注释
  - 单行注释: #号或者--
  - 多行注释: /**/

### 基础查询
1、基础语法: 
  - select 常量: select 10;          结果为常量
  - select 表达式: select 10/3;      结果为计算后的结果
  - select 函数: select version();   结果为函数的返回值
  - select 字段 <as 别名> from 表;    别名中出现空格和关键字需要用引号引上
  - select 特殊字段(例如name, my age)** from 表;   查询特殊字段需要用反引号引上

2、去重:distinct关键字
  - select distinct 字段 from 表;

3、+号的作用:
  - 两个数值: 相加
  - 一个为数值一个为字符: 对字符进行从左到右截取操作, 直到遇到非数值为止, 然后进行相加, 如果整个字符都没有数值, 则该字符转为0  => (select 10 + "10.5a" 结果为20.5)

  

---

### 条件查询
1、条件表达式:< > =  >=  <= <>不等于,等价于(!=) \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;例如: `WHERE job_id >= 50;`

2、逻辑表达式:
  AND(&&)  OR(||)  NOT(!)  
  例如:  `WHERE job_id > 0 AND job_id < 50;`</br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         `WHERE job_id < 20 OR job_id > 10;`</br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`WHERE NOT(job_id > 50);` --> 查询除了`job_id > 50`的信息

3、模糊查询:
- like : 查询字段值的格式一致的, 例如: `first_name like ("%e%")`
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;语法: `字段 LIKE ("匹配模式")` (_代表任意字符, %代表任意个字符, \代表转义字符)\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;自定义转义字符: `字段 LIKE ("匹配模式") ESCAPE "转义字符";`

- IN : 查询字段值是以下几个的, 例如: `job_id IN (10, 11, 12)`

- BETWEEN...AND : 查询字符字段是规定范围内的, 例如: `job_id BETWEEN 50 AND 100`  ==== `job_id >= 50 AND job_id <= 100`;

4、其他查询:\
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `字段 IS NULL`, `字段 IS NOT NULL`: 查询字段是空/非空的  

---

### 排序查询
- ORDER BY: ASC(默认)升序排列, DESC降序排列\
可排序的内容: 单个字段,多个字段,表达式,函数, 多个排序之间用逗号隔开\
例如: `ORDER BY job_id DESC, first_name ASC`\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`ORDER BY length(first_name) DESC`&nbsp;&nbsp;(根据first_name的字符长度降序)

---

### 单行函数
1、字符函数
- length(str): 获取字符串的字节个数(在UTF-8编码格式下一个汉字占3个字节)
- concat(str, str2...): 拼接字符串
- trim(str): 去除str左右两边的空格
- substr(str, index): 获取str从index开始的所有字符
- substr(str, index, len): 获取str从index开始的len个字符, 索引从1开始
- instr(str, searchStr): 获取str中searchStr第一次出现的索引
- upper/lower(str): 将字符串转换为大写/小写形式
- lpad/rpad(str, len, padStr): 将str用padStr填充到len个字符, 如果len小于str长度, 则在截取左边len个值作为新的str
- replace(str, oldStr, newStr): 将str中的oldStr用newStr去填充

2、数值函数
- round(num): 对num进行四舍五入 （ round(10.555) -> 11 ）
- round(num, x): 对num保留x位小数后再四舍五入 （ round(10.55, 1) -> 10.6 ）
- ceil(num): 对num进行向上取整
- floor(num): 对num进行向下取整
- mod(x, y): x%y, x模y
- truncate(num, x): 对num截取x位小数（ truncate(10.55, 1) -> 10.5 ）
- rand(): 获取0-1的随机小数

3、日期函数
- now(): 获取当前日期时间
- curdate(): 获取当前日期
- curtime(): 获取当前时间
- year(date d), month(date d), day(date d),\
  hour(date d), minute(date d), second(date d): 获取日期对象中指定的年月日时分秒, date d可以是now() 函数的值
- str_to_date(str, format): 将字符串转换成指定格式的日期显示
- date_format(date d): 将日期对象转换为指定格式的字符串表示
- datediff(date d1, date d2): 两个日期的天数比较, 返回d1 - d2的值   
```
匹配模式:
      %M 月名字(January……December) 
      %W 星期名字(Sunday……Saturday) 
      %D 有英语前缀的月份的日期(1st, 2nd, 3rd, 等等。） 
      %Y 年, 数字, 4 位 
      %y 年, 数字, 2 位 
      %a 缩写的星期名字(Sun……Sat) 
      %d 月份中的天数, 数字(00……31) 
      %e 月份中的天数, 数字(0……31) 
      %m 月, 数字(01……12) 
      %c 月, 数字(1……12) 
      %b 缩写的月份名字(Jan……Dec) 
      %j 一年中的天数(001……366) 
      %H 小时(00……23) 
      %k 小时(0……23) 
      %h 小时(01……12) 
      %I 小时(01……12) 
      %l 小时(1……12) 
      %i 分钟, 数字(00……59) 
      %r 时间,12 小时(hh:mm:ss [AP]M) 
      %T 时间,24 小时(hh:mm:ss) 
      %S 秒(00……59) 
      %s 秒(00……59) 
      %p AM或PM 
      %w 一个星期中的天数(0=Sunday ……6=Saturday ） 
      %U 星期(0……52), 这里星期天是星期的第一天 
      %u 星期(0……52), 这里星期一是星期的第一天 
```

4、其他函数
- version(): 获取数据库的版本
- user(): 获取登陆的用户名
- database(): 获取当前数据库名
- IFNULL(字段一, 新值): 如果查询的字段为null, 则显示为新值
- ISNULL(字段): 如果查询的字段为null, 则显示为1, 反之则为0  

5、流程控制函数
- if (条件表达式, 语句一, 语句2) : 等价于三目表达式, 可用于select语句中, 满足条件和不满足条件时输出的结果不一样, 语句可以是字段, 函数等\
例如:  select if (job_id > 10, 'haha', job_id) from 表 (不同条件输出结果不一样)\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;select if (job_id > 10, job_id, first_name) from 表 (满足条件输出该行数据的job_id, 不满足输出该行数据的first_name)

- case语句一(类似于switch..case)\
  语法:\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;case 字段/语句\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;when 常量值/语句 then 常量值/语句\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;when 常量值/语句 then 常量值/语句\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;else 常量值/语句\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;end;

```
例子:
    SELECT
      last_name as Last_name,
      job_id as Job_id,
      case job_id
      WHEN concat("AD", "_PRES") THEN "A"
      WHEN "ST_MAN" THEN "B"
      WHEN "IT_P
      ROG" THEN "C"
      WHEN "SA_REP" THEN "D"
      WHEN "ST_CLEAK" THEN "E"
      END
      AS grade
    FROM
      myemployees.employees
    WHERE last_name = "K_ing";	
```
  

- case语句二(类似于if..else)\
  语法:\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;case\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;when 条件一 then 字段/语句\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;when 条件二 then 字段/语句\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;else 字段/语句\
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;end

```
例子:
      案例：查询员工的工资的情况
      如果工资>20000,显示A级别
      如果工资>15000,显示B级别
      如果工资>10000，显示C级别
      否则，显示D级别

      SELECT
        salary,
        case 
        WHEN salary > 20000 THEN 'A'
        WHEN salary > 15000 THEN 'B'
        WHEN salary > 10000 THEN 'C'
        ELSE 'D'
        END AS 工资级别
      FROM
        myemployees.employees AS em
      ORDER BY
        salary ASC
```  
---

### 分组查询

1、分组函数
- count(<distinct> 字段/字符): 获取该字段的有效值的个数, 可以传一个字段, 或者传任意一个字符, 传任意一个字符的时候, 则代表查询有多少行
- sum(<distinct> 字段): 求和
- avg(<distinct> 字段): 求平均值
- max(字段): 求最大值
- min(字段): 求最小值

> 注意: 这些查询都是忽略null值的, distinct关键字用于去重, 对于count函数一般用count(*) 来计算个数, 其实可以认为在表中增加了一列, 该列中所有的值都是\*, 再对\*计算个数

2、分组查询
```
语法: 
    select 
      字段, 分组函数
    from
      表名
    where
      筛选条件
    group by
      分组字段
    having
      分组后筛选条件  
例如:
查询各个管理者手下员工的最低工资，其中最低工资不能低于 6000，没有管理者的员 工不计算在内
SELECT	
	 MIN(salary) AS min, 
	manager_id
FROM
	myemployees.employees as em
WHERE
	manager_id is not null 
GROUP BY
	manager_id
HAVING
	min >= 6000          
```

---

> 连接查询分为两个版本, sql92 和 sql99, sql92仅仅实现了内连接和一小部分的外连接, 而sql99实现了更多的语法以及其可读性更高, 在后面将对sql92语法进行补充\
为表起别名:\
			<1>使得查询简洁\
			<2>区分多个表中有重名的字段\
	*注意*:为表起别名后就不能再用原来的表名去操作

### 内连接
>用法: 内连接通过两个或者两个以上的表的交集部分拼接成一个表(忽略值为null或者不存在的情况,这是其相对于外连接的不同)

1、分类:
- 等值连接
```
语法:
  select
     字段/语句
  from 
     表1
  inner join
     表2
  on 
    等值连接的条件
  where...
  group by...
  having...
  order by...

例子:
  # 查询部门名为 SAL 或 IT 的员工信息
  select  
    em.*
  from
    employee as em
  inner join 
    departments as de
  on  
    em.department_id = de.department_id
  where
    de.department_name in (SAL, IT);      
```
- 非等值连接\
表一与表二合并, 将表一中满足表二条件范围的数据合并成一行数据
```
#查询员工的工资级别
select
  em.salary,
  gr.grade_level
from
  employee as em
inner join
  job_grades as gr
on
  em.salary between gr.lowest_grade and gr.highest_grade      
```
- 自连接\
一个表自己与自己连接
```
 #查询员工的名字、上级的名字
SELECT
      e.last_name,m.last_name
FROM
      employees AS e
INNER JOIN
      employees AS m
ON
      e.manager_id = m.employee_id;
```

---

### 外连接
用法: 用于两个表的交集部分进行匹配, 同时匹配不交集的部分
> 外连接有左外连接和右外连接,全外连接(MySQL不支持), left join 左边的表和right join 右边的表为主表, 主表与附表匹配时, 未匹配上时, 附表显示的值为null\
*注意*: 当进行外连接的时候,最好使用主键进行连接,防止其他属性中有null的存在


```
语法:
select
    字段/语句
from
    表一
left / right join
    表二
on
    连接条件
where...
group by...
having...
order by...

例子:
#查询编号>3的女神的男朋友信息和该女神的名字，如果有则列出详细，如果没有，用null填充
select
  g.name, b.*
from
  beauty as g
left join
  boy as b 
on
  g.boyfriend_id = b.id
where g.id > 3
```

---

### 交叉连接
> 表一的每一项对应表二的所有项,结果为两个表相连, 等于在内连接的时候没有on后面没有提供连接条件（笛卡尔乘积）

---

### 子查询
> 用法: 一个select语句查询得到的结果, 如果结果为单行单列值, 则可以用于在where语句中进行条件判断, 如果为多行单列值, 则可以作为一组结果进行判断, 如果为多行多列值, 则可以看做是一张表\
`注意: 对于子查询来说:只不过把子查询select查出的结果作为了条件或者比较值`


1、按使用的位置分类:
- select关键字后面
- from语句后面(当作一张表, 一般该表为多行多列)
- where语句后面(当作判断条件)
- exists语句后, 如果select语句查询得到的结果是有值的就返回1, 如果是null则返回0 

2、按查询结果分类:
- 单行单列
- 多行多列
- 一行多列
- 一列多行: 获取的结果一般用于where语句, 并且配合多行操作符一起使用
  - in/ not in (结果): 是/不是其中的一个, 类似于相等操作=
  - any/ some (结果): 满足其中一个条件, 用于 > = <等 
  - all: 满足其中所有的结果, 用于 > < = 等
```
例子一: 用于from后面, 查询得到的结果当作一张表
SELECT
     部门,平均工资,grade_level AS 工资等级
FROM 
    (
        SELECT department_id AS 部门,AVG(salary) AS 平均工资
        FROM employees
        GROUP BY department_id
    ) AS tab1
INNER JOIN 
    job_grades AS g
ON 	
    tab1.平均工资 BETWEEN g.lowest_sal AND g.highest_sal	
ORDER BY 
    工资等级
   

例子二: 用于exists语句后

SELECT	exists(
    SELECT last_name
    FROM myemployees.employees
    WHERE employee_id = 100
) 
```

--- 

### 分页查询
```
语法:
   select
      字段/ 语句
   from
      表
    where...
    group by...
    order by...
    limit index, len 索引从0开始     
```

---

### 联合查询
> 用法: 用于查询多个表中的相同信息,并且这多个表中没有连接条件
```
语法:
    select 查询列表 from 表 where 条件
    union <all>
    select 查询列表 from 表 where 条件
all: 规定显示全部, 因为默认是去重的

#案例：查询中国用户中男性的信息以及外国用户中年男性的用户信息

SELECT id,cname FROM t_ca WHERE csex='男'
UNION ALL
SELECT t_id,tname FROM t_ua WHERE tGender='male';
```

### 数据的增删改查
> **查询表的结构:** &nbsp; `DESC 表名`
- 插入语句
  ```
  语法:
      <1> insert into 表(...字段)
          values(...值)
      <2> insert into 表(...字段)
          子查询    
      <3> insert into 表
          set 字段1 = value1, 字段二 = value2 .....
  注意:
      <1> 字段和值必须保持顺序一致
      <2> 子查询的结果的字段个数和顺序必须与插入语句中字段的顺序和个数一致
  例子:
    INSERT INTO beauty 
    VALUE (15,'王思纯','女',NULL,'110',NULL,8),
          (16,'张美玲','女','1994-1-1','120',NULL,3)
  ```

- 修改语句

  1、单表修改
  ```
  语法:
    update 表 set 字段1 = value1, 字段2 = value2 where 筛选条件 
  例子:
    UPDATE beauty SET name = '程希',sex = '女' WHERE sex = '男';
  ```

  2、多表修改
  ```
  根据某张表的信息来修改另一张表的信息
    update 
      表1 as 别名
    inner/left/right join
      表2 as 别名
    on
      连接条件
    set 别名.字段 = value
    where
      筛选条件
  例子:
    修改没有男朋友的女神的男朋友编号都为2号
    update
       beauty g
    left join
       boys b
    on
       g.boyfriend_id = b.id
    set
       g.boyfriend_id = 6
    where
       b.id is null;    
  ```

- 删除语句

  1、单表删除
  ```
  语法: 
    delete from 表名 别名 where 筛选条件 <limit>
  案例：删除手机号以9结尾的女神信息
    delete from beauty where phone like '%9'; 
  ```
  2、多表删除
  ```
  语法:
    delete
      表名/别名
    from
      表1 < as 别名 >
    inner/left/right join
      表2 < as 别名 >
    on
      连接条件
    where
      筛选条件
  注意: 用了别名的情况下delete关键字后面必须用别名      
  ```
  3、清空表
  ```
  方式一: delete from 表名
  方式二: truncate 表明

  区别:
      <1> truncate清空表后对于自增类型的会重新从1开始计算, 而delete则从删除位置开始计算
      <2> truncate删除后不会显示影响的个数, delete会显示
      <3> truncate不可回滚, delete可回滚
  ```

--- 

### 库的管理
```
创建一个数据库:
    create database 数据库名
查看所有的数据库
    show databases;    
修改数据库的编码集
    alter database 数据库名 character set "编码集"
删除数据库
    drop database <if exists> 数据库名        
```

---

### 表的管理
1、创建表
```
语法: 
    create table 表名 (字段1 数据类型(最大长度), 字段2 数据类型(最大长度))
例子:
    CREATE TABLE books(
        id INT,
        bookName VARCHAR(20),
        price DOUBLE,
        author_id INT,
        publishDate DATETIME
    );
```
2、删除表
```
drop table <if exists> 表名;
```
3、修改表
  - 修改表名
      ```
      alter table 表名 rename to 新的表名
      ```
  - 增加列
      ```
      alter table 表名 add column 列名 数据类型(最大长度)
      ```
  - 删除列
      ```
      alter table 表名 drop column 列名
      ```
  - 修改列
      ```
      alter table 表名 change column 原列名 新列名 数据类型(最大长度)
      alter table 表名 modify column 列名 数据类型(最大长度)
      ```
4、复制表
  > select关键字后面的字段为复制的字段, 通过where语句来控制复制的数据
  - 复制表的部分结构
    ```
    create table 表名
    select 字段1, 字段2... from 表名 where 1 = 2
    ```
  - 复制表的全部结构
    ```
    create table 表名
    select * from 表名 where 1 = 2;
    ```

--- 

### 数据类型
1、 数值型
  > 对于数值型的值来说, 小数部分超过长度的会四舍五入, 整型中插入浮点型也是会四舍五入, 整型的长度不会影响数值的范围, 一般我们定义数值型不对长度进行设置
  - 整型
    ```
    类型: tinyint(微整型) smallint mediumint int bigint(字节数以此是  1 2 3 4 8)
    
    长度: 每一种整型都有默认的字符长度, int类型为11

    整型又分为无符号整型和有符号整型, 默认为有符号的, 如果在创建表的时候需要规定无符号整型可以添加unsigned关键字, 或者zerofill关键字(会对该值不满足长度的在左边添加0)

    长度和字节范围:
        对于整型来说, 这个最大长度除了在使用zerofill关键字的时候有用, 其他时候都是
        以该类型的字节大小来规定值的大小的, 而不受长度的限定 
    ``` 
  - 浮点型
    ```
    类型: float<M, D>, double<M, D>, decimal<M, D>

    <1> M代表整数个数, D代表小数个数
    <2> 长度可以省略, 大部份情况下是省略的, decimal默认为(10, 0)
    ```

2、 字符型
  ```
  类型: char, varchar, text(较长文本), blob(较长二进制文本, 一般用于存储图片), binary, varbinary(较短二进制文本), enum, set
  特点:
    char&varchar,
    binary&varbinary: 
        char/binary类型有默认的长度, char为1, 在创建时如果自定义最大长度, 那么其
        就会占据指定的空间, 而varchar类型虽然需要强制设置最大长度, 但是其在存储数
        据的时候, 存入多少个字符就占据多大的空间(不超过最大长度)

  enum: 枚举类型, 只能选一个(枚举类型里面只能放入字符型)
  set: 集合类型, 能选择多个, 多个之间用逗号隔开, 所以创建表时设置初始值的时候是不允许有逗号的

  例子:
      CREATE TABLE tab(
        sex enum('男','女'),
        hobby set('篮球','足球','羽毛球','乒乓球')
      );
      
      INSERT INTO tab 
      VALUES ('男','篮球'), ('男','篮球,足球')
  ```

3、 日期型
  ```
  类型: datetime, timestamp, date, time, year
  特点:
    <1> datetime, timestamp均表示日期时间, 前者范围更广, 后者表示1970-2038, 后者
        保存的时间会因为时区的不同而显示不同的值(受时区影响)
    <2> date表示日期, time表示时间, year表示年
    <3> 字节长度:datetime为8,timestamp为4    

  例子: 将一个日期时间以不同个数存入数据库
      create table test (
        born datetime,
        borndate date,
        borntime time, 
        bornyear year
      );

      insert into test
      values (
        STR_TO_DATE("1997-10-23 19:58:53", "%Y-%c-%e %k:%i:%s"),
        STR_TO_DATE("1997-10-23 19:58:53", "%Y-%c-%e %k:%i:%s"), 
        STR_TO_DATE("1997-10-23 19:58:53", "%Y-%c-%e %k:%i:%s"), 
        year(STR_TO_DATE("1997-10-23 19:58:53", "%Y-%c-%e %k:%i:%s")
      );
  ```

---

### 约束
1、 查看有哪些键
  ```
  show index from 表名
  ```

2、 六大约束
  ```
  约束的六大类型: 
   - not null: 规定值不能为空值
   - default: 规定在没有值的情况下采取默认值
   - unique: 独一无二的, 规定数据在该列中无重复, 但是对于null可以有多个,
             可以配合not null 实现非空无重复的值
   - primary key: 主键约束, 一个表中只能有一个主键约束, 值具有唯一性
   - foreign key: 外键约束, 规定实现了该约束的字段, 从表字段的值必须是
                  主表内主键值中的其中一个, 外键约束可以有多个,主表的值
                  必须是主键
   - check: 检查约束, 检查是否符合指定的要求,比如设置该约束为年龄在18-66,
            那么不在指定范围的数据添加时会报错(Mysql中未实现该约束)
  ```

3、 创建约束
  - 列级约束(在创建表的单个字段后面添加)
    ```
    可用约束: not null, default, unique, primary key
    语法: 
        create table 表名 (
          字段1 数据类型(最大长度) 约束类型 <默认值>,
          字段2 数据类型(最大长度) 约束类型 <默认值>
        )
    例子:
        create table stu(
          id int primary key,
          stuName varchar(10) unique not null,
          gender char default '女'
        )
    ```
  - 表级约束(在创建表的所有字段后面添加)
    ```
    可用约束: unique, primary key, foreign key
    语法:
        create table 表名(
          字段1 数据类型(最大长度),
          字段2 数据类型(最大长度),
          constraint 约束别名 约束类型(约束字段)
          constraint 约束别名 约束类型(约束字段) <references 主表(主键字段)>
        )
    语法:
      create table stu(
          id int,	
          stuName varchar(10),
          majorId int,
          #开始设置约束
          constraint primaryK primary key (id),
          constraint must unique (stuName),
          constraint outKey foreign key (majorId) references major(id) 		
      )
    ```
4、增加约束
  - 增加列级约束
    ```
    alter table 表名 modify column 字段 数据类型(最大长度) 约束类型 <默认值>
    ```   
  - 增加表级约束
    ```
    添加主键约束: 
      alter table 表名 modify column 字段 数据类型(最大长度) primary key
      alter table 表名 add column primary key(字段名)
    
    添加唯一约束:
      alter table 表名 modify column 字段 数据类型(最大长度) unique
      alter table 表名 add column unique(字段名)

    添加外键约束:
      alter table 表名 add column foreign key(字段名)
    ```  
5、删除约束
  - 删除列级约束
    ```
    其实就是更改列信息的同时不写入约束
    alter table 表名 modify column 字段名 数据类型(最大长度) 
    ```

  - 删除表级约束
    ```
    由于unique和foreign key可以有多个, 所以需要增加一个约束别名来区分删除哪个
    alter table 表名 drop 约束名 <约束别名>
    ```
    > 注意: 删除外键的时候, 即使删除成功, 通过show index from 表名还是能看见的,但是能
            写入其他数据

### 标识列
```
标识列: 也称自增列, 可以让整型数据等间隔增加, 一个表中只能有一个标识列, 
       并且必须用于键中(primary key, unique, foreign key)
获取自增信息:
    show variables like "%auto_increment%"
    auto_increament_increment: 自增步长
    auto_increament_offset: 自增起始值(不建议修改, 值存在不确定性)
改变自增信息:
    set auto_increament_increment = xxx    
    set auto_increament_offset = xxx(不建议修改, 值存在不确定性)   
删除标识列(修改字段时不设置标识列)
    alter table 表名 字段名 数据类型(最大长度) 约束键
```

---

### 事务
1、存储引擎
  ```
  查看当前数据库的存储引擎: show engines;(其中default的即为默认的存储引擎)
  不同的数据库可能用到的存储引擎是不一样的, 而有些存储引擎是不能使用事务功能的
  ```

2、含义
  ```
  事务其实就是一组SQL语句组成的执行单元, 仅支持insert delete update select即对数据的增删改查, 其他语句放入事务中没有意义, 在事务中的语句, 要么都执行, 要么都不执行
  ```

3、事务的特点
  ```
  <1>原子性:事务作为一个执行单元是不可再分割的,要么全部执行,要么全部不执行
  <2>一致性:事务执行前后,会保持数据的一致性,如转账为例,转账前和转账后双方的钱加起来是相等的
  <3>隔离性:一个事务的执行不会被其他事务所影响
  <4>持久性:事务一旦被提交,则会永久的改变数据库中的数据
  ```
4、事务的分类:
  - 显式事务: 不会自动提交, 需要手动开启事务, 提交, 回滚
    ```
      语法:
      set autocommit = 0; # 关闭自动提交
      start transaction; # 开启事务
      sql语句;
      sql语句;
      commit; / rollback; # 提交或者回滚
    ```
  - 隐式事务: 会自动提交
  > 查看自动提交是否开启: show variables like "%autocommit%";
  > 关闭自动提交: set autocommit = 0; (1即为自动开启)

5、事务的并发问题:
  ```
  脏读: 开启两个事务, 事务A能够读取事务B未提交的内容
  不可重复读: 开启两个事务, 事务A读取一次数据, 此时事务B对数据进行修改并提交,
             事务A再一次读取该数据时发现发生了改变
  幻读: 开启两个事务, 事务A读取一次数据, 假如此时事务B对数据进行增加后再提交,
        事务A此时删除所有的数据, 可以发现删除的个数不是刚才读取的个数           
  ```
6、事务的隔离级别:
  ```
  read uncommitted: 可读取未提交的数据, 会引发脏读, 不可重复读, 幻读的问题
  read committed: 不可读取未提交的数据, 可读取提交的数据, 会引发不可重复度, 幻读的问题
  repeatable read: 可重复读取数据, 事务A在未提交之前读取的数据是一致的, 会引发幻读的问题
  serializable(串行化的): 最高等级, 不会产生并发问题, 修改数据的时候如果有其他事务存在,
                         那么则会卡住, 直到其他事务结束才会进行下一步
  ```

7、操作事务的语句:
  ```
  查看当前事务等级: select @@transaction_isolation;(在8.0前是select  @@tx.isolation)
  修改事务等级: set session/global transaction isolation level 事务等级
  ```  

8、补充
  ```
  - savepoint关键字: 回滚会到此截至, 在该关键字上面的语句不会被回滚
  - truncate/delete: truncate不会被回滚

  例子:
   set autocommit = 0;
   start transaction;
   insert into tab(name) values ("a");
   savepoint a1;
   insert into tab(name) values ("b");
   savepoint a2;
   insert into tab(name) values ("c");
   savepoint a3;
   rollback to a1;
   则a1后面的代码均不会执行, 但truncate会破坏回滚
  ```  

---

### 视图
> 视图: 就是一个SQL查询语句得到的表, 我们可以直接拿来查询

1、创建视图
  ```
  create view 视图名
  as
  查询语句
  ```
2、修改视图
  - 修改视图的查询语句
    ```
    方式一:
      create or replace 视图名
      as
      查询语句
    方式二:
      alter view 视图名
      as
      查询语句  
    ```
  - 修改视图里面的数据(不建议)
    ```
    直接对视图进行update, delete即可, 但是不建议这么做, 因为会直接影响到创建视图时
    查询语句中的表的内容, 所以我们的视图的权限一般是只读的

    但是以下情况下是实现不了更新的:(了解)
        group by,常量视图,子查询,distinct,join,from一个不能够更新的视图，
        where语句中的子查询中引用了from中的表
    ```
3、查看视图的结构
```
desc 视图名(查询的是数据结构) / show create view 视图名(除了数据结构外还有编码集等)
```    

---

### 变量  
1、系统变量
  - 分类
    ```
    全局变量(global)
    会话变量(session)
    ```
  - 获取变量值(没有加global和session时默认为会话)
    ```
    - 获取一组变量:
        show <global/session> variables <like "xxx">
    - 获取单个变量:
        select @@<global./session.>变量名
    ```
  - 设置变量值(没有加global和session时默认为会话)
    ```
    set @@<global./session.>变量名 = 变量值
    ```
    > 全局变量: 设置后不会立马影响到会话变量, 当重新登陆该数据库的时候会同步到会话变量\
      会话变量: 设置后其生命周期只在当前会话, 一旦退出数据库则失效\
      全局变量会在重启MySQL后被重置为初始值

2、自定义变量
  - 会话变量
    ```
    定义会话变量:
        - set @变量名 = 变量值;
        - set @变量名 := 变量值;
        - select @变量名 := 变量值;

    修改会话变量:
        - set @变量名 = 变量值;
        - set @变量名 := 变量值;
        - select @变量名 := 变量值;
        下面这种方式在存储过程中会经常见到
        - select 
            字段名 into @变量名
          from 
            表名
          。。。        
    使用会话变量: @变量名
        可以在任意一个地方使用, 变量保存的是一个值, 所以哪个地方需要用到值
        都可以引用该变量的值, 如: select @mes;

    ```
  - 局部变量(定义在begin..end语句中)
    ```
    定义变量:
        - declare 变量名 变量类型;
        - declare 变量名 变量类型 default 变量值;
    修改变量值:
        - set 变量名 = 变量值;
        - set 变量名 := 变量值;
        - select @变量名 := 变量值;
        - select 
          字段名 into @变量名
        from 
          表名
        。。。
    使用变量值:        
    ```
---

### 存储过程
1、含义
```
存储过程指的是一组SQL语句的集合体, 类似于函数, 可以多次调用, 并且有返回值
```

2、delimiter关键字
```
delimiter: 用于设置MySQL中的分隔符, 由于在存储过程中有多个SQL语句, 
           并且存储过程需要用end结束, 所以我们需要重新定义分隔符
用法: delimiter 符号            
```

3、形参
```
- in模式:需要调用者传入一个实际的参数来供存储过程体使用
- out模式:该参数将作为返回值返回, 传入时需要是一个变量名
- inout模式:既是由调用者传入实际参数来使用,也是函数的返回值, 传入时需要是一个变量名
- 当在begin..end块中定义了表后, 如果出现表中的字段和形参相同的话, 那么引用该字段的时候,
  会优先使用形参的值, 例如where id = id, 如果形参存在id的话, 那么两个使用的都是形参的值
```

4、语法
```
delimiter 分隔符
create procedure 存储过程名(形参模式 形参名 形参类型)
begin
  SQL语句
end 分隔符

例如: 
delimiter $
create procedure compareDate (in date1 datetime, in date2 datetime, out result int)
begin 
  select if (DATEDIFF(date1, date2) > 0, 1, 0) into result;
end$

set @dateCompare = 0$
call compareDate(str_to_date("1999-10-1", "%Y-%c-%e"), str_to_date("1998-10-1", "%Y-%c-%e"), @dateCompare);
```

5、补充
```
查看存储过程的一些信息:show create procedure 存储过程名
删除存储过程: DROP PROCEDURE 存储过程名 (注意:不支持一次删除多个)
注意: set autocommit = 0必须放在declare语句上面, 即declare语句必须放在最上面, 并且while循环中不
      允许用declare声明变量
```

### 函数
1、特点
```
<1> 必须返回参数并且只能是一个值
<2> 不能用已经存在于系统的函数的函数名定义
<3> 形参只规定传入的类型
<4> 当在begin..end块中定义了表后, 如果出现表中的字段和形参相同的话, 那么引用该字段的时候,
    会优先使用形参的值, 例如where id = id, 如果形参存在id的话, 那么两个使用的都是形参的值
```

2、语法
```
delimiter 分隔符
create function 函数名 (形参名 数据类型, 形参名 数据类型) returns 数据类型
begin
  SQL语句;
  SQL语句;
  return 返回值;
end

例子:
delimiter $
create function getManager (employee_name varchar(50)) returns varchar(50)
begin 
  declare maName varchar(50);

  select 
    ma.last_name into maName
  from	
    myemployees.employees as em
  INNER JOIN
    myemployees.employees as ma
  on
    em.manager_id = ma.employee_id
  where
    em.last_name =employee_name;
	
  return maName;
end$

select getManager("Kochhar");
```
3、补充
```
查看函数:
    show create FUNCTION 函数名
删除函数:
    DROP FUNCTION 函数名
```
4、遇到的问题:
```
当我们在定义函数时,可能会遇到1418错误
错误信息:1418 - This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)


show variables like "%log_bin%"; 查看发现log_bin_trust_function_creators为OFF
解决方法:
  set @@global.log_bin_trust_function_creators = 0;
```

### 流程控制语句
1、顺序结构, 分支结构
  - if()函数
    ```
    语法: if (表达式1, 结果1, 结果2); 
    如果表达式一为true则得结果1, false则得结果2 
    ```
  - case的第一种用法(类似于switch case)
    ```
    case 值
    when 常量值1 then 返回值1/函数1 
    when 常量值2 then 返回值2/函数2 
    else 返回值3
    end
    ```  
  - case的第二种用法(类似于if..else)
    ```
    - then后面为值
          case 
          when 判断条件1 then 值1
          when 判断条件2 then 值2
          else 值3
          end
    - then后面为执行语句(只能用于begin...end中, 语句后需带分号)
          case
          when 判断条件1 then 执行语句1;
          when 判断条件2 then 执行语句2;
          else 执行语句3;
          end case;
    ```
    > <1>如果为返回值类型,那么该结构可以放在任何地方,包括begin,end语句中。\
      <2>如果为语句,那么该结构只能放在begin,end中,可以单独使用，并且语句后面需要用分号结尾

  - if结构
    ```
    语法:
        if 条件一 then 语句一;
        elseif 条件二 then 语句二;
        else 语句三;
        end if
    注意:只能用在begin end语句中

    例子:
    delimiter $
    create procedure fun (in usernames varchar(10), out isOnline varchar(10)) 
    begin
      declare state char;
      select 
        a.isOnline into state
      from 
        girls.admin as a
      where
        a.username = usernames;	
      case
      when state = "0" then set isOnline = "用户未登陆";
      when state = "1" then set isOnline = "用户已登录";
      end case;
    end$
    ```

2、循环结构
```
while:先判断后循环
  语法:
      [标签]:while 循环条件 do
                    循环语句
              end while [标签名];

repeat:先循环体执行一次再开始判断(类似于do while语句)
  语法:
      [标签]:repeat 
                  循环语句
              until 结束条件
              END repeat [标签];

loop:死循环,除非用循环控制语句才能跳出循环
  语法:
      [标签]:loop
                循环语句
            END loop [标签];

注意:
  <1>对于以上的循环结构,只适用于begin end中
  <2>如果在循环前面加入了标签名,那么在循环后面也需要加入标签名
  <3>循环语句中不可以用declare语句
循环控制语句:
  <1>leave 相当于break,后面要接标签名,用于直接退出循环
  <2>iterate 相当于continue,后面要接标签名,用于退出本次循环    
```
