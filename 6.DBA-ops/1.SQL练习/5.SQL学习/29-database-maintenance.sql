-- 数据库维护
-- MySQL提供了一系列的语句，可以用来保证数据库正确和正常运行
-- ANALYZE TABLE，用来检查表键是否正确。
ANALYZE	TABLE	orders;
-- CHECK TABLE用来针对许多问题对表进行检查。在MyISAM表上还对索引进行检查。CHECK TABLE支持一系列的用于MyISAM表的方式。CHANGED检查自最后一次检查以来改动过的表
-- EXTENDED执行最后彻底的检查，FAST只检查未正常关闭的表，MEDIUM检查所有被删除的链接并进行键检验，QUICK只进行快速扫描。
CHECK	TABLE	orders,orderitems;
-- 查看日志文件
-- MySQL维护管理员依赖的一系列日志文件。主要日志文件有以下几种
-- 错误日志：它包含启动和关闭问题以及任意关键错误的细节。此日志通常名为hostname.err，位于data目录中。此日志名可用--log-error命令行选项更改
-- 查询日志：它记录所有MySQL活动，在诊断问题时非常有用。此日志文件可能会很快地变得非常大，因此不应该长期使用它。此日志通常名为hostname.log,位于data目录中。此名字可以用--log命令行选项更改
-- 二进制日志。它记录更新过数据的所有语句。此日志通常名为hostname-bin，位于data目录内。此名字可以用--log-bin命令行选项更改。注意，这个日志文件是MySQL5中添加的，以前的MySQL版本中使用的是更新日志
-- 缓慢查询日志。此日志记录执行缓慢的任何查询。这个日志在确定数据库何处需要优化很有用。此日志通常名为hostname-slow.log，位于data目录中。此名字可以用--log-slow-queries命令行选项更改
-- 在使用日志时，可用FLUSH LOGS语句来刷新和重新开始所有日志文件。