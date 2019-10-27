#/bin/bash
#通过ftp发布的yum服务器配置
#iso路径：/data/rhel-server-7.2-x86_64-dvd.iso
#yum服务器ip：192.168.110.10
#FTP路径：/var/ftp/yum/rhel7
#



if ! rpm -q vsftpd > /dev/null
then 
    echo "vsftpd service not found. You need to install and configure it before running this script."
    exit 1
fi
if [ ! -d "/var/ftp/yum/rhel7" ]; then
    echo "The directory /var/ftp/yum/rhel7 does not exist.  Reconfigure your vsftpd service and try again."
    exit 1
fi



repoFolder="/mnt/RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64"
mkdir -p $repoFolder
mkdir -p /var/ftp/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/
mount -o loop /data/rhel-server-7.2-x86_64-dvd.iso $repoFolder
shopt -s dotglob
echo "Copying files from $repoFolder/ to /var/ftp/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/"
cp -R $repoFolder/* /var/ftp/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/
chmod a+rx -R /var/ftp/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/
umount $repoFolder
 


if ! service vsftpd status > /dev/null
then 
    service vsftpd start
fi

chcon -R -t public_content_t /var/ftp/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/
 


