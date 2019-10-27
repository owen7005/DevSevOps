#!/bin/bash
#Author : Zhang Zhigang  
# Date : 2016-07-01 13:50
# Des : The scripts is
#检查ping

ping www.suanhua.org -c1 | grep PING | awk '{ print $3 }'  | cut -c 2- | cut -d\) -f1
