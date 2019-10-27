#k8s-pig-build.sh
#!/bin/bash

#时间格式化
TIME_TAG=`date "+%Y%m%d%H%M"`
#Docker 私有仓库地址
IMAGE_REPOSITORY=hub.k8s.com/$1/
# git提交的版本
GIT_VERSION=`git log -1 --pretty=format:"%h"`

MOUDLE=(pig-eureka pig-config pig-auth pig-gateway)

cd doc/docker/
echo "DockerFile所在当前路径：" &&  pwd

for moudleName in ${MOUDLE[@]};do
echo "构建$moudleName is begining.."

# 创建模块的Dockerfile文件夹
mkdir -p Docker_$moudleName
mv $moudleName Docker_$moudleName/Dockerfile

cd ../../
echo "目录：" && pwd
#将打好的jar包移动到模块的Dockerfile文件夹下
mv $moudleName/target/$moudleName.jar doc/docker/Docker_$moudleName/$moudleName.jar
cd doc/docker/Docker_$moudleName

#组装docker镜像的名称
IMAGE_NAME=${IMAGE_REPOSITORY}$moudleName:${TIME_TAG}_${GIT_VERSION}

echo "开始构建镜像：${IMAGE_NAME}"
docker build -t ${IMAGE_NAME} .

echo "开始推送镜像:${IMAGE_NAME}至私有仓库：${IMAGE_REPOSITORY}"
docker push ${IMAGE_NAME}

echo "删除当前镜像：${IMAGE_NAME}"
docker rmi ${IMAGE_NAME}

cd ../

#将构建好的镜像名称存到本地，后面发布的时候会用到
echo "${IMAGE_NAME}" > $2/image_$moudleName

echo "构建$moudleName is ending..."
done

echo "目录DOCKER：" && pwd

mkdir Docker_pig-upms-service

cd ../../
echo "目录：" && pwd

cd pig-modules/pig-upms-service/target/

echo "目录JAR->:" && pwd && ls
mv pig-upms-service.jar /root/.jenkins/workspace/Jenkins-pig/doc/docker/Docker_pig-upms-service/pig-upms-service.jar

cd ../../../

mv doc/docker/pig-upms-service doc/docker/Docker_pig-upms-service/Dockerfile

echo "目录：" && pwd && ls
cd doc/docker/Docker_pig-upms-service

echo "开始构建：${IMAGE_REPOSITORY}pig-upms-service:${TIME_TAG}_${GIT_VERSION}"
docker build -t ${IMAGE_REPOSITORY}pig-upms-service:${TIME_TAG}_${GIT_VERSION} .

echo "开始推送：${IMAGE_REPOSITORY}pig-upms-service:${TIME_TAG}_${GIT_VERSION}"
docker push ${IMAGE_REPOSITORY}pig-upms-service:${TIME_TAG}_${GIT_VERSION}

echo "删除当前镜像：${IMAGE_REPOSITORY}pig-upms-service:${TIME_TAG}_${GIT_VERSION}"
docker rmi ${IMAGE_REPOSITORY}pig-upms-service:${TIME_TAG}_${GIT_VERSION}

echo "${IMAGE_REPOSITORY}pig-upms-service:${TIME_TAG}_${GIT_VERSION}" > $2/image_pig-upms-service

echo "构建pig-upms-service is ending..."

echo "所有镜像构建、推送完毕..."