#!/bin/bash
#适用系统版本rhel7
#User Friendly Mode: WWID="3600508b400105e210000900000490000";Alias="alias1"
#Multipath Attributes:Polling Interval="5";No_Retry="0";Failback="Manual";Total Multipath Timeout="5"
#Boot from SAN:"yes"
#




# Make sure multipath is installed...
yum -y install device-mapper-multipath

# Save any existing configuration file...
cp /etc/multipath.conf /etc/multipath_original.conf

mpathconf --enable --with_multipathd y --with_module y

# Create the new configuration file...
cat << EOF >/etc/multipath.conf


defaults {
    find_multipaths no
    user_friendly_names yes
    polling_interval 5
    no_path_retry 0
    failback manual
}

multipaths {
    multipath {
        wwid    3600508b400105e210000900000490000
        alias    alias1
    }
}

#blacklist {
#	wwid	26353900f02796769
#	devnode	dm-2
#	device {
#		vendor	IBM
#		product	3S42
#	}
#}
EOF

# Enable and start multipath service...
systemctl enable multipathd
systemctl start multipathd
dracut -f /boot/initramfs-$(uname -r).img $(uname -r)