#!/bin/bash
export PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin
# JVM分析
if [[ $# -ne 1 || ! $1 =~ ^[0-9]+$ ]]; then
    echo "Usage: $0 pid"
    exit
fi
SYS_JAVA_PID=$(ps -ef |grep -Ei '(java|jar|tomcat)' |awk '{print $2}')
for id in $SYS_JAVA_PID; do
    if [ $id -eq $1 ]; then
        FLAG=1
    fi 
done    
if [ -z "$FLAG" ]; then
    echo "Java pid not found!"
    exit
fi
for tools in "jstack jmap jstat"; do
    if ! $(which $tools >/dev/null 2>&1); then
        if [ -n "$JAVA_HOME" ]; then
            export PATH=$PATH:$JAVA_HOME/bin
        else
            echo "$tools command not found!"
            exit 
        fi
    fi
done
# 查看CPU占用top5的Java线程跟踪堆栈信息
echo "Java thread CPU TOP"
echo "------------------>"
# echo "Java thread CPU: $(ps -mp 31075 -o THREAD,tid,time |awk 'NR==2{print $2}"%"')"
JAVA_THREAD_ID_CPU_TOP=$(ps -mp $1 -o THREAD,tid,time |awk 'NR>2{print $0}' |sort -k2 -r |awk 'NR<=5{print $8":"$2"%"}')
count=1
for thread in $JAVA_THREAD_ID_CPU_TOP; do
    thread_id=$(echo $thread |cut -d: -f1)
    cpu_percent=$(echo $thread |cut -d: -f2)
    hex=$(printf "%x" $thread_id)
    echo "Top $count -> CPU $cpu_percent"
    echo "-------------------------------------"
    jstack $1 |grep -A10 $hex
    let count+=1
done
echo "#####################################################"
echo "Java thread memory TOP"
echo "--------------------->"
# 分析内存占用top5的Java线程
jmap -histo $1 |grep -Ev '(java.*|javax.*|sun.*|sunw.*|com\.sun.*|\[C$|\[S$|\[I$|\[B$|\[Z$|\[J$)' |awk 'NR>=2&&NR<=8{print $0}'
# 分析堆内存、年轻代、老年代容量和使用量
echo "#####################################################"
echo "JVM Memory details"
echo "----------------->"
jstat -gc $1 > /tmp/jstat.log
S=$(cat /tmp/jstat.log |awk 'NR==2{printf "%.0f",($1+$2)/1024}')   # survivor   四舍五入
EC=$(cat /tmp/jstat.log |awk 'NR==2{printf "%.0f",$5/1024}')        # eden
EU=$(cat /tmp/jstat.log |awk 'NR==2{printf "%.0f",$6/1024}')        # eden util
OC=$(cat /tmp/jstat.log |awk 'NR==2{printf "%.0f",$7/1024}')        # old
OU=$(cat /tmp/jstat.log |awk 'NR==2{printf "%.0f",$8/1024}')        # old util
HEAP_MEM=$(($S+$E+$OC))
HEAP_UTIL=$(cat /tmp/jstat.log |awk 'NR==2{printf "%.1f",($2+$3+$6+$8)/1024}')
PERM_MEM=$(cat /tmp/jstat.log |awk 'NR==2{printf "%.1f",$9/1024}')
PERM_UTIL=$(cat /tmp/jstat.log |awk 'NR==2{printf "%.1f",$10/1024}')
HEAP_MAX=$(jinfo -flag MaxHeapSize $1 |awk -F= '{print $2/1024/1024}')
echo "Heap max space capacity: ${HEAP_MAX}M"
echo "Heap current space capacity: ${HEAP_MEM}M"
echo "Heap current space capacity util: ${HEAP_UTIL}M"
echo "Young Generation Suvivor space capacity: ${S}M"
echo "Young Generation Eden space capacity: ${EC}M"
echo "Young Generation Eden space capacity util: ${EU}M"
echo "Old Generation space capacity: ${OC}M"
echo "Old Generation space capacity util: ${OU}M"
echo "Permanent Generation: ${PERM_MEM}M"
echo "Permanent Generation space capacity util: ${PERM_UTIL}M"
# 类数量
echo "#####################################################"
echo "Class number"
echo "----------->"
jstat -class $1 > /tmp/jstat.log 
CLASS_LOADED=$(cat /tmp/jstat.log |awk 'NR==2{print $1}')
CLASS_UNLOADED=$(cat /tmp/jstat.log |awk 'NR==2{print $3}')
echo "Class loaded number: $CLASS_LOADED"
echo "Class unloaded number: $CLASS_UNLOADED"
# 线程数量
echo "#####################################################"
echo "Thread number"
echo "------------>"
THREAD_NUM=$(ps -mp $1 -o tid |wc -l)
echo "Thread number: $THREAD_NUM"
