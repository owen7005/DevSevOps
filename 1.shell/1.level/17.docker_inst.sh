#!/bin/sh
set -e

#阿里云的安装脚本
curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
#DaoCloud 的安装脚本
#curl -sSL https://get.daocloud.io/docker | sh