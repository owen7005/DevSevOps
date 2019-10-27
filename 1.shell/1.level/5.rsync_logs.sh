#!/bin/bash
#Author : https://github.com/owen7005
# Date : 2016-07-01 13:50
# Des : The scripts is rsync logs to nginx web
# Use : sh rsync_logs.sh
#
#同步api服务器日志到nginx:/data/www/fsd_log/api_log
/usr/bin/salt "Fsd-api01" cmd.run "rsync -avz --delete --progress  --exclude-from=/root/scripts/exclude_log.txt /data/credit-api-8081/logs/ root@10.25.4.254::logs/api_log/api01/"
sleep 3
/usr/bin/salt "Fsd-api02" cmd.run "rsync -avz --delete --progress  --exclude-from=/root/scripts/exclude_log.txt /data/credit-api-8081/logs/ root@10.25.4.254::logs/api_log/api02/"

#同步mg后台服务器日志到nginx:/data/www/fsd_log/mg_log
/usr/bin/salt "Fsd-mg01" cmd.run "rsync -avz --delete --progress  --exclude-from=/root/scripts/exclude_log.txt /data/credit-web-8080/logs/ root@10.25.4.254::logs/mg_log/mg01/"
sleep 3
/usr/bin/salt "Fsd-mg02" cmd.run "rsync -avz --delete --progress  --exclude-from=/root/scripts/exclude_log.txt /data/credit-web-8080/logs/ root@10.25.4.254::logs/mg_log/mg02/"

#同步op运营后台服务器日志到nginx:/data/www/fsd_log/op_log
/usr/bin/salt "Fsd-pic01" cmd.run "rsync -avz --delete --progress  --exclude-from=/root/scripts/exclude_log.txt /data/credit-operating-8780/logs/ root@10.25.4.254::logs/op_log/op01/"
sleep 3
/usr/bin/salt "Fsd-pic02" cmd.run "rsync -avz --delete --progress  --exclude-from=/root/scripts/exclude_log.txt /data/credit-operating-8780/logs/ root@10.25.4.254::logs/op_log/op02/"

#同步H5运营后台服务器日志到nginx:/data/www/fsd_log/salesman_log
/usr/bin/salt "Fsd-pic01" cmd.run "rsync -avz --delete --progress  --exclude-from=/root/scripts/exclude_log.txt /data/credit-salesman-8880/logs/ root@10.25.4.254::logs/salesman_log/sales01/"
sleep 3
/usr/bin/salt "Fsd-pic02" cmd.run "rsync -avz --delete --progress  --exclude-from=/root/scripts/exclude_log.txt /data/credit-salesman-8880/logs/ root@10.25.4.254::logs/salesman_log/sales02/"

#同步online服务器日志到预发布图片01
#/usr/bin/salt "Fsd-pic01-test" cmd.run "rsync -avz --delete --progress --exclude=log_bak root@10.25.4.254::logs /data/bak/onlinelogs/"
