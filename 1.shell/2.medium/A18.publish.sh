#!/bin/bash
export JAVA_HOME=/opt/software/jdk1.7.0_25
TOMCAT_HOME="/opt/software/apache-tomcat-7.0.59"
TOMCAT_PORT=80
PROJECT="server"
BAK_DIR=/opt/war/bak/$PROJECT/`date +%Y%m%d`



mkdir -p "${BAK_DIR}"
cp /opt/war/"${PROJECT}".war "${BAK_DIR}"/"${PROJECT}"_`date +%Y%m%d%H%M%S`.war


#shutdown tomcat
/opt/sh/kill-tomcat-force.sh

#publish project 
rm -rf "${TOMCAT_HOME}"/webapps/${PROJECT}
cp /opt/war/"${PROJECT}".war "${TOMCAT_HOME}"/webapps/${PROJECT}.war
q
#remove tmp
rm -rf /opt/war/${PROJECT}.war

#unzip war
unzip "${TOMCAT_HOME}"/webapps/${PROJECT}.war -d "${TOMCAT_HOME}"/webapps/${PROJECT}

rm -rf "${TOMCAT_HOME}"/webapps/${PROJECT}.war

##copy lib
cp /opt/lib/* "${TOMCAT_HOME}"/webapps/${PROJECT}/WEB-INF/lib/

## start tomcat

sleep 3

#start tomcat
/opt/software/apache-tomcat-7.0.59/bin/startup.sh
echo "tomcat is starting!"