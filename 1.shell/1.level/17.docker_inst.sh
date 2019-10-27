#!/bin/sh
#
##Author : https://github.com/owen7005
# Date : 2016-07-01 13:50
set -e

#阿里云的安装脚本
curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
#DaoCloud 的安装脚本
#curl -sSL https://get.daocloud.io/docker | sh