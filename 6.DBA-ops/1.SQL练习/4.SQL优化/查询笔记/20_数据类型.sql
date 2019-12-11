/*
数据类型:
			数值型
						整型:tinyint(微整型),smallint,mediumint,int(integer),bigint(精度依次是1,2,3,4,8个字节)
										对于以上几种类型,其表示的数值范围都是不断递增的
										在整型的基础上,又分为有符号整数,无符号整数
								特点:
											① 对于整型的数来说,其默认是有符号整数
											③ 在创建表规定类型时,可以通过unsigned关键字来规定该整型为无符号
											//② 如果插入超过范围的数值时,则会直接报错终止执行(严格模式),或者选取临界值替代
																													
								对于长度问题:
												<1>每个整型类型都有自己的默认长度,这个长度是用来规定数值的长度的,当数值长度小于该值的时候
															如果使用了zerofill关键字,则会在数值前面补0,并且该关键字也会将该字段设置为无符号类型（unsigned）
								最大长度的设置和该类型值的取值范围是没有任何关系的,我们在添加值的时候必须满足范围的才可以添加进去 							
						小数
								浮点型
										<1>FLOAT(M,D)
										<2>DOUBLE(M,D)
								定点型
										<3>DECIMAL(M,D) 简写为dec(M,D)
								特点:
										<1> M表示的是整数位数+小数位数,D表示保留小数点后D位数(精度)
														result : 
																		① 小数位数超过指定的位数,则会对其进行四舍五入
																		② 整数位数超过指定的位数,则直接报错超出范围
										<2>M,D可以省略,对于float和double类型来说,这两个值会根据插入数值的不同显示不同
													而对于decimal类型来说,默认M为10,D为0

			字符型(char,varchar,text,blob,binary,varbinary,enum,set)
						char(len),varchar(len):都是表示字符的
										特点:
												 <1>长度:char和varchar规定的长度都是最大字符数！(不是字节数)
																		不同的是char类型的字符在创建时就规定了指定长度的空间,
																		而varchar类型的字符则会随着字符的大小来控制长度,但不超过其长度
												 <2>效率:char类型相对于varchar类型来说效率更高
												 <3>省略:char有默认长度1,所以可以省略,而varchar不能省略
						text:用于保存较长的文本
						blob:用于保存较长的二进制数据,一般用于图片的插入
						binary,varbinary:用于表示较短的二进制文本,其特点类似于char和varchar
						枚举类型:
						enum:保存列表类型
									特点:通过enum类型引入一个列表,在插入数据时仅仅可以插入这个列表中数据的其中一个
						set:保存集合类型
									特点:通过set类型引入一个列表,在插入数据时可以插入这个列表中数据的多个,之间用逗号隔开
						
			
			日期型(datetime,timestamp,year,date,time)
						datetime,timestamp:均用来保存日期(包括年月日时分秒)
						year:保存年
						date:保存日期
						time:保存时间
				datetime,timestamp:
							特点:<1>时区:timestamp类型保存的时间会受到时区,版本的影响,存入一个时间放在不同时区显示结果可能不同
									 <2>范围:datetime保存时间的范围较大,从1000-9999,而timestamp保存的是1970-2038
									 <3>字节长度:datetime为8,timestamp为4
		
*/

use test;
#以int类型为例:
DROP TABLE ts_int;
DESC ts_int;
SELECT * FROM ts_int;
CREATE TABLE ts_int(
		num1 INT ZEROFILL,
		num2 INT(7)  unsigned
);

INSERT into ts_int VALUES(1212,1234);
UPDATE ts_int SET num2 = 1225;


USE test;
DROP TABLE ts_float;
DESC ts_float;
SELECT * FROM ts_float;
CREATE TABLE ts_float(
			num1 FLOAT,
			num2 DOUBLE,
			num3 DECIMAL
)

INSERT INTO ts_float VALUE(123.123,123.123,123.623);
INSERT INTO ts_float VALUE(123.126,123.126,123.126);
INSERT INTO ts_float VALUE(123.1,123.1,123.1);
INSERT INTO ts_float VALUE(13.12,13.12,13.12);
INSERT INTO ts_float VALUE(1233.12,1233.123,1233.123);


use test;
DROP TABLE tab;
CREATE TABLE tab(
		sex enum('男','女'),
		hobby set('篮球','足球','羽毛球','乒乓球')
);
DESC tab;
SELECT * from tab;
INSERT INTO tab VALUES
('男','篮球'),
('男','篮球,足球'),
('男','篮球,羽毛球'),
('男','篮球羽毛球')


DROP TABLE tab;

CREATE TABLE date(
		日期 datetime,
		日期2 timestamp,
		年 year,
		时间 time,
		日期3 date
);
DESC date;
SELECT * FROM date;

insert INTO date VALUE (now(),now(),'8',now(),now())






















