#!/bin/sh

iptables -F
iptables -t nat -F
iptables -Z
iptables -P INPUT DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

#for ping:
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -s 10.0.0.0/8  -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -s 100.0.0.0/8  -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -s 114.55.56.88/32  -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -s 116.231.36.205/32  -j ACCEPT

#for DNS:
iptables -A INPUT -p tcp --source-port 53 -j ACCEPT
iptables -A INPUT -p udp --source-port 53 -j ACCEPT

#for ntp:
iptables -A INPUT -p udp --source-port 123 -j ACCEPT
iptables -A INPUT -p udp --destination-port 123 -j ACCEPT

#for out:
#iptables -A INPUT -p tcp -m multiport  --dport 80,161,873   -j ACCEPT


#for aliyun
iptables -A INPUT -p all -s 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -p all -s 100.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp -s 116.231.61.247/32 -m multiport --dport 21,22,80,81,443,10051,873,161,3306,8000 -j ACCEPT
iptables -A INPUT -p tcp -s 116.193.50.87/32 -m multiport --dport 22,80,443,10051,873,161,3306 -j ACCEPT
iptables -A INPUT -p tcp -s 116.193.50.91/32 -m multiport --dport 22,80,443 -j ACCEPT
iptables -A INPUT -p tcp -s 42.196.45.48/32 -m multiport --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp -s 116.193.50.89/32 -m multiport --dport 22 -j ACCEPT

#for Local FTP Server:
#iptables -A INPUT -p tcp -m multiport --dport 21 -j ACCEPT
iptables -A INPUT -p tcp  --dport 50001:59999 -j ACCEPT


#for Local Rsync Server:
#iptables -A INPUT -p tcp --dport 873 -j ACCEPT


#others:
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
