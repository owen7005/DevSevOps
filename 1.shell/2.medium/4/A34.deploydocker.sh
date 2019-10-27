#! /bin/sh
#deploydocker.sh:Used to deploy
#writer 
#histor
#2017.12.24
########PATH########################################################
#1.备份原来.war包
TOMCAT_HOME=/opt/docker_file/token_new/token_user_webapp/
BAK_DIR=/opt/docker_file/token_new/token_user_webapp/bak/
PROJECT=tokenxx-user

#backup代码.war
mkdir -p "${BAK_DIR}"
cp /opt/docker_file/token_new/token_user_webapp/ROOT.war  "${BAK_DIR}"/"${PROJECT}"_`date +%Y%m%d%H%M%S`.war

#2.删除原来的.war包
cd "${TOMCAT_HOME}"
rm -rf ROOT*

#3.将新.war更名为ROOT.war
cd "${TOMCAT_HOME}"
mv *.war ROOT.war

#4.停止原来容器,删除原来容器
docker stop "${PROJECT}" && docker rm "${PROJECT}"
sleep 5
docker ps -a

#5.启动新容器######定义容器
docker run -d   --restart=always  --name tokenxx-user -v /opt/docker_file/token_new/token_xml/cn:/opt/cn/ -v /opt/docker_file/token_new/token_user_webapp:/opt/apache-tomcat-8.5.14/webapps/  -p 8088:8080  java/javaweb-jdk8-tomcat8
sleep 5
docker ps -a
docker logs  "${PROJECT}"
echo "JUST DO IT!"
