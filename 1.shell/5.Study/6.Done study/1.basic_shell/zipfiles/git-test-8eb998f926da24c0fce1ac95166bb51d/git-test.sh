#!/bin/bash
# Version: 1.0
#git的整数切取与溢出漏洞检测（CVE-2016-2315）
#
#
YELLOW='\033[1;33m'
RESET='\033[0m'

VULNERABLE_GIT_VERSIONS=(
    # RHEL6
    'git-1.7.1-3.el6_4.1',
    'git-1.7.1-2.el6',
    'git-1.7.1-2.el6_0.1',
    'git-daemon-1.7.1-3.el6_4.1',
    'git-daemon-1.7.1-2.el6',
    'git-daemon-1.7.1-2.el6_0.1',

    # SCL 6
    'git19-git-1.9.4-2.el6',
    'git19-git-1.9.4-3.el6',
    'git19-git-1.9.4-3.el6.1',
    'git19-git-daemon-1.9.4-2.el6',
    'git19-git-daemon-1.9.4-3.el6',
    'git19-git-daemon-1.9.4-3.el6.1',

    # RHEL7
    'git-1.8.3.1-6.el7',
    'git-1.8.3.1-5.el7',
    'git-1.8.3.1-4.el7',
    'git-1.8.3.1-3.el7',
    'git-1.8.3.1-2.el7',
    'git-daemon-1.8.3.1-6.el7',
    'git-daemon-1.8.3.1-5.el7',
    'git-daemon-1.8.3.1-4.el7',
    'git-daemon-1.8.3.1-3.el7',
    'git-daemon-1.8.3.1-2.el7',

    # SCL 7
    'git19-git-1.9.4-2.el7',
    'git19-git-1.9.4-3.el7',
    'git19-git-1.9.4-3.el7.1',
    'git19-git-daemon-1.9.4-2.el7',
    'git19-git-daemon-1.9.4-3.el7',
    'git19-git-daemon-1.9.4-3.el7.1',
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


echo

result=0
# get version of installed git and test installed versions
rpm -q --qf '%{name}-%{version}-%{release}\n' git | while read -r package; do

    # check for vulnerability
    if $(contains "${VULNERABLE_GIT_VERSIONS[@]}" "$package") ; then
        echo -e $YELLOW"WARNING"$RESET": The installed version of git ($package) is vulnerable to CVE-2016-2315 and CVE-2016-2324 and should be upgraded."
        echo "See https://access.redhat.com/articles/2201201 for more information."
        result=1
    # version is good...
    else
        echo "The installed version of git ($package) is not vulnerable to CVE-2016-2315 and CVE-2016-2324."
    fi

done

# return an exit code usable for automated testing
exit $result
