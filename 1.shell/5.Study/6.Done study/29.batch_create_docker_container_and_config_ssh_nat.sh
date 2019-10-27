#!/bin/bash
#Description：批量或者单个创建容器，并配置SSH端口映射(前提：镜像已经安装SSH)
#待改善之处：1.对位置参数合法性判断 2.添加iptables转发规则时，是否端口已经使用
#################################################################################################
#获取IP
# function nic(){
# 	local NIC_LIST=$(ls /sys/class/net|grep -vE "lo|docker0")
# 	for NIC in $NIC_LIST; do
# 		if [ $NIC == "eth0" ]; then
# 			echo "eth0"
# 		elif [ $NIC == "eth1" ]; then
# 			echo "eth1"
# 		elif [ $NIC == "em0" ]; then
# 			echo "em0"
# 		elif [ $NIC == "em1" ]; then
# 			echo "em1"
# 		fi
# 	done
# }
# LOCAL_IP=$(ifconfig $(nic) |awk -F'[: ]+' '/inet addr/{print $4}')
gw_get(){
	ifconfig $1 |awk -F'[: ]+' '/inet addr/{print $4}'
}
#字符串颜色
color_echo(){
	if [ $1 == "green" ]; then
		echo -e "\033[32;40m$2 \033[0m"
	elif [ $1 == "red" ];then
		echo -e "\033[31;40m$2 \033[0m"
	else
		echo "$2"
	fi
}
#保存创建的容器信息及备份iptables规则
save_container_info(){
	#如果容器创建失败就不做保存操作
	if [ $(cat $tmp_file |wc -l) -eq 2 -o ${#failure_num[*]} -eq $1 ]; then
	#if [ ${#failure_num[*]} -eq $1 ]; then
		rm $tmp_file
		echo "Conainer to create failure, not generate container information file!"
	else
		[ ! -d ${docker_vm_info_file%/*} ] && mkdir -p ${docker_vm_info_file%/*}
		column -t $tmp_file > $docker_vm_info_file && rm $tmp_file
		echo "Container information saved in the $docker_vm_info_file"
		#保存iptables规则
		[ ! -d $iptables_backup_dir ]  && mkdir $iptables_backup_dir
		iptables-save > $iptables_backup_dir/$(date +%F)_$container_ip
		echo "Notice: Iptables rules backup to $iptables_backup_dir"
	fi
}
###################################################################################################
from_image=$1
container_name_prefix=$2    
container_ip=$3
host_port_to_ssh=$4
host_data_volume_path=$5
container_data_volume_path=$6
option1=$7
value1=$8
option2=${9}
value2=${10}
###################################################################################################
if [ $USER != "root" ]; then
	echo "Warning: Please use the root user operation or sudo!"
	exit 
fi
if [ $# -ne 6 -a $# -ne 8 -a $# -ne 10 ]; then
	echo "Usage: bash $0 <from_image> <container_name_prefix> [container_ip|ip_range_start-ip_range_end] <host_port_to_ssh> <host_data_volume_path> <container_data_volume_path> [args]"
	echo "Example1: bash $0 ubuntu14:base docker_vm 10-15 1000 /docker_data_volume /data"
	echo "Example2: bash $0 ubuntu14:base docker_vm 10 1000 /docker_data_volume /data"
	echo "Example3: bash $0 ubuntu14:base docker_vm 10 1000 /docker_data_volume /data -m 512m --memory-swap 512m"
	exit 
fi
if ! `dpkg -l arping >/dev/null`; then 
	apt-get install arping -y
fi
if ! `which pipework >/dev/null`; then
	[ ! `which git` ] && apt-get install git -y
	git clone https://github.com/jpetazzo/pipework.git
	cp $PWD/pipework/pipework /usr/local/bin/
	rm -rf $PWD/pipework/pipework
fi
if [[ ! $host_port_to_ssh =~ ^[0-9]{1,5}$ ]] || [ ! $host_port_to_ssh -ge 1 -o ! $host_port_to_ssh -le 65535 ]; then
	color_echo red "host_port_to_ssh must be 1-65535 number!"
	exit
fi
###################################################################################################

docker_vm_info_file=$PWD/docker_vm_info/docker_vm_info_$container_ip.txt
iptables_backup_dir=/etc/iptables_rules_backup
tmp_file=/tmp/docker_vm_info_$container_ip.txt

echo "From_Image  Container_Name  Conainer_IP  Host_Port_To_SSH  Host_IP  User_Name  Password  host_data_volume_path container_data_volume_path" > $tmp_file
echo "----------  --------------  -----------  ----------------  -------  ---------  --------  --------------------- --------------------------" >> $tmp_file

if 	[[ "$container_ip" =~ ^[0-9]{1,3}-[0-9]{1,3}$ ]]; then
	ip_start=${container_ip%-*}
	ip_end=${container_ip#*-}
	for ((i=$ip_start;i<=$ip_end;i++)); do 
		c_ip=$(echo "$(gw_get docker0)" |sed 's/[0-9]$//')$i
		c_name=${container_name_prefix}_$i
		container_host_name=${container_name_prefix}_$i
		if $(docker ps |grep -w $c_name >/dev/null); then
			color_echo red "$c_name container already exist!"
			continue
		fi   
		#创建容器
		docker run -it -d --name $c_name --net=none --add-host=$c_name:$c_ip --hostname=$container_host_name -v $host_data_volume_path/${c_name}:$container_data_volume_path $option1 $value1 $option2 $value2 $from_image /bin/bash >/dev/null
		if [ $? -eq 0 ]; then
			#配置IP
			pipework docker0 $c_name $c_ip/24@$(gw_get docker0) >/dev/null
			if [ $? -eq 0 ]; then
				#配置SSH NAT映射
				iptables -t nat -A PREROUTING -d $(gw_get eth0) -p tcp --dport $host_port_to_ssh -j DNAT --to ${c_ip}:22 >/dev/null
				if [ $? -eq 0 ]; then
					#启动容器SSH服务
					docker exec $c_name /etc/init.d/ssh start >/dev/null
					if [ $? -ne 0 ]; then
						color_echo red "$c_name start ssh faiure!"
					fi
				else
					color_echo red "$c_name configure iptables nat rule failure!"
					continue
				fi
			else
				color_echo red "$c_name configure ip failure!"
				continue
			fi
		else
			failure_num+=(no)    #no字符值(任意字符都可以)追加到数组failure_num
			color_echo red "$c_name create failure!"
			continue
		fi
		color_echo green "$c_name creating successful."
		echo "$from_image $c_name $c_ip $host_port_to_ssh $(gw_get eth0) loongtao loongtao $host_data_volume_path/${c_name} $container_data_volume_path" >> $tmp_file
		host_port_to_ssh=$(($host_port_to_ssh+1))
	done 
	create_container_num=$(($ip_end-$ip_start+1))
	save_container_info $create_container_num
elif [[ "$container_ip" =~ ^[0-9]{1,3}$ ]]; then
	c_ip=$(echo "$(gw_get docker0)" |sed 's/[0-9]$//')$container_ip
	c_name=${container_name_prefix}_$container_ip
	container_host_name=$c_name
	docker run -it -d --name $c_name --net=none --add-host=$c_name:$c_ip --hostname=$container_host_name -v $host_data_volume_path/${c_name}:$container_data_volume_path $option1 $value1 $option2 $value2 $from_image /bin/bash >/dev/null
	if [ $? -eq 0 ]; then
		pipework docker0 $c_name $c_ip/24@$(gw_get docker0) >/dev/null
		if [ $? -eq 0 ]; then
			iptables -t nat -A PREROUTING -d $(gw_get eth0) -p tcp --dport $host_port_to_ssh -j DNAT --to ${c_ip}:22 >/dev/null
			if [ $? -eq 0 ]; then
				docker exec $c_name /etc/init.d/ssh start >/dev/null
				if [ $? -ne 0 ]; then
					color_echo red "$c_name start ssh faiure!"
				fi
			else
				color_echo red "$c_name configure iptables nat rule failure!"
			fi
		else
			color_echo red "$c_name configure ip failure!"
		fi
	else
		failure_num+=(no)
		color_echo red "$c_name create failure!"
		exit
	fi
	color_echo green "$c_name creating successful."
	echo "$from_image $c_name $c_ip $host_port_to_ssh $(gw_get eth0) loongtao loongtao $host_data_volume_path/${c_name} $container_data_volume_path" >> $tmp_file
	save_container_info 1
else
	echo "Position parameter format error!"
	exit
fi
echo " " >> $docker_vm_info_file
echo "----------------------------------------------------------------" >> $docker_vm_info_file
read -p "请输入使用者名字: " user_name
echo "| User: $user_name" >> $docker_vm_info_file
echo "| SSH Remote Connection Usage: 'ssh -p Host_Port_To_SSH User_Name@Host_IP'" >> $docker_vm_info_file
echo "| Notice: Please send the data stored in the $container_data_volume_path directory" >> $docker_vm_info_file
echo "----------------------------------------------------------------" >> $docker_vm_info_file