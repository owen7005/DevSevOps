/*
	库的管理:
				- 创建 
							CREATE DATABASE 库名
				- 删除
							DROP DATABASE 库名
				- 修改(不支持修改库名,除非直接在文件中改名,因为修改库名后可能使得数据发生改变)				
							修改库的字符集	
							ALTER DATABASE 库名 CHARACTER SET '字符编码'
*/
#创建库
CREATE DATABASE book;
#删除库
DROP DATABASE book;

ALTER DATABASE book CHARACTER SET 'gbk';
ALTER DATABASE book CHARACTER SET 'ascii';


