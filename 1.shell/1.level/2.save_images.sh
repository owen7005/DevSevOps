#!/bin/bash
#! /bin/sh
#Author : Zhang Zhigang  
# Date : 2016-07-01 13:50
# Des : The scripts is 镜像导出
if [ "${shellName}" == "zsh" ]; then
  read "images?请输入待导出的镜像名称: "
else
  read -p "输入待导出的镜像名称: " images
fi

if [ "${images}" = "" ]; then
    echo "Error: image Name is blank!"
    exit 1
fi

allImages=(${images})

for imageName in ${allImages[@]}; do
    echo "Export image: ${imageName}..."
    docker save ${imageName} > `echo ${imageName} | tr '/' '_' | tr ':' '_'`.tar;
    echo "done!"
done
