#!/bin/bash
#Description：批量或者单个删除容器
#################################################################################################
gw_get(){
	ifconfig $1 |awk -F'[: ]+' '/inet addr/{print $4}'
}
color_echo(){
	if [ $1 == "green" ]; then
		echo -e "\033[32;40m$2 \033[0m"
	elif [ $1 == "red" ];then
		echo -e "\033[31;40m$2 \033[0m"
	else
		echo "$2"
	fi
}
#################################################################################################
if [ $USER != "root" ]; then
	echo "Please use the root user operation or sudo."
	exit 
fi
if [ $# -ne 3 ]; then
	echo "Usage: bash $0 <container_name_prefix> [container_ip|ip_range_start-ip_range_end] <host_port_to_ssh_start>"
	echo "Example1: bash $0 docker_vm 10 1000"
	echo "Example2: bash $0 docker_vm 10-15 1000"
	exit 
fi
#################################################################################################
container_name_prefix=$1
container_ip=$2
host_port_to_ssh_start=$3

docker_vm_info_file=$PWD/docker_vm_info/docker_vm_info_$container_ip.txt

if 	[[ "$container_ip" =~ ^[0-9]{1,3}-[0-9]{1,3}$ ]]; then
	range_start=${container_ip%-*}
	range_end=${container_ip#*-}
	for ((i=$range_start;i<=$range_end;i++)); do 
		if $(docker ps |grep -w ${container_name_prefix}_$i >/dev/null); then
			color_echo green "$(docker rm -f ${container_name_prefix}_$i) removing successful."
			if $(rm $docker_vm_info_file >/dev/null 2>&1); then
				color_echo green "$docker_vm_info_file removing successful."
			fi
			#通过端口找到对应的IP
			c_ip=$(iptables -t nat -vnL |sed -nr "/$host_port_to_ssh_start/{s/.*to:(.*):.*/\1/p}")
			if [ -n "$c_ip" ]; then 
				iptables -t nat -D PREROUTING -d $(gw_get eth0) -p tcp --dport $host_port_to_ssh_start -j DNAT --to ${c_ip}:22 >/dev/null
				[ $? -ne 0 ] && color_echo red "${container_name_prefix}_$i iptables nat rule removing failure!"
			else 
				color_echo red "${container_name_prefix}_$i iptables nat rule not exist!"
			fi
		else
			color_echo red "${container_name_prefix}_$i not exist!"
		fi
	host_port_to_ssh_start=$(($host_port_to_ssh_start+1))
	done
elif [[ "$container_ip" =~ ^[0-9]{1,3}$ ]]; then
	c_name=${container_name_prefix}_$container_ip
	if $(docker ps |grep -w $c_name >/dev/null); then
		color_echo green "$(sudo docker rm -f $c_name) removing successful."
		if $(rm $docker_vm_info_file >/dev/null 2>&1); then
			color_echo green "$docker_vm_info_file removing successful."
		fi
		#通过端口找到对应的IP
		c_ip=$(iptables -t nat -vnL |sed -nr "/$host_port_to_ssh_start/{s/.*to:(.*):.*/\1/p}")
		if [ -n "$c_ip" ]; then 
			iptables -t nat -D PREROUTING -d $(gw_get eth0) -p tcp --dport $host_port_to_ssh_start -j DNAT --to ${c_ip}:22 >/dev/null
			[ $? -ne 0 ] && color_echo red "$c_name iptables nat rule removing failure!"
		else
			color_echo red "$c_name iptables nat rule not exist!"
		fi
	else
		color_echo red "$c_name not exist!"
	fi
else
	echo "Position parameter format error!"
	exit
fi