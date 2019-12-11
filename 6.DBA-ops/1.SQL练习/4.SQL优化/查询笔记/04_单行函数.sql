/*
	函数的分类:
			单行函数:
							字符函数
										<1> length(str) :返回字符或者数值等的字节数(客户端采用的是utf-8编码模式,一个中文代表3个字节)
										<2> concat(str1,str2....):连接多个字符串
										<3> substr()   / substring():注意--->索引从1开始
															substr(str,index):截取str字符中索引在index后(包括index)的所有字符
															substr(str,index,len):截取str字符中索引index开始len个字符
										<4>instr(str,substr):在str字符中查找substr，返回第一次出现的索引
										<5>upper(str)/lower(str);将str转换为大写/小写
										<6>trim();去除文字两边指定的字符,直到遇到非该字符为止
										<7>lpad(str,len,newstr)/rpad():左填充/右填充,根据len的大小对str进行填充或者裁减,如果为裁减,则两个都是裁减右边的
										<8>replace(str,oldstr,newstr):在str字符中用newstr取代所有的oldstr;


							数学函数
										<1> round(x):对x进行四舍五入
												round(X,D):保留x后面D位小数,对保留位数后面的进行四舍五入
										<2>ceil(x):对x进行向上取舍(返回比x大的最近的整数)
										<3>floor(x):对x进行向下取舍(返回比x小的最近的整数)
										<4>mod(x,y):对x/y取模(类似于x%y),简便计法:结果同步被除数的符号
														原理: mod(x,y) = x%y = x-x/y*y;
										<5>truncate(x,d):保留数值X后面d位小数
										<6>rand() : 获取随机数(0-1)
							日期函数
										<1>NOW():返回当前日期时间
										<2>curDate()/curtime():仅仅返回当前日期/时间
										<3>year() month() day() hour() minute() second():仅仅返回年月日时分秒其中一个
														注意:需要传入一个日期参数,例如now(),则将该日期中的年月日时分秒分别返回
										<4>str_to_date(str,format):将不同格式字符串转换为相同格式(年-月-日 时:分:秒)的日期
																				(对于用户输入的日期格式,我们通过取代符来确定哪个是年月日,然后指定格式的日期)		
											 date_format(str,format):将相同格式日期的字符串转换为指定格式的日期返回
																				(将指定格式的日期以取代符来确定新的格式并返回)
										<5>datediff(日期一,日期二):比较两个日期的大小,返回日期一与日期二相差的天数
			
							其他函数
										<1>version():显示数据库客户端的版本号
										<2>user():显示登录客户端的用户
										<3>database():显示进入的库
							流程控制函数
										<1> if函数(等价于三元运算符)
														语法:
																	if(条件表达式,语句一,语句二): 通过判断条件表达式的内容,如果为true,则执行语句一,false则执行语句二		
										<2>case函数:
													语法一:(类似于switch语句)
														- CASE 字段/条件表达式
															when 常量值1 then 语句1
															when 常量值2 then 语句2
															else 常量值3
															END
													语法二:	(类似于if ...else...)	
														- CASE
															when 条件1 then 要显示的值/语句一
															when 条件2 then 要显示的值/语句二
															else 要显示的值/语句三
															END AS 别名
*/
USE myemployees;

-- 字符函数
#length:返回字节长度
SELECT length('江西haha123');

#concat(str1,str2,str3....):拼接字符串
SELECT
			CONCAT(last_name,'_',first_name) AS 姓名 
FROM	
			employees
 
#substr():用于截取字符串,参数不同功能不同
SELECT SUBSTR('江西师范大学科学技术学院',7);
SELECT SUBSTR('江西师范大学科学技术学院',1,6);

#upper()/lower()
SELECT  upper('My name is aaa') AS one;
SELECT LOWER('My name is aaa,哈哈') AS two;
#示例：将姓变大写，名变小写，然后拼接
SELECT CONCAT(upper(last_name),lower(first_name)) AS Xingming FROM employees;

#案例：姓名中首字符大写，其他字符小写然后用_拼接，显示出来
SELECT CONCAT(upper(substr(last_name,1,1)),'_',lower(substr(last_name,1,1)),lower(first_name)) AS xingming  FROM employees;
 
#instr():在str字符中查找substr，返回第一次出现的索引
SELECT INSTR('江西师范大学江西师范大学','学');

#trim():去除文字两边指定的字符,直到遇到非该字符为止
SELECT trim('             我    来    自    中    国               ');
SELECT length(trim('             我    来    自    中    国               '));

SELECT TRIM('a' from 'aaaaaaa哈哈哈哈aaaaaa');
SELECT TRIM('abc' from 'abcabcab哈哈哈哈ababcabc');

#lpad(str,len,newstr)/rpad():左填充/右填充,根据len的大小对str进行填充或者裁减,如果为裁减,则两个都是裁减右边的
SELECT LPAD('我是中国人',10,'-');
SELECT LPAD('我是中',2,'-');
SELECT RPAD('我是中国人',10,'-');
SELECT RPAD('我是中',2,'-');

#replace(str,oldstr,newstr);在str字符中用newstr取代所有的oldstr;

SELECT REPLACE('长城在中国有很多长城','长城','美食');


-- 数学函数
#round(x):对x进行四舍五入(只要5以上前面就加一)
SELECT round(4.5);
SELECT round(-4.5);
SELECT ROUND(4.666,2);			
SELECT ROUND(-4.666,2);

#ceil(x);
SELECT ceil(10.1);
SELECT ceil(-10.1);


#mod(x,y);

SELECT mod(10,3);   	#1 
SELECT mod(-10,3);  	#-1
SELECT mod(-10,-3);   #-1 '

#truncate(x,d):保留数值X后面d位小数
SELECT truncate(123.123,2);


-- 日期函数:
#now():
SELECT NOW();

#curdate()/curtime();
SELECT curdate();
SELECT CURTIME();

#year() month() day() hour() minute() second():仅仅返回年月日时分秒其中一个
SELECT year(now());
SELECT month(now());
SELECT date(now());

#STR_TO_DATE(str,format)
SELECT str_to_date(now(),'%Y-%c-%d');
SELECT str_to_date(now(),'%Y-%m-%d');		


#查询入职日期为1992-4-3的员工信息
SELECT 
				*
FROM
				employees
WHERE
				hiredate  = str_to_date('4-3 1992','%m-%d %Y');


SELECT str_to_date('4-3 1992','%m-%d %Y');

#user()
SELECT user();

#version()
SELECT version();

#database()
SELECT database();

#流程控制函数

SELECT
				last_name,
				commission_pct,
				if(commission_pct is null,'没奖金','有奖金')
FROM
				employees

/*案例：查询员工的工资，要求

部门号=30，显示的工资为1.1倍
部门号=40，显示的工资为1.2倍
部门号=50，显示的工资为1.3倍
其他部门，显示的工资为原工资

*/
SELECT
			salary,
			department_id,
			case department_id
			when 30 THEN salary*1.1
			when 40 THEN salary*1.2
			when 50 THEN salary*1.3
			else salary
			END AS 工资
FROM
			employees
ORDER BY 
			department_id ASC;

/*案例：查询员工的工资的情况
如果工资>20000,显示A级别
如果工资>15000,显示B级别
如果工资>10000，显示C级别
否则，显示D级别
*/
SELECT 
				salary,
				case 
				when salary >20000 then 'A'
				when salary >15000 then 'B'
				when salary >10000 then 'C'
				ELSE  'D'
				END AS 工资级别

FROM 
				employees
ORDER BY 工资级别 ASC,salary DESC;




