#!/usr/bin/env bash
#===============================================================================
#消耗系统资源最多的Top10
#          FILE: get_top_proc.sh
# 
#         USAGE: ./get_top_proc.sh 
# 
#   DESCRIPTION: 输出系统当前占用资源（cpu、内存、IO、流量等等）最多的Top10进程
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#  ORGANIZATION: BlueKing
#       CREATED: 02/15/2017 14:40
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

common_fields="pcpu,pmem,rss,pid,user,args"
IFS="," read -r -a common <<< "$common_fields"

usage() {
    cat <<EOF
    get_top_proc.sh <cpu|mem> <additional output fields>
    by default, output $common_fields fields
EOF
    exit 1
}

contains_string() {
    local e 
    for e in "${@:2}"; do
	[[ "$e" == "$1" ]] && return 0
    done
    return 1
}

join() {
    local IFS="$1"
    shift; echo "$*"
}

if (( $# < 1 )) || (( $# > 2 )) ; then
    usage
fi

case $1 in 
    cpu) sort_field=pcpu ;;
    mem) sort_field=rss ;;
    *) usage ;;
esac

if [[ $# -eq 1 ]]; then
    fields="$common_fields"
else
    IFS="," read -r -a extra <<< "$2"
    for f in "${extra[@]}";do
	contains_string "$f" "${common[@]}" || extra_fields+=("$f")
    done
    fields="$common_fields,$(join , "${extra_fields[@]}")"
fi

ps -eo "$fields" --sort=-"$sort_field" | head -10
