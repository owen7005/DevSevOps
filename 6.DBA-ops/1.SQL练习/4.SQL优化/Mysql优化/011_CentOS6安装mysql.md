## yum安装MySQL5.7
```
服务器: CentOS6
MySQL: 5.7

移除已经存在的MySQL:
  rpm -qa | grep mysql
  yum -y remove mysql, mysql-libs

备份yum源:
  mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

更改服务器的yum源到阿里云:
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
  yum makecache

CentOS7的yum源仓库中不存在MySQL的yum源, 需要手动下载后添加:
  wget https://dev.mysql.com/get/mysql57-community-release-el6-11.noarch.rpm
  rpm -ivh mysql57-community-release-el6-11.noarch.rpm

确定添加成功:
  yum repolist all | grep mysql | grep enabled

  mysql-connectors-community/x86_64  MySQL Connectors Community    enabled:     51
  mysql-tools-community/x86_64       MySQL Tools Community         enabled:     63
  mysql57-community/x86_64           MySQL 5.7 Community Server    enabled:    267

安装MySQL5.7
  yum -y install mysql-community-server

到此为止, mysql5.7就已经安装成功了, 下面需要初始化和启动MySQL
```

## MySQL启动问题
```
<1> 执行service mysqld start, 其会自动初始化MySQL, 结果是初始化失败, 这时候我们直接谷歌这个初始化
    失败是没有用的, 需要查看一下MySQL的日志
<2> less /var/log/mysqld.log
<3> 问题:
[ERROR] Failed to open the bootstrap file /var/lib/mysql-files/install-validate-password-plugin.QbNxlt.sql

<4> 日志详细描述:
2019-11-04T22:05:41.812222Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
2019-11-04T22:05:43.349026Z 0 [Warning] InnoDB: New log files created, LSN=45790
2019-11-04T22:05:43.506928Z 0 [Warning] InnoDB: Creating foreign key constraint system tables.
2019-11-04T22:05:43.646572Z 0 [Warning] No existing UUID has been found, so we assume that this is the first time that this server has been started. Generating a new UUID: 3f077b82-ff4f-11e9-b2b8-000c2976c3bb.
2019-11-04T22:05:43.652291Z 0 [Warning] Gtid table is not ready to be used. Table 'mysql.gtid_executed' cannot be opened.
2019-11-04T22:05:44.145921Z 0 [Warning] CA certificate ca.pem is self signed.
2019-11-04T22:05:44.514355Z 1 [Note] A temporary password is generated for root@localhost: ue7oa!g!a_dE
2019-11-04T22:05:48.822783Z 1 [ERROR] Failed to open the bootstrap file /var/lib/mysql-files/install-validate-password-plugin.QbNxlt.sql
2019-11-04T22:05:48.822797Z 1 [ERROR] 1105  Bootstrap file error, return code (0). Nearest query: 'SET @@sql_log_bin = @sql_log_bin;
'
2019-11-04T22:05:48.822939Z 0 [ERROR] Aborting

<5> 解决办法(由SELINUX导致):
    setenforce 0
    修改/etc/selinux/config 文件, 将SELINUX=enforcing改为SELINUX=disabled
<6> 重新执行service mysqld start, 启动成功
<7> 获取MySQL初始化时的默认root密码: less /var/log/mysqld.log | grep temporary password
<8> 登陆后修改root默认密码: alter user 'root'@'localhost' identified by '密码';
<9> 解决中文乱码问题: 在配置文件中的[mysqld]栏目下添加如下命令:
    character-set-server=utf8
```

