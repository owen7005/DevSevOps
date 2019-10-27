#!/bin/bash
# Description: configuration docker host between GRE Channel
if [ $(cat /etc/issue |awk '{print $1}') != "Ubuntu" ]; then
    echo "Only support ubuntu operating system!"
    exit 1
fi
if [ $USER != "root" ]; then
    echo "Please use root account operation!"
    exit 1
fi
function color_echo() {
    if [ $1 == "green" ]; then
        echo -e "\033[32;40m$2\033[0m"
    elif [ $1 == "red" ]; then
        echo -e "\033[31;40m$2\033[0m"
    fi
}
function check_ip() {
    local IP=$1
    local VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
    if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" >/dev/null; then
        if [ ${VALID_CHECK:-no} == "yes" ]; then
            return 0
        else
            echo "IP $IP not available!"
            return 1
        fi
    else
        echo "IP format error!"
        return 1
    fi
}
function docker_host_ip() {
        color_echo green "Notice: Only support two Docker host configuration GRE Channel!"
        NUM=1
        while [ $NUM -le 2 ]; do
            local DOCKER_IP
            read -p "Please enter Docker host $NUM IP: " DOCKER_HOST_IP
            check_ip $DOCKER_HOST_IP
            if [ $? -eq 0 ]; then
                let NUM++
                DOCKER_HOST_IP_ARRAY+=($DOCKER_HOST_IP)
            fi
        done
}
function local_nic_info() {
    local NUM ARRAY_LENGTH
    NUM=0
    for NIC_NAME in $(ls /sys/class/net|grep -vE "lo|docker0"); do
        NIC_IP=$(ifconfig $NIC_NAME |awk -F'[: ]+' '/inet addr/{print $4}')
        if [ -n "$NIC_IP" ]; then
            NIC_IP_ARRAY[$NUM]="$NIC_NAME:$NIC_IP"
            let NUM++
        fi
    done
    ARRAY_LENGTH=${#NIC_IP_ARRAY[*]}
    if [ $ARRAY_LENGTH -eq 1 ]; then
        LOCAL_NIC=${NIC_IP_ARRAY[0]%:*}
        LOCAL_IP=${NIC_IP_ARRAY[0]#*:}
        return 0
    elif [ $ARRAY_LENGTH -eq 0 ]; then
        color_echo red "No available network card!"
        exit 1
    else
        # multi network card select
        for NIC in ${NIC_IP_ARRAY[*]}; do
            echo $NIC
        done
        while true; do
            read -p "Please enter local use to network card name: " INPUT_NIC_NAME
            for NIC in ${NIC_IP_ARRAY[*]}; do
                NIC_NAME=${NIC%:*}
                if [ $NIC_NAME == "$INPUT_NIC_NAME" ]; then
                    LOCAL_NIC=${NIC_IP_ARRAY[0]%:*}
                    LOCAL_IP=${NIC_IP_ARRAY[0]#*:}
                    return 0
                fi
            done
            echo "Not match! Please input again."
        done
    fi
}
function check_pkg() {
    if ! $(dpkg -l $PKG_NAME >/dev/null 2>&1); then
        echo no
    else
        echo yes
    fi
}
function install_pkg() {
    local PKG_NAME=$1
    if [ $(check_pkg $PKG_NAME) == "no" ]; then
        apt-get install $PKG_NAME -y
        if [ $(check_pkg $PKG_NAME) == "no" ]; then
            color_echo green "The $PKG_NAME installation failure! Try to install again."
            apt-get autoremove && apt-get update
            apt-get install $PKG_NAME --force-yes -y
            [ $(check_pkg $PKG_NAME) == "no" ] && color_echo red "The $PKG_NAME installation failure!" && exit 1
        fi
    fi
}
function config_gre_channel() {
    install_pkg openvswitch-switch
    install_pkg bridge-utils
    if [ ${DOCKER_HOST_IP_ARRAY[0]} == "$LOCAL_IP" ]; then
        REMOTE_HOST_IP=${DOCKER_HOST_IP_ARRAY[1]}  # remote host ip
        REMOTE_DOCKER_IP="172.17.2.0/24"   # remote docker host default container ip range
        LOCAL_DOCKER_IP="172.17.1.0"    # kbr0 gateway
    elif [ ${DOCKER_HOST_IP_ARRAY[1]} == "$LOCAL_IP" ]; then
        REMOTE_HOST_IP=${DOCKER_HOST_IP_ARRAY[0]}
        REMOTE_DOCKER_IP="172.17.1.0/24"
        LOCAL_DOCKER_IP="172.17.2.0"
    else
        echo "IP not match! Please input again."
        exit 1
    fi
    ovs-vsctl add-br obr0 2>/dev/null
    ovs-vsctl add-port obr0 gre0 -- set Interface gre0 type=gre options:remote_ip=$REMOTE_HOST_IP 2>/dev/null
    brctl addbr kbr0 2>/dev/null
    brctl addif kbr0 obr0 2>/dev/null
    ip link set dev kbr0 up
    if [ $(grep -cE "kbr0" /etc/network/interfaces) -ne 2 ]; then
        echo "
auto kbr0
iface kbr0 inet static
    address $(echo $LOCAL_DOCKER_IP|sed 's/0$/1/')
    netmask 255.255.255.0
    gateway $LOCAL_DOCKER_IP
    bridge_ports obr0
        " >> /etc/network/interfaces
    fi
    if $(ls /sys/class/net|grep docker0 >/dev/null); then
        service docker stop >/dev/null
        ip link set dev docker0 down
        ip link delete dev docker0
        echo "DOCKER_OPTS=\"-b=kbr0\"" > /etc/default/docker
        service docker start >/dev/null
    fi
    ifdown kbr0 >/dev/null 2>&1;ifup kbr0 >/dev/null 2>&1
    ip route add $REMOTE_DOCKER_IP via $REMOTE_HOST_IP dev $LOCAL_NIC 2>/dev/null
}
# main
docker_host_ip
echo "--------------------------------------------"
local_nic_info
config_gre_channel
color_echo green "GRE Channel configuration complete."
brctl show
echo "-------------------------------------------------"
ovs-vsctl show
