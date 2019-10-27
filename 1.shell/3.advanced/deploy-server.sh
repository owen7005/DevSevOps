#!/bin/bash
# @Author:panwang
# @Email:mikuismywifu@gmail.com
# @Date:2017-08-017
# @description:生产环境部署安装(nodejs、redis、memcacheq、memcached、jdk、maven、subversion)
# @version:1.0
# @see:脚本适用于centos系列


#开始记录脚本启动时间
beginTime=$(date +%s)

#安装包位置
installCatalog=/root/install-tmp
echo_s="\033[33m"
echo_e="\033[0m"

echo -e "\033[33m ####################################检测必要的安装包#################################### \033[0m"

#判断软件包目录是否存在
if [ ! -d "$installCatalog" ]; then
    echo -e "$echo_s 请将软件包放至$installCatalog目录 $echo_e";
    exit
fi

#判断是否存在jdk安装包
jdk_rpm=$(ls "$installCatalog" | grep jdk | grep rpm)
jdk_gz=$(ls "$installCatalog" | grep jdk | grep gz)
if [ ! "$jdk_rpm" -a ! "$jdk_gz" ]; then
    echo -e "$echo_s jdk安装包不存在 $echo_e";
fi

#判断是否存在redis安装包
redis_gz=$(ls "$installCatalog" | grep redis)
if [ ! "$redis_gz" ]; then
    echo -e "$echo_s redis安装包不存在 $echo_e";
fi

#判断是否存在maven安装包
maven_gz=$(ls "$installCatalog" | grep maven)
if [ ! "$maven_gz" ]; then
    echo -e "$echo_s maven安装包不存在 $echo_e";
fi

#判断是否存在libevent安装包
libevent_gz=$(ls "$installCatalog" | grep libevent)
if [ ! "$libevent_gz" ]; then
    echo -e "$echo_s memcache依赖包libevent安装包不存在 $echo_e";
fi

#判断是否存在BerkeleyDB安装包
berkeleyDB_gz=$(ls "$installCatalog" | grep db-)
if [ ! "$berkeleyDB_gz" ]; then
    echo -e "$echo_s memcache依赖包BerkeleyDB安装包不存在 $echo_e";
fi

#判断是否存在memcached安装包
memcached_gz=$(ls "$installCatalog" | grep memcached)
if [ ! "$memcached_gz" ]; then
    echo -e "$echo_s memcached安装包不存在 $echo_e";
fi

#判断是否存在memcacheq安装包
memcacheq_gz=$(ls "$installCatalog" | grep memcacheq)
if [ ! "$memcached_gz" ]; then
    echo -e "$echo_s memcacheq安装包不存在 $echo_e";
    exit
fi

echo -e "\033[33m ####################################开始安装软件######################################## \033[0m"

echo "start install nodejs"
#安装gcc编译
yum -y install gcc gcc-c++
#安装node.js官方库
yum -y install epel-release
yum -y install nodejs
yum -y install npm
echo "start install pm2"
npm install -g pm2

#安装jdk
echo "start install jdk 暂时请使用rpm jdk安装包。。。。。。。。"
rpm -ivh "$installCatalog"/jdk*
jdk_version=$(ls /usr/java/ | grep jdk*)
echo 'JAVA_HOME=/usr/java/'$jdkversion
echo 'CLASSPATH=.:$JAVA_HOME/lib/tools.jar' 
echo 'PATH=$JAVA_HOME/bin:$PATH' 
echo 'export JAVA_HOME CLASSPATH PATH'

#redis安装
echo "start install redis"
tar -zxvf $installCatalog/$redis_gz  -C /usr/local
cd /usr/local/${redis_gz%.tar*}
make && make install

#memcached安装
echo "start install memcached"
yum -y install libevent-devel 

tar -zxvf $installCatalog/$libevent_gz -C /usr/local
cd /usr/local/${libevent_gz%.tar*}
./configure && make && make install

tar -zxvf $installCatalog/$berkeleyDB_gz -C /usr/local
cd /usr/local/${berkeleyDB_gz%.tar*}/build_unix
../dist/configure --prefix=/usr/local/BerkeleyDB
make && make install

echo '/usr/local/lib' >> /etc/ld.so.conf 2>&1
echo '/usr/local/BerkeleyDB/lib' >> /etc/ld.so.conf 2>&1
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/BerkeleyDB/lib' >> /etc/profile 2>&1

tar -zxvf $installCatalog/$memcached_gz -C /usr/local
cd /usr/local/${memcached_gz%.tar*}
./configure --prefix=/usr/local/memcached --with-libevent=/usr/local/${libevent_gz%.tar*}
make && make install

#memcacheq安装
echo "start install memcacheq"
tar -zxvf $installCatalog/$memcacheq_gz  -C /usr/local
cd /usr/local/${memcacheq_gz%.tar*}
./configure --prefix=/usr/local/memcacheq --enable-threads --with-libevent=/usr/local/${libevent_gz%.tar*}
make && make install

#maven安装
echo "start install maven"
tar -zxvf $installCatalog/$maven_gz  -C /usr/local
sed -i '55i<localRepository>/mnt/repository</localRepository>' /usr/local/${maven_gz%.tar*}/settings.xml
echo 'export M2_HOME=/usr/local/'${maven_gz%.tar*} >> /etc/profile 2>&1
echo 'export PATH=$PATH:$M2_HOME/bin' >> /etc/profile 2>&1

#指定maven仓库
mkdir -p /mnt/repository

ldconfig
source /etc/profile


