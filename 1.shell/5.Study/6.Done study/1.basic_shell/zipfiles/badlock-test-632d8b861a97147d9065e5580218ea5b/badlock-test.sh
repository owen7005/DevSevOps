

#!/bin/bash
# Version: 1.1
#Samba 3.6.0－4.4.0版本在MS-SAMR及MS-LSAD协议未正确处理DCERPC连接，
#可使中间人攻击者修改客户端到服务器的数据流，执行协议降级攻击并冒充用户，
#对Security Account Manager database读写操作，获取敏感信息等
#Samba MS-SAMRMS-LSAD中间人攻击漏洞(CVE-2016-2118)
#


YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

VULNERABLE_VERSIONS=(
    # RHEL5 (samba)
    '3.0.23c-2'
    '3.0.23c-2.el5.2'
    '3.0.23c-2.el5.2.0.2'
    '3.0.25b-0.el5.4'
    '3.0.25b-1.el5_1.2'
    '3.0.25b-1.el5_1.4'
    '3.0.28-0.el5.8'
    '3.0.28-1.el5_2.1'
    '3.0.33-3.7.el5'
    '3.0.28-1.el5_2.3'
    '3.0.33-3.7.el5_3.1'
    '3.0.33-3.14.el5'
    '3.0.33-3.15.el5_4'
    '3.0.33-3.15.el5_4.1'
    '3.0.33-3.28.el5'
    '3.0.33-3.7.el5_3.2'
    '3.0.33-3.15.el5_4.2'
    '3.0.33-3.29.el5_5'
    '3.0.33-3.29.el5_5.1'
    '3.0.33-3.7.el5_3.3'
    '3.0.33-3.15.el5_4.3'
    '3.0.33-3.29.el5_6.2'
    '3.0.33-3.29.el5_7.4'
    '3.0.33-3.37.el5'
    '3.0.33-3.38.el5_8'
    '3.0.33-3.7.el5_3.4'
    '3.0.33-3.29.el5_6.4'
    '3.0.33-3.39.el5_8'
    '3.0.33-3.7.el5_3.5'
    '3.0.33-3.29.el5_6.5'
    '3.0.33-3.40.el5_10'

    # RHEL6 (samba)
    '3.5.4-68.el6'
    '3.5.4-68.el6_0.1'
    '3.5.4-68.el6_0.2'
    '3.5.6-86.el6'
    '3.5.6-86.el6_1.4'
    '3.5.10-114.el6'
    '3.5.4-68.el6_0.3'
    '3.5.10-115.el6_2'
    '3.5.6-86.el6_1.5'
    '3.5.10-116.el6_2'
    '3.5.10-125.el6'
    '3.6.9-151.el6'
    '3.6.9-151.el6_4.1'
    '3.6.9-160.3.el6rhs'
    '3.6.9-164.el6'
    '3.6.9-160.7.el6rhs'
    '3.6.9-167.el6_5'
    '3.6.9-167.5.1.el6rhs'
    '3.6.9-167.10.el6rhs'
    '3.6.9-168.el6_5'
    '3.6.23-12.el6'
    '3.6.9-169.el6_5'
    '3.6.9-169.1.el6rhs'
    '3.6.509-169.1.el6rhs'
    '3.6.509-169.4.el6rhs'
    '3.6.9-167.10.1.el6rhs'
    '3.6.23-14.el6_6'
    '3.6.9-151.el6_4.3'
    '3.6.9-171.el6_5'
    '3.5.10-119.el6_2'
    '3.6.509-169.6.el6rhs'
    '3.6.9-167.10.3.el6rhs'
    '4.1.17-4.el6rhs'
    '3.6.23-20.el6'
    '4.1.17-13.el6rhs'
    '4.1.17-14.el6rhs'
    '3.6.23-21.el6_7'
    '3.6.23-24.el6_7'
    '4.1.17-16.el6rhs'
    '4.2.4-13.el6rhs'
    '4.2.4-15.el6rhs'
    '3.6.23-25.el6_7'
    '3.6.23-9.el6'

    # RHEL7 (samba)
    '4.1.1-31.el7'
    '4.1.1-33.el7_0'
    '4.1.1-35.el7_0'
    '4.1.1-37.el7_0'
    '4.1.1-38.el7_0'
    '4.1.12-21.el7_1'
    '4.1.12-23.el7_1'
    '4.1.17-13.el7rhgs'
    '4.1.17-14.el7rhgs'
    '4.1.12-24.el7_1'
    '4.2.4-6.el7rhgs'
    '4.2.3-10.el7'
    '4.2.3-11.el7_2'
    '4.2.4-9.1.el7rhgs'
    '4.2.4-13.el7rhgs'
    '4.2.4-15.el7rhgs'
    '4.2.3-12.el7_2'
    '4.1.12-21.ael7b'
    '4.1.12-23.ael7b_1'
    '4.1.12-24.ael7b_1'

    # RHEL5 (samba3x)
    '3.3.5-0.40.el5'
    '3.3.8-0.46.el5'
    '3.3.8-0.51.el5'
    '3.3.8-0.52.el5_5'
    '3.3.8-0.52.el5_5.2'
    '3.5.4-0.70.el5'
    '3.5.4-0.70.el5_6.1'
    '3.5.4-0.83.el5'
    '3.5.4-0.83.el5_7.2'
    '3.5.10-0.107.el5'
    '3.5.4-0.70.el5_6.2'
    '3.5.10-0.108.el5_8'
    '3.5.10-0.109.el5_8'
    '3.5.10-0.110.el5_8'
    '3.6.6-0.129.el5'
    '3.6.6-0.136.el5'
    '3.6.6-0.138.el5_10'
    '3.6.6-0.139.el5_10'
    '3.6.6-0.140.el5_10'
    '3.6.23-7.el5'
    '3.6.23-6.el5'
    '3.6.23-9.el5_11'
    '3.5.4-0.70.el5_6.4'
    '3.6.6-0.131.el5_9'

    # RHEL6 (samba4)
    '4.0.0-55.el6.rc4'
    '4.0.0-58.el6.rc4'
    '4.0.0-60.el6_5.rc4'
    '4.0.0-61.el6_5.rc4'
    '4.0.0-64.el6.rc4'
    '4.0.0-63.el6_5.rc4'
    '4.0.0-63.el6.rc4'
    '4.0.0-66.el6_6.rc4'
    '4.0.0-57.el6_4.rc4'
    '4.0.0-65.el6_5.rc4'
    '4.0.0-67.el6_7.rc4'
    '4.0.0-68.el6_7.rc4'
)


