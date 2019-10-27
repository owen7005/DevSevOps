#!/bin/bash
#Author : Zhang Zhigang  
# Date : 2016-07-01 13:50
# Des : The scripts is
#安装docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

echo "alias dc='docker-compose'" >> ~/.zshrc
