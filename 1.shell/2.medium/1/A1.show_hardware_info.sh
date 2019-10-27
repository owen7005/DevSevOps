#!/bin/bash
##! /bin/sh
#Author : Zhang Zhigang  
# Date : 2016-07-01 13:50
# Des : The scripts is 基础信息
yum install hdparm dmidecode pciutils -y
echo
echo "###### CPU #######"
echo 
cat /proc/cpuinfo | grep "model name" | awk -F ":" '{print $2}' | uniq -f 1
cat /proc/cpuinfo | grep "cpu cores" | awk -F ":" '{print " CPU ="$2}' | uniq -f 1
echo
echo "###### Hard Disk ######"
echo
hdparm -i /dev/sda | grep -i "model" | awk -F "-" '{print $1}' | awk -F "=" '{print $2}'
fdisk -l | grep "/dev/sda" | awk -F "," 'NR==1{print $1}'
echo
df -h
echo
echo "###### Memory ######"
echo
dmidecode -t memory | grep -i "maximum capacity"
dmidecode -t memory | grep -i "number of devices"
echo 
dmidecode -t memory | grep -i "size" | awk -F ":" 'NR==1{print "        Capacity 1" $1":",$2}'
dmidecode -t memory | grep -i "speed" | awk 'NR==1' 
dmidecode -t memory | grep -i "type:" | uniq -f 1
dmidecode -t memory | grep -i "size" | awk -F ":" 'NR==2{print "        Capacity 2" $1":",$2}'
dmidecode -t memory | grep -i "speed" | awk 'NR==2' 
dmidecode -t memory | grep -i "type:" | uniq -f 1
dmidecode -t memory | grep -i "size" | awk -F ":" 'NR==3{print "        Capacity 3" $1":",$2}'
dmidecode -t memory | grep -i "speed" | awk 'NR==3'
dmidecode -t memory | grep -i "type:" | uniq -f 1
dmidecode -t memory | grep -i "size" | awk -F ":" 'NR==4{print "        Capacity 4" $1":",$2}'
dmidecode -t memory | grep -i "speed" | awk 'NR==4'
dmidecode -t memory | grep -i "type:" | uniq -f 1
echo 
free -m
echo
echo "###### Mianboard ######"
echo
dmidecode -q | grep -i "product name" | awk -F ":" 'NR==1{print "Server Model" ":",$2}'
dmidecode -q | grep -i "Manufacturer" | awk -F ":" 'NR==1{print "Brand" ":",$2}'
dmidecode -q | grep -i "product name" | awk -F ":" 'NR==2{print "Mainboard Model" ":",$2}'
echo
echo "###### Network Card ######"
echo
lspci | grep -i eth | awk 'NR==1' | awk -F ":" '{print $3}'
echo
echo "###### Operating System ######"
echo
cat /etc/issue | awk 'NR==1'  
uname -r | awk '{print "kernel: "$1}'
echo
