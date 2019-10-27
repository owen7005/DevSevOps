#!/bin/bash
# Description: Installation Kubernetes1.1.3
# Etcd Download: https://github.com/coreos/etcd/releases/download/v2.2.2/etcd-v2.2.2-linux-amd64.tar.gz
# K8S Download: https://storage.googleapis.com/kubernetes-release/release/v1.1.3/kubernetes.tar.gz

. /lib/lsb/init-functions

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
function check_install_pkg() {
    if [ ! -e $ETCD_FILE -a ! -e $K8S_FILE ]; then
        color_echo red "$ETCD_FILE and $K8S_FILE file not exist!"
        exit 1
    elif [ ! -e $ETCD_FILE ]; then
        color_echo red "$ETCD_FILE file not exist!"
        exit 1
    elif [ ! -e $K8S_FILE ]; then
        color_echo red "$K8S_FILE file not exist!"
        exit 1
    fi
}
function local_ip() {
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
                    LOCAL_IP=${NIC_IP_ARRAY[0]#*:}
                    return 0
                fi
            done
            echo "Not match! Please input again."
        done
    fi
}
function check_ip() {
    local IP=$1
    VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
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
function cluster_ip() {
    if [ $1 == "master" ]; then
        while true; do
            read -p "Please enter master IP: " MASTER_IP
            check_ip $MASTER_IP
            [ $? -eq 0 ] && break
        done
    elif [ $1 == "minion" ]; then
        while true; do
            local MINION_NUM
            read -p "Please enter cluster minion node number: " MINION_NUM
            if [[ $MINION_NUM =~ ^[0-9]+$ ]]; then
                break
            else
                color_echo red "Format error!"
            fi
        done
        NUM=1
        while [ $NUM -le $MINION_NUM ]; do
            local MINION_IP
            read -p "Please enter minion host $NUM IP: " MINION_IP
            check_ip $MINION_IP
            if [ $? -eq 0 ]; then
                let NUM++
                MINION_IP_ARRAY+=($MINION_IP)
            fi
        done
    fi
}
function modify_init_script() {
    if [ $1 == "master" ]; then
        cd $MASTER_MODULE_INIT_SCRIPT_DIR
    elif [ $1 == "minion" ]; then
        cd $MINION_MODULE_INIT_SCRIPT_DIR
    fi
    for MODULE_INIT_SCRIPT in $(ls|grep -v etcd); do
        if [ -x $MODULE_INIT_SCRIPT ]; then
            sed -r -i '/\/sbin\/initctl/{s/(if)(.*)/\1 false \&\&\2/}' $MODULE_INIT_SCRIPT
        fi
    done
}
function check_service_status() {
    sleep 1
    if [ $(ps -ef |grep -v grep|grep -c "$BIN_DIR/$MODULE_INIT_SCRIPT") -eq 1 ]; then
        log_begin_msg "Starting $MODULE_INIT_SCRIPT"
        log_end_msg 0 # 0 is the right command execution status
    else
        log_failure_msg "$(color_echo red "Starting $MODULE_INIT_SCRIPT")"
        log_end_msg 1 # 1 is the wrong command execution status
    fi
}
function check_exec_status() {
    if [ $? -ne 0 ]; then
        color_echo green "Please try to run the script!"
        exit 1
    fi
}

BASE_DIR=$PWD
ETCD_FILE=$BASE_DIR/etcd-v2.2.2-linux-amd64.tar.gz
K8S_FILE=$BASE_DIR/kubernetes.tar.gz
BIN_DIR=/opt/bin
INIT_SCRIPT_DIR=/etc/init.d
OPTS_FILE_DIR=/etc/default
MODULE_BIN_DIR=$BASE_DIR/kubernetes/server/bin
MASTER_MODULE_INIT_SCRIPT_DIR=$BASE_DIR/kubernetes/cluster/ubuntu/master/init_scripts
MINION_MODULE_INIT_SCRIPT_DIR=$BASE_DIR/kubernetes/cluster/ubuntu/minion/init_scripts

case $1 in
master)
    check_install_pkg
    pkill etcd ; pkill kube
    cluster_ip minion
    # Create binary file directory
    [ ! -d $BIN_DIR ] && mkdir $BIN_DIR
    # Installation storage system etcd
    log_action_msg "Unzip the $ETCD_FILE"
    tar zxf $ETCD_FILE ; check_exec_status
    cp $BASE_DIR/etcd-v2.2.2-linux-amd64/etc* $BIN_DIR ; check_exec_status
    echo "
    ETCD_OPTS=\"\
    --listen-client-urls http://0.0.0.0:4001 \
    --advertise-client-urls http://0.0.0.0:4001 \
    --data-dir /var/lib/etcd/default.etcd\"
    " > $OPTS_FILE_DIR/etcd
    # Installation module kube-apiserver kube-scheduler and kube-controller-manager
    log_action_msg "Unzip the $K8S_FILE"
    tar zxf $BASE_DIR/kubernetes.tar.gz ; check_exec_status
    tar zxf $BASE_DIR/kubernetes/server/kubernetes-server-linux-amd64.tar.gz ; check_exec_status
    cd $MODULE_BIN_DIR && cp -a kubectl kube-apiserver kube-scheduler kube-controller-manager $BIN_DIR ; check_exec_status
    # Configure init scripts
    modify_init_script master
    cp -a etcd kube-* $INIT_SCRIPT_DIR ; check_exec_status
    sed -i '63s/.*/"/' $INIT_SCRIPT_DIR/etcd  #Remove the append log file,Otherwise etcd may cannot be started
    # Module Configure option
    log_action_msg "Create $OPTS_FILE_DIR/kube-apiserver startup options file ..."
    echo "
    KUBE_APISERVER_OPTS=\"\
    --insecure-bind-address=0.0.0.0 \
    --insecure-port=8080 \
    --service-cluster-ip-range=10.0.0.0/16 \
    --etcd_servers=http://127.0.0.1:4001 \
    --logtostderr=true\"
    " > $OPTS_FILE_DIR/kube-apiserver
    check_exec_status
    log_action_msg "Create $OPTS_FILE_DIR/kube-controller-manager startup options file ..."
    echo "
    KUBE_CONTROLLER_MANAGER_OPTS=\"\
    --master=127.0.0.1:8080 \
    --logtostderr=true\"
    " > $OPTS_FILE_DIR/kube-controller-manager
    log_action_msg "Create $OPTS_FILE_DIR/kube-scheduler startup options file ..."
    echo "
    KUBE_SCHEDULER_OPTS=\"\
    --master=127.0.0.1:8080 \
    --logtostderr=true\"
    " > $OPTS_FILE_DIR/kube-scheduler
    # Starting module
    for MODULE_INIT_SCRIPT in $(ls $INIT_SCRIPT_DIR|grep -E "(etcd|kube.*)"); do
        service $MODULE_INIT_SCRIPT start >/dev/null
        check_service_status
    done
    # set variable
    echo "export PATH=$PATH:$BIN_DIR" >> /etc/profile
    . /etc/profile
    # Copy module kubelet and kube-proxy to minion
    SSH_OPTS="-o ConnectTimeout=1 -o ConnectionAttempts=3"
    cd $MODULE_BIN_DIR
    for MINION_IP in ${MINION_IP_ARRAY[*]}; do
        log_action_msg "Copy module to $MINION_IP:$BIN_DIR ..."
        ssh $SSH_OPTS root@$MINION_IP "[ ! -d $BIN_DIR ] && mkdir $BIN_DIR" ; check_exec_status
        scp $SSH_OPTS kubelet kube-proxy root@$MINION_IP:$BIN_DIR
    done
    # Copy module init scripts to minion
    modify_init_script minion
    cd $MINION_MODULE_INIT_SCRIPT_DIR
    for MINION_IP in ${MINION_IP_ARRAY[*]}; do
        log_action_msg "Copy module init scripts to $MINION_IP:$INIT_SCRIPT_DIR ..."
        scp $SSH_OPTS kubelet kube-proxy root@$MINION_IP:$INIT_SCRIPT_DIR ; check_exec_status
    done
    color_echo green "Kubernetes master installation complete."
    ;;
minion)
    cluster_ip master # Notice input master ip
    local_ip
    pkill kube
    # Install Docker
    if ! $(dpkg -l docker-engine >/dev/null 2>&1) && ! $(docker info >/dev/null 2>&1); then
        log_action_msg "Start the installation Docker ..."
        apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >/dev/null 2>&1
        [ $? -ne 0 ] && echo "Docker source secret key register failure!"
        DOCKER_U_SOURCE=/tmp/docker_source.tmp
        echo "
        deb https://apt.dockerproject.org/repo ubuntu-precise main
        deb https://apt.dockerproject.org/repo ubuntu-trusty main
        deb https://apt.dockerproject.org/repo ubuntu-vivid main
        deb https://apt.dockerproject.org/repo ubuntu-wily main
        " > $DOCKER_U_SOURCE
        OS_CODE_V=$(lsb_release -cs)
        DOKER_SOURCE=$(grep $OS_CODE_V $DOCKER_U_SOURCE)
        echo "$DOKER_SOURCE" > /etc/apt/sources.list.d/docker.list
        rm $DOCKER_U_SOURCE
        apt-get update
        apt-get install docker-engine  -y
        if $(dpkg -l docker-engine >/dev/null) && $(docker info >/dev/null); then
            color_echo green "Docker installation successfully."
        else
            apt-get remove ; apt-get install docker-engine --force-yes -y
            if ! $(dpkg -l docker-engine >/dev/null) && ! $(docker info >/dev/null); then
                color_echo red "Docker installation failure!"
                exit 1
            fi
        fi
    fi
    # Module Configure option
    log_action_msg "Create $OPTS_FILE_DIR/kubelet startup options file ..."
    echo "
    KUBELET_OPTS=\"\
    --address=0.0.0.0 \
    --port=10250 \
    --hostname_override=$LOCAL_IP \
    --api_servers=http://$MASTER_IP:8080 \
    --pod-infra-container-image=docker.io/kubernetes/pause:latest \
    --logtostderr=true\"
    " > $OPTS_FILE_DIR/kubelet
    log_action_msg "Create $OPTS_FILE_DIR/kube-proxy startup options file ..."
    echo "
    KUBE_PROXY_OPTS=\"\
    --master=http://$MASTER_IP:8080 \
    --proxy-mode=iptables \
    --logtostderr=true\"
    " > $OPTS_FILE_DIR/kube-proxy
    # Starting module
    for MODULE_INIT_SCRIPT in $(ls $INIT_SCRIPT_DIR|grep kube.*); do
        service $MODULE_INIT_SCRIPT start >/dev/null
        check_service_status
    done
    color_echo green "Kubernetes minion installation complete."
    ;;
*)
    echo "Usage: $0 {master|minion}"
    exit 1
    ;;
esac
