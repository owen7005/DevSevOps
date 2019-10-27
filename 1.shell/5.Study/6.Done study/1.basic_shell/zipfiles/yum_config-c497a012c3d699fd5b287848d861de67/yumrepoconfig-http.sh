#/bin/bash
#通过http发布的yum配置
#iso路径：/data/rhel-server-7.2-x86_64-dvd.iso
#yum服务器ip：192.168.110.10
#http路径：/var/www/html/yum/rhel7

if ! rpm -q httpd > /dev/null
then 
    echo "httpd service not found. You need to install and configure it before running this script."
    exit 1
fi
if [ ! -d "/var/www/html/yum/rhel7" ]; then
    echo "The httpd document root /var/www/html/yum/rhel7 does not exist.  Reconfigure your httpd service and try again."
    exit 1
fi



repoFolder="/mnt/RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64"
mkdir -p $repoFolder
mkdir -p /var/www/html/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/
mount -o loop /data/rhel-server-7.2-x86_64-dvd.iso $repoFolder
shopt -s dotglob
echo "Copying files from $repoFolder/ to /var/www/html/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/"
cp -R $repoFolder/* /var/www/html/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/
chmod a+rx -R /var/www/html/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/
umount $repoFolder
 


if ! service httpd status > /dev/null
then 
    service httpd start
fi

chcon -R -t httpd_sys_content_t /var/www/html/yum/rhel7RHEL7/u2/RedHatEnterpriseLinuxServer/x86_64/
 


