#!/usr/bin/env bash
#===============================================================================
#
#          FILE: find_disk_usage.sh
# 
#         USAGE: ./find_disk_usage.sh <directory> [top N]
# 
#   DESCRIPTION: 根据指定目录，查找出目录下占用空间最大的top N目录和文件，如果没有指定top N，默认为top 10
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#  ORGANIZATION: BlueKing
#       CREATED: 03/06/2017 14:22
#      REVISION:  ---
#===============================================================================

ok () {
    echo "$(date +%F\ %T)|$$|$BASH_LINENO|info|job success: $*" 
    exit 0
}

die () {
    echo "$(date +%F\ %T)|$$|$BASH_LINENO|error|job fail: $*" >&2
    exit 1
}

usage() { 
    cat <<_OO_

USAGE:
    $0 <directory> [top N]

_OO_
    exit 1
}

#判断参数
specified_directory="$1"
top_n="$2"

#判断指定目录合法性
if [[ -z "$specified_directory" ]] || [[ ! -d $specified_directory ]];then
	usage
fi

#如果没有指定或指定的top N不合法则设置为默认值10
if ! $( echo "$top_n"|grep -q -P "^[0-9]+$" );then
	top_n=10
fi



#判断服务器负载
is_load_limit=1 #0代表关闭负载开关，1代表打开负载开关，当打开负载开关时，如果服务器高于2/每核，则禁止脚本运行

if [[ $is_load_limit -eq 1 ]];then
    #获取服务器负载
    cu_load=$( awk '{print $1}' /proc/loadavg )
    [[ -z "$cu_load" ]] && die "get loadavg fail"
    
    #获取CPU核数
    cpu_core_count=$( grep 'processor' /proc/cpuinfo|wc -l )
    [[ $cpu_core_count -eq 0 ]] && "get cpu core count fail"
    
    #计算可以支持的最大负载
    core_count_limit=$((cpu_core_count*2))
    [[ $( expr $cu_load \> $core_count_limit ) -ne 0 ]] &&  die "Current server load $cu_load , limited is $core_count_limit, to stop working"
fi
 


#创建临时文件
temp_file=$( mktemp )

#开始统计文件大小
top_count=1
echo "File or directory disk usage top $top_n:"
while read usage_m file_path
do
	[[ -f $file_path ]] && file_type="File"||file_type="Directory"
	echo "Top.${top_count}	${usage_m}(MB)	${file_type}	$file_path"
	top_count=$((top_count+1))
done <<< "$( du -am ${specified_directory}/* 2>$temp_file|sort -nr|head -${top_n} )"

#打印没有权限日志
if [[ -s $temp_file ]];then
	cu_user=$( id|awk '{print $1}' )
	echo
	echo "Current user $cu_user does not have permissions for the following directory or file:"
	cat $temp_file
fi

#删除临时文件
[[ -f $temp_file ]] && rm -f $temp_file
