#!/bin/bash
# system: ubuntu
color_echo(){
    if [ $1 == "green" ]; then
        echo -e "\033[32;40m$2\033[0m"
    elif [ $1 == "red" ]; then
        echo -e "\033[31;40m$2\033[0m"
    fi
}
if [ $(cat /etc/issue |awk '{print $1}') != "Ubuntu" ]; then
	echo "Only support ubuntu operating system!"
	exit
fi
if [ $USER != "root" ]; then
    echo "Please use root account operation or sudo!"
    exit
fi
if $(dpkg -l docker-engine >/dev/null 2>&1) && $(docker info >/dev/null); then
    color_echo green "Docker is already installed!"
    exit
fi
DOCKER_COMPOSE_FILE=~/docker-compose-Linux-x86_64
if [ -e $DOCKER_COMPOSE_FILE ]; then
    mv $DOCKER_U_SOURCE /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >/dev/null 2>&1
if [ $? -eq 0 ]; then
    color_echo green "The secret key to register successfully."
else
    color_echo red "The secret key register failure!"
fi

DOCKER_U_SOURCE=/tmp/docker_source.tmp
cat >> $DOCKER_U_SOURCE << EOF
deb https://apt.dockerproject.org/repo ubuntu-precise main
deb https://apt.dockerproject.org/repo ubuntu-trusty main
deb https://apt.dockerproject.org/repo ubuntu-vivid main
deb https://apt.dockerproject.org/repo ubuntu-wily main
EOF
OS_CODE_V=$(lsb_release -cs)
DOKER_SOURCE=$(grep $OS_CODE_V $DOCKER_U_SOURCE)
echo "$DOKER_SOURCE" > /etc/apt/sources.list.d/docker.list
rm $DOCKER_U_SOURCE

color_echo green "Update software source ..."
apt-get update
color_echo green "Start the installation docker ..."
apt-get install docker-engine -y

if $(dpkg -l docker-engine >/dev/null) && $(docker info >/dev/null); then
    color_echo green "Docker installation successfully."
else
    apt-get autoremove ; apt-get update
    apt-get install docker-engine --force-yes -y
    if ! $(dpkg -l docker-engine >/dev/null); then
        color_echo red "Docker installation failure! Please try again."
        exit 1
    fi
fi