# look for last item in the set of previous items
function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            return 0
        fi
    }
    return 1
}


chkconfig smb &> /dev/null # returns 1 if not installed or not enabled, 0 if enabled
service_enabled=$?
ps auxcww | grep smbd &> /dev/null # returns 1 if not found, 0 else
service_running=$?
result=0

# get versions of installed samba and check them against the list of known vulnerable versions
if [ $service_enabled -eq 0 ] || [ $service_running -eq 0 ]; then
    server_packages=(samba samba3x samba4)
    for package_name in ${server_packages[@]}; do
        for package in `rpm -qa --qf '%{version}-%{release}\n' $package_name | sort` ; do
            if $(contains "${VULNERABLE_VERSIONS[@]}" "$package"); then
                echo -e $RED"WARNING"$RESET": The installed version of ${package_name} server ($package) is vulnerable to BADLOCK and should be upgraded! It is also enabled and/or running. Please update the package and restart the service."
                result=2
            fi
        done
    done
fi


# get versions of installed samba clients and check them against the list of known vulnerable versions
if [ $result -eq 0 ]; then
    client_packages=(libsmbclient samba-client samba-client-libs samba3x-client samba4-client samba4-libs samba samba3x samba4)
    for package_name in ${client_packages[@]}; do
        for package in `rpm -qa --qf '%{version}-%{release}\n' $package_name | sort` ; do
            if $(contains "${VULNERABLE_VERSIONS[@]}" "$package"); then
                echo -e $YELLOW"WARNING"$RESET": The installed version of ${package_name} ($package) is vulnerable to BADLOCK and should be upgraded!"
                result=1
            fi
        done
    done
fi

if [ $result -ne 0 ]; then
    echo "See https://access.redhat.com/articles/2243351 and https://access.redhat.com/security/vulnerabilities/badlock for more information."
else
    echo "No vulnerability to BADLOCk detected."
fi

# return an exit code usable for automated testing
exit $result
