#!/bin/bash 

local_ip=`ifconfig | grep 'inet addr:' | awk -F'[ :]+' '{print $4}' | head -n1`
ftp_ip="192.168.110.22"
ftp_user="cyun"
ftp_pw="a"
remote_dir="msg_storage/${local_ip}"
local_dir="/var/log/"
cd ${local_dir}

mesg_file1=`find -name "messages-*" |sed -n 1p`
mesg_file2=`find -name "messages-*" |sed -n 2p`
mesg_file3=`find -name "messages-*" |sed -n 3p`
mesg_file4=`find -name "messages-*" |sed -n 4p`
tar czf ${mesg_file1}.tar.gz ${mesg_file1}
tar czf ${mesg_file2}.tar.gz ${mesg_file2}
tar czf ${mesg_file3}.tar.gz ${mesg_file3}
tar czf ${mesg_file4}.tar.gz ${mesg_file4}
tar_file1=${mesg_file1}.tar.gz
tar_file2=${mesg_file2}.tar.gz
tar_file3=${mesg_file3}.tar.gz
tar_file4=${mesg_file4}.tar.gz

ftp -i -n <<EOF
open ${ftp_ip}
user ${ftp_user} ${ftp_pw}
bin
cd ${remote_dir} 
mput ${tar_file1} ${tar_file2} ${tar_file3} ${tar_file4} 
quit
EOF

rm -f ${tar_file1} 
rm -f ${tar_file2} 
rm -f ${tar_file3} 
rm -f ${tar_file4} 


