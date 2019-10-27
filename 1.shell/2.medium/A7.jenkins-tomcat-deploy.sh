#!/bin/bash
# Decription: Tomcat部署脚本
JAVA_HOME=/usr/local/jdk1.8
PATH=$JAVA_HOME/bin:$PATH
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
MAVEN_HOME=/usr/local/apache-maven-3.3.9
PATH=$PATH:$MAVEN_HOME/bin
export JAVA_HOME CLASSPATH MAVEN_HOME PATH

WORK_DIR=/data/project
TOMCAT_NAME=tomcat-pc-8080    # 需要修改
TOMCAT_ROOT=$WORK_DIR/$TOMCAT_NAME/webapps/ROOT   
SVN_DIR=/data/svn_src/master  # svn co的地址，需要修改
WAR_PKG=$SVN_DIR/target/*.war   # 需要修改
ENV=test   # 需要修改( dev or test)
WEB_SITE=http://${ENV}.xxx.com:8080  # 需要修改

echo "更新svn文件开始..."
cd $SVN_DIR && svn update
if [ $? -eq 0 ]; then
    echo "更新svn文件完成."
    # 不kill启动的进程
    echo "开始构建项目包..."
    export BUILD_ID=dontKillMe 
    mvn clean -P$ENV package -Dmaven.test.skip=true  # 如果构建失败尝试加这个参数-Dmaven.test.skip=true，跳过测试用例
    # clean 清除构建时产生的临时文件，一般在target目录下。
    # -P 使用pom.xml中指定的配置。
    # package 根据pom.xml描述的配置创建JAR/WAR包。
else
    echo "SVN更新失败！！！"
    exit 1
fi

if ! which unzip >/dev/null 2>&1; then
    yum install unzip -y
fi

pid() {
    ps -ef |grep "$TOMCAT_NAME" |egrep -v "(grep|$$)" |awk '{print $2}'
}
stop() {
    if [ -n "$(pid)" ]; then
        echo "停止$TOMCAT_NAME..."
        kill -9 $(pid)
    else
        echo "$TOMCAT_NAME没有运行！"
    fi
}
deploy() {
    rm -rf $TOMCAT_ROOT
    if [ -f $WAR_PKG ]; then
        echo "开始解压项目..."
        unzip $WAR_PKG -d $TOMCAT_ROOT
        # echo "开始覆盖配置文件......"
        # cd $WORK_DIR/$TOMCAT_NAME/webapps && unzip -o root-config.zip
    else
        echo "$SVN_DIR/target目录WAR包不存在, Maven构建项目失败！！！"
        exit 1
    fi
}
modify() {
    # 执行处理命令
}
start() {
    $WORK_DIR/$TOMCAT_NAME/bin/startup.sh
    sleep 3
    if [ -n "$(pid)" ]; then
        echo "#######################################################################################"
        echo "#  网站服务正在启动..., 大约1分钟, 访问地址: $WEB_SITE                                 "                               
        echo "#######################################################################################"
    else
        echo "$TOMCAT_NAME 启动失败！！！"
        tail -n 50 $WORK_DIR/$TOMCAT_NAME/logs/catalina.out
        exit 1
    fi
}
main() {
    stop
    deploy
    # modify
    start
}
# 执行
main