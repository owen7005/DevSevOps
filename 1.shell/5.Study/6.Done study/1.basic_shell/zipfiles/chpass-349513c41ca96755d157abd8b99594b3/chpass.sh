#!/bin/bash
char=(')' '!' '@' '#' '$' '%' '^' '&' '*' '(')
#ip_addr=`ifconfig | grep 'inet addr:' | awk -F'[ :]+' '{print $4}' | head -n1`
ip_addr="192.168.110.254"
last_part=`awk -F'.' '{print $4}' <<< ${ip_addr}`
first_num=`awk 'BEGIN{FS=""} {print $1}' <<< ${last_part}`
second_num=`awk 'BEGIN{FS=""} {print $2}' <<< ${last_part}`
third_num=`awk 'BEGIN{FS=""} {print $3}' <<< ${last_part}`

i=1
for num in ${first_num} ${second_num} ${third_num}; do
    if [ ! -z ${num} ]; then
        eval char${i}="${char[${num}]}"
    fi
    let i++
done

password="123${char1}${char2}${char3}"

echo "${password}"
