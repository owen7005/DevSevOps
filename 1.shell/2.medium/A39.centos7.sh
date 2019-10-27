############################################################
# File Name: system.sh
# Created Time: Fri 18 May 2018 05:01:02 PM CST
#==================================================================
#!/bin/sh
# 运行环境CentOS 7.x
# 运行前请删除中文注释

system=`uname -i`
if [ $system != "x86_64" ];then
echo "检测到此系统版本不是64位 !"
exit 1
fi
cat << EOF
+---------------------------------------+
| 您的系统是 CentOS 7.x_ x86_64 |
| 开始优化，请稍等....... |
+---------------------------------------
EOF

echo "下载wget·······"
yum -y install wget   &>/dev/null

echo "添加DNS地址，请稍等....... "
cat >> /etc/resolv.conf << EOF
nameserver 114.114.114.114 
nameserver 114.114.114.114 
EOF

echo "更换为Yum源,请稍等....... "
cd /etc/yum.repos.d/
mkdir yum_bak &>/dev/null
mv * yum_bak &>/dev/null
wget -O Centos-aliyun.repo http://mirrors.aliyun.com/repo/Centos-7.repo &>/dev/null
sed -i 's/$releasever/7/g' Centos-aliyun.repo &>/dev/null
yum makecache &>/dev/null
yum install epel-release -y &>/dev/null

echo "同步时间,请稍等....... "
if [ -f /usr/sbin/ntpdate ];then
echo ""
else
yum -y install ntp &>/dev/null
fi
/usr/sbin/ntpdate cn.pool.ntp.org &>/dev/null
echo “0 4 * * * /usr/sbin/ntpdate cn.pool.ntp.org” >> /var/spool/cron/root
systemctl restart crond.service

echo "安装vim,请稍等....... "
yum -y install vim &>/dev/null

echo "命令补全,请稍等....... "
yum install bash-completion -y &>/dev/null

echo "设置最大打开文件描述符数,请稍等......."
echo "ulimit -SHn 102400" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
* soft nofile 655350
* hard nofile 655350
EOF

echo "禁用selinux,请稍等......."
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo "关闭防火墙,请稍等......."
systemctl disable firewalld.service   &>/dev/null
systemctl stop firewalld.service

echo "优化ssh服务,请稍等......."
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
systemctl restart sshd.service

echo "-------<内核参数优化>-------"
cat >> /etc/sysctl.conf << EOF
vm.overcommit_memory = 1 #表示内核在分配内存时候做检查的方式
net.ipv4.ip_local_port_range = 1024 65536 #端口范围 1024~65535
net.ipv4.tcp_fin_timeout = 1 #保持在FIN-WAIT-2状态的时间
net.ipv4.tcp_keepalive_time = 1200 # TCP发送keepalive消息间隔时间（秒）
net.ipv4.tcp_mem = 94500000 915000000 927000000 #tcp整体缓存设置，对所有tcp内存使用状况的控制，单位是页，依次代表TCP整体内存的无压力值、压力模式开启阀值、最大使用值
net.ipv4.tcp_tw_reuse = 1 # 开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭
net.ipv4.tcp_tw_recycle = 1 # 开启重用，允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；
net.ipv4.tcp_timestamps = 0 # 关闭时间戳 “异常”的数据包
net.ipv4.tcp_synack_retries = 1 # 内核放弃连接之前发送SYN+ACK 包的数量
net.ipv4.tcp_syn_retries = 1 # 内核放弃建立连接之前发送SYN 包的数量
net.ipv4.tcp_abort_on_overflow = 0 #一个布尔类型的标志，控制着当有很多的连接请求时内核的行为
net.core.rmem_max = 16777216 # 指定了接收套接字缓冲区大小的最大值（以字节为单位）
net.core.wmem_max = 16777216 # 指定了发送套接字缓冲区大小的最大值（以字节为单位）
net.core.netdev_max_backlog = 262144 # 允许送到队列的数据包的最大数目
net.core.somaxconn = 262144 #系统中最多有多少个TCP 套接字不被关联到任何一个用户文件句柄上
net.ipv4.tcp_max_orphans = 3276800 #为了防止简单的DoS ***，不能过分依靠它
net.ipv4.tcp_max_syn_backlog = 262144 #表示SYN队列的长度
net.core.wmem_default = 8388608 #指定发送套接字缓冲区大小的缺省值（以字节为单位）
net.core.rmem_default = 8388608 #指定接收套接字缓冲区大小的缺省值（以字节为单位）
#net.ipv4.netfilter.ip_conntrack_max = 2097152 #最大内核内存中netfilter可以同时处理的“任务”（连接跟踪条目）
#net.nf_conntrack_max = 655360 #允许最大跟踪连接条目
#net.netfilter.nf_conntrack_tcp_timeout_established = 1200 # established的超时时间
EOF
/sbin/sysctl -p
echo "系统已优化完毕，请使用！"