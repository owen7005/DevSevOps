#!/bin/bash
# Version: 1.0

YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

VULNERABLE_VERSIONS=(

    # RHEL5
    'ImageMagick-6.2.8.0-4.el5_1.1'   
    'ImageMagick-6.2.8.0-4.el5_5.2'   
    'ImageMagick-6.2.8.0-4.el5_5.3'   
    'ImageMagick-6.2.8.0-3.el5.4'     
    'ImageMagick-6.2.8.0-12.el5'      
    'ImageMagick-6.2.8.0-15.el5_8'    

    # RHEL6
    'ImageMagick-6.5.4.7-5.el6'       
    'ImageMagick-6.5.4.7-6.el6_2'     
    'ImageMagick-6.5.4.7-7.el6_5'     
    'ImageMagick-6.7.2.7-2.el6'       

    # RHEL7
    'ImageMagick-6.7.8.9-10.aa7a'     
    'ImageMagick-6.7.8.9-10.ael7b'    
    'ImageMagick-6.7.8.9-10.el7'      
    'ImageMagick-6.7.8.9-12.el7_2'    

)


# look for last item in the set of previous items
function contains() {
    # number of arguments
    local n=$#
    # the last positional argument (using indirect reference)
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        # comparing the i-th positional argument with the last one
        if [ "${!i}" == "${value}" ]; then
            return 0
        fi
    }
    return 1
}


result=0

# Get versions of installed ImageMagick and check them against the list of known vulnerable versions
for package in `rpm -qa --qf '%{name}-%{version}-%{release}\n' ImageMagick | sort` ; do
    if $(contains "${VULNERABLE_VERSIONS[@]}" "$package"); then
        result=1
    fi
done


# Check for mitigation in place
in_policymap=0
check_ephemeral=0
check_https=0
check_http=0
check_url=0
check_ftp=0
check_mvg=0
check_msl=0
check_text=0
check_label=0
check_at=0

# Recommended mitigation:
#  <policymap>
#    <policy domain="coder" rights="none" pattern="EPHEMERAL" />
#    <policy domain="coder" rights="none" pattern="HTTPS" />
#    <policy domain="coder" rights="none" pattern="HTTP" />
#    <policy domain="coder" rights="none" pattern="URL" />
#    <policy domain="coder" rights="none" pattern="FTP" />
#    <policy domain="coder" rights="none" pattern="MVG" />
#    <policy domain="coder" rights="none" pattern="MSL" />
#    <policy domain="coder" rights="none" pattern="TEXT" />
#    <policy domain="coder" rights="none" pattern="LABEL" />
#    <policy domain="path" rights="none" pattern="@*" />
#  </policymap>

if [ $result -eq 1 ]; then
    while read line; do
        if [[ $line =~ .*\<policymap\>.* ]]; then
            in_policymap=1
        elif [[ $line =~ .*\</policymap\>.* ]]; then
            in_policymap=0
        else
            if [ $in_policymap -eq 1 ]; then
                # best-effort matching for the recommended mitigation lines; full XML parsing is not done
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']coder[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']EPHEMERAL[\"\'][[:space:]]*/\> ]]; then
                    check_ephemeral=1
                fi
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']coder[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']HTTPS[\"\'][[:space:]]*/\> ]]; then
                    check_https=1
                fi
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']coder[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']HTTP[\"\'][[:space:]]*/\> ]]; then
                    check_http=1
                fi
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']coder[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']URL[\"\'][[:space:]]*/\> ]]; then
                    check_url=1
                fi
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']coder[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']FTP[\"\'][[:space:]]*/\> ]]; then
                    check_ftp=1
                fi
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']coder[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']MVG[\"\'][[:space:]]*/\> ]]; then
                    check_mvg=1
                fi
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']coder[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']MSL[\"\'][[:space:]]*/\> ]]; then
                    check_msl=1
                fi
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']coder[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']TEXT[\"\'][[:space:]]*/\> ]]; then
                    check_text=1
                fi
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']coder[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']LABEL[\"\'][[:space:]]*/\> ]]; then
                    check_label=1
                fi
                if [[ $line =~ ^[[:space:]]*\<policy[[:space:]]+domain=[\"\']path[\"\'][[:space:]]+rights=[\"\']none[\"\'][[:space:]]+pattern=[\"\']@\*[\"\'][[:space:]]*/\> ]]; then
                    check_at=1
                fi
            fi
        fi
    done < /etc/ImageMagick/policy.xml
fi

if [ $result -eq 1 ]; then
    if [ ${check_ephemeral} -eq 1 ] && [ ${check_https} -eq 1 ] && [ ${check_http} -eq 1 ] && [ ${check_url} -eq 1 ] && [ ${check_ftp} -eq 1 ] && [ ${check_mvg} -eq 1 ] && [ ${check_msl} -eq 1 ] && [ ${check_text} -eq 1 ] && [ ${check_label} -eq 1 ] && [ ${check_at} -eq 1 ] ; then
        result=2
    fi
fi

# Result 0 - no vulnerable package found
# Result 1 - vulnerable package found and no mitigation
# Result 2 - vulnerable package found but mitigation

if [ $result -eq 1 ]; then
    echo -e $RED"WARNING"$RESET": The installed version of ImageMagick ($package) is vulnerable to ImageMagick Filtering Vulnerability - CVE-2016-3714."
    echo "Apply the mitigation described at https://access.redhat.com/security/vulnerabilities/2296071"
elif [ $result -eq 2 ]; then
    echo -e $YELLOW"WARNING"$RESET": The installed version of ImageMagick ($package) is vulnerable to ImageMagick Filtering Vulnerability - CVE-2016-3714."
    echo "The machine is NOT vulnerable, as the recommended mitigation is in place."
else
    echo "No vulnerability to CVE-2016-3714 (ImageMagick) detected."
fi
echo "See https://access.redhat.com/security/vulnerabilities/2296071 for more information."

# Return an exit code usable for automated testing
exit $result
