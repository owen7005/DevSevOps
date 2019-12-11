## 创建用户
```
create user "用户名"@"ip地址" identified by "密码";
在mysql5.7时, 不允许密码为简单的密码, 可以先执行下面的指令后再创建用户:

set global validate_password_policy=0;
set global validate_password_mixed_case_count=0;
set global validate_password_number_count=3;
set global validate_password_special_char_count=0;
set global validate_password_length=3;
```
## 修改用户密码
```
// mysql5.7
update mysql.user set authentication_string=password("密码") where user="用户名" and Host="ip地址";
```

## 赋予用户对数据库的权限
```
grant all privileges on *.* to "repl"@"192.168.157.128" identified by "abc123";
flush privileges;

grant select,update on 数据库.表名 to "用户名"@"主机名" identified by "该用户名对应的密码";
flush privileges;
```
