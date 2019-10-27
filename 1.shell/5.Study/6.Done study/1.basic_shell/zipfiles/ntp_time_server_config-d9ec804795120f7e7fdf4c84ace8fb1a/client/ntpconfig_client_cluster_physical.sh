#/bin/bash
#时间服务器：“192.168.110.1”
#该脚本启用了历史记录
#该脚本通过ntp服务来同步时间，rhel7系统默认的chronyd服务将会被禁用
#该脚本用于物理机集群配置ntp服务器

rhel_version=`cat /etc/redhat-release`
rhel='Red Hat Enterprise Linux'
version7='release 7'
index=`awk -v a="$rhel_version" -v b="$rhel" 'BEGIN{print index(a,b)}'`
if [ $index -ne 0 ]; then
    index=`awk -v a="$rhel_version" -v b="$version7" 'BEGIN{print index(a,b)}'`
    if [ $index -ne 0 ]; then
        echo "Disable chronyd deamon."
        systemctl stop chronyd
        systemctl disable chronyd
        echo "Install ntpd deamon."
        yum install ntp -y
        systemctl enable ntpd
        echo "Start ntpd deamon."
        systemctl start ntpd
    else
        echo "Install ntpd deamon."
        yum install ntp -y
        echo "Start ntpd deamon."
        service ntpd start
    fi
else
    echo "The current operating system is not Red Hat Enterprise Linux."
    exit 1
fi

# Write NTP configuration
# Backup ntp.conf
currentTimestamp=`date +%y-%m-%d-%H:%M:%S`
ntp_conf="/etc/ntp.conf"
ntp_conf_backup=$ntp_conf.ntpconfig.$currentTimestamp
if [ -f "$ntp_conf" ]; then
    echo backup $ntp_conf to $ntp_conf_backup
    cp $ntp_conf $ntp_conf_backup
fi

# Write ntp.conf
echo "

    tinker step 0.5 

    # For more information about this file, see the man pages
    # ntp.conf(5), ntp_acc(5), ntp_auth(5), ntp_clock(5), ntp_misc(5), ntp_mon(5).

    driftfile /var/lib/ntp/drift

    # Permit time synchronization with our time source, but do not
    # permit the source to query or modify the service on this system.
    restrict default kod nomodify notrap nopeer noquery  
    restrict -6 default kod nomodify notrap nopeer noquery  

    # Permit all access over the loopback interface.  This could
    # be tightened as well, but to do so would effect some of
    # the administrative functions.
    restrict 127.0.0.1
    restrict -6 ::1

    # Hosts on local network are less restricted. 
    #restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap

    server 192.168.110.1 iburst 

    # Enable public key cryptography.
    #crypto

    includefile /etc/ntp/crypto/pw

    # Key file containing the keys and key identifiers used when operating
    # with symmetric key cryptography. 
    keys /etc/ntp/keys

    # Specify the key identifiers which are trusted.    
    #trustedkey 4 8 42 

    # Specify the key identifier to use with the ntpdc utility.   
    #requestkey 8 

    # Specify the key identifier to use with the ntpq utility.   
    #controlkey 8 

    # Enable writing of statistics records.
    statistics clockstats cryptostats loopstats peerstats sysstats rawstats

" > $ntp_conf

ntpdate 192.168.110.1 

echo "Restart ntpd deamon." 
if [ $index -ne 0 ]; then
    systemctl restart ntpd
else
    service ntpd restart
fi
