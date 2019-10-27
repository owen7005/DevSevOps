#!/bin/sh
	procnum=` ps -fe|grep 'geth_3.2.3_etc_28001'|grep -v grep|wc -l`
	if [ $procnum -eq 0 ]; then
		echo "start process geth etcc:`date '+%Y%m%d %H%M%S'`" >> /tmp/monitor_geth_etcc.log
			/usr/local/wallet/etcc/startup_geth_etc.sh
		echo "end process geth etcc...." >> /tmp/monitor_geth_etcc.log.log
	else
		echo "geth eth runing:`date '+%Y%m%d %H%M%S'`" >> /tmp/monitor_geth_etcc.log
	fi


#   procnum2=` ps -fe|grep 'geth_1.7.2_eth'|grep -v grep|wc -l`
#        if [ $procnum2 -eq 0 ]; then
#                echo "start process geth eth2:`date '+%Y%m%d %H%M%S'`" >> /tmp/monitor_geth_eth2.log
#                       /usr/local/wallet/eth2/startup_geth_etc.sh
#               echo "end process geth etc..." >> /tmp/monitor_geth_eth2.log
#       else
#               echo "geth etc runing:`date '+%Y%m%d %H%M%S'`" >> /tmp/monitor_geth_eth2.log
#        fi
#	
#    procnum3=` ps -fe|grep 'geth_1.5.8_eth'|grep -v grep|wc -l`
#        if [ $procnum3 -eq 0 ]; then
#                echo "start process geth pwd
#                eth:`date '+%Y%m%d %H%M%S'`" >> /tmp/monitor_geth_eth.log
#                       /usr/local/wallet/eth3/startup_geth_eth.sh
#               echo "end process geth  eth...." >> /tmp/monitor_geth_eth.log
#       else
#                echo "geth  eth runing:`date '+%Y%m%d %H%M%S'`" >> /tmp/monitor_geth_eth.log
#        fi
#
    procnum4=` ps -fe|grep 'geth_3.2.3_etc_8546'|grep -v grep|wc -l`
       if [ $procnum4 -eq 0 ]; then
                echo "start process geth etc:`date '+%Y%m%d %H%M%S'`" >> /tmp/monitor_geth_etc.log
                       /usr/local/wallet/etc/startup_geth_etc.sh
                echo "end process geth etc...." >> /tmp/monitor_geth_etc.log
        else
                echo "geth etc runing:`date '+%Y%m%d %H%M%S'`" >> /tmp/monitor_geth_etc.log
       fi
