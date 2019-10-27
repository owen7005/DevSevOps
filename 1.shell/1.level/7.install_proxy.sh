#!/bin/bash
#Author : Zhang Zhigang  
# Date : 2016-07-01 13:50
# Des : The scripts is
#安装代理

tee /usr/local/bin/proxy <<EOF
#!/bin/bash
http_proxy=http://192.168.1.21:8123 https_proxy=http://192.168.1.21:8123 \$*
EOF

chmod +x /usr/local/bin/proxy
