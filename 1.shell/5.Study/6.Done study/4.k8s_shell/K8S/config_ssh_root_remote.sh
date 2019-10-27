#!/bin/bash
# Description: configuration root account ssh remote login
if [ $USER != "root" ]; then
    echo "Please use root account operation or sudo!"
    exit 1
fi
function color_echo() {
    if [ $1 == "green" ]; then
        echo -e "\033[32;40m$2\033[0m"
    elif [ $1 == "red" ]; then
        echo -e "\033[31;40m$2\033[0m"
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
            color_echo green "$PKG_NAME installation failure! Try to install again."
            apt-get autoremove && apt-get update
            apt-get install $PKG_NAME --force-yes -y
            [ $(check_pkg $PKG_NAME) == "no" ] && color_echo red "The $PKG_NAME installation failure!" && exit 1
        fi
    fi
}
install_pkg expect
# modify ssh config file
sed -r -i 's/(PermitRootLogin).*/\1 yes/' /etc/ssh/sshd_config
service ssh restart >/dev/null
# set root account password
echo "------------------------------------------------------>"
while true; do
    read -p "Please enter you want to set the root account password: " ROOT_PASS
    if [ -n "$ROOT_PASS" ]; then
        break
    else
        color_echo red "Password cannot be empty!"
        continue
    fi
done
expect -c "
    spawn passwd root
    expect {
        \"Enter new UNIX password:\" {send \"$ROOT_PASS\r\"; exp_continue}
        \"Retype new UNIX password:\" {send \"$ROOT_PASS\r\"}
    }
    expect eof
" >/dev/null
color_echo green "The root account password is: $ROOT_PASS"
