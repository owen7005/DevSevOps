#!/bin/bash
#Author : https://github.com/owen7005
# Date : 2016-07-01 13:50
# Program:system_init_shell
# Create date:2013/05/14 
# Qq mail:549651664@qq.com
# Release:version0.1


cat << EOF
 +--------------------------------------------------------------+
 | === Welcome to CentOS 6.x System init ==      |
 +--------------------------------------------------------------+
EOF

#安装服务器所需常用软件包
yum -y install lsof ntp wget make sudo telnet net-snmp xinetd openssh-clients ntpdate chkconfig unzip zip bzip2 bzip2-devel gcc gcc-c++ ncurses-devel pcre-devel zlib-devel openssh-client* openssl*

#设置服务器时间同步
   if [ ! -n "`awk '/ntpdate/' /var/spool/cron/root`" ];then
   echo "*/10 * * * * /usr/sbin/ntpdate 202.112.29.82 > /dev/null 2>&1" >> /var/spool/cron/root
   service crond restart
   fi
clock -w 
 
#对于每个用户，系统限制其最大进程数
    ulimit  -u 65535

#设置core文件大小
   if [ ! -n "`awk '/unlimited/' /etc/profile`" ];then
     echo "ulimit -c unlimited" >>/etc/profile
   fi

#限制任意用户的最大线程数和文件数为65535
   if [ ! -n "`awk '/65535/' /etc/security/limits.conf`" ];then
     cat >> /etc/security/limits.conf << EOF
*       soft    nofile  65535
*       hard    nofile  65535
*       soft    nproc   65535
*       hard    nproc   65535
EOF
  fi

#禁止用control-alt-delete 关机
 sed -i 's#^exec /sbin/shutdown -r now#\#exec /sbin/shutdown -r now#'   /etc/init/control-alt-delete.conf

#设置字体字体为utf-8
  sed -i '/LANG/d' /etc/sysconfig/i18n
  cat >> /etc/sysconfig/i18n << EOF
LANG="en_US.UTF-8"
EOF


#优化内核参数
sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_tw_recycle/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
sed -i 's/net.bridge.bridge-nf-call/#net.bridge.bridge-nf-call/g' /etc/sysctl.conf
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_syncookies = 1 
net.ipv4.tcp_tw_reuse = 1 
net.ipv4.tcp_tw_recycle = 1 
net.ipv4.tcp_fin_timeout = 30
EOF
/sbin/sysctl -p


#关闭selinux
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
setenforce 0
echo -e "\033[32;36m selinux shutdown ok......\033[0m"

#配置服务器dns解析ip
rm -f /etc/resolv.conf 
cat >> /etc/resolv.conf << EOF
nameserver 202.96.209.133
nameserver 8.8.8.8
EOF
echo -e "\033[32;36m set dns config ok......\033[0m"



#添加一个普通账户admin
#aduser=`cat /etc/passwd|grep admin|awk -F: '{print $1}'`
#if [ -n "$aduser" ];then
#  echo -e "\033[32;36m add user admin ok......\033[0m"
#else
#  useradd admin
#  echo -e "\033[32;36m add user admin ok......\033[0m"
#fi

#关闭不必要的服务
for i in `ls /etc/rc3.d/S*`
do
   CURSRV=`echo $i|cut -c 15-`
   echo $CURSRV
case $CURSRV in
   crond | irqbalance | network | sshd | rsyslog | sysstat|local )
   echo "Base services, Skip!"
   ;;
   *)
   echo "change $CURSRV to off"
   chkconfig --level 2345 $CURSRV off
   service $CURSRV stop
   ;;
esac
done
echo -e "\033[32;36m service is init is ok......\033[0m"

#删除系统不必要的账号和组
 for user in adm lp sync shutdown halt news uucp operator games gopher ftp
 do
   userdel  $user  >/dev/null 2>&1
   groupdel $user  >/dev/null 2>&1
 done

#设置时区
\cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
/usr/sbin/ntpdate 202.112.29.82

exit 0
