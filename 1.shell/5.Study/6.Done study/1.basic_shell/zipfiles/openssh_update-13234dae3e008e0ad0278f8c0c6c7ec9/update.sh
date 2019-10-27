#!/bin/bash
local_dir=/etc/yum.repos.d/
day=`date +%Y%m%d`
openssh=`rpm -qa |grep openssh-[0-9] |head -n 1 |awk -F'-' '{print $3}' |awk -F'.' '{print $1}'`

if [[ ${openssh} -lt 118 ]];then
    cd $local_dir 
    [ ! -d bak$day ] && mkdir bak$day
    mv *  bak$day &>/dev/null
    echo "check the openssh version"
    rpm -qa |grep openssh
    echo "now update the openssh"
    echo "..."
    wget http://192.168.163.213/yum/repo/openssh_update_118.repo &>/dev/null
    yum clean all &>/dev/null
    yum repolist &>/dev/null
    yum update openssh -y  &>/dev/null
    mv bak$day/* ./  &>/dev/null
    mv openssh_update_118.repo bak$day/  &>/dev/null
    rm -rf /etc/yum.repos.d/bak$day  &>/dev/null
    service openssh reload &>/dev/null
    yum clean all &>/dev/null
    yum repolist &>/dev/null
    echo "check the openssh version again"
    rpm -qa |grep openssh
else
    echo "openssh has been updated!"
    rpm -qa |grep openssh
fi



