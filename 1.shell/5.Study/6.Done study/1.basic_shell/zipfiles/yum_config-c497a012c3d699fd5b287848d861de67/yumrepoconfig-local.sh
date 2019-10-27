#/bin/bash
#yum±¾µØÅäÖÃ
#isoÂ·¾¶£º/data/rhel-server-7.2-x86_64-dvd.iso
#
#
#


currentTimestamp=`date +%y-%m-%d-%H:%M:%S`
yumRepo=/etc/yum.repos.d/localrepo_RHEL7-7.2-iso.repo
yumRepoBackup=${yumRepo}.${currentTimestamp}
repoFolder="/mnt/RHEL7/u2/iso"
mkdir -p $repoFolder

mount -o loop /data/rhel-server-7.2-x86_64-dvd.iso $repoFolder


if [ -f "$yumRepo" ]; then
    echo "Backup $yumRepo to $yumRepoBackup"
    cp $yumRepo $yumRepoBackup
fi

cat > $yumRepo << EOF
[local-repo-in-iso-by-yum-repo-config-helper]
name=Red Hat Enterprise Linux \$releasever - \$basearch (DVD)
baseurl=file://$repoFolder/
enabled=1
gpgcheck=1 
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF

chmod a+x $yumRepo
yum clean all