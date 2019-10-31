#!/usr/bin/python
#coding: utf-8

from __future__ import division
from collections import OrderedDict
import re
import time
import sys
import  os

cpu_stat_file = '/proc/stat'

def read_file():
    cpu_data = []
    with open(cpu_stat_file, 'r') as f:
        for data in f:
            if 'cpu' in data:
                cpu_num = re.split('\s*', data)[0]
                us = re.split('\s*', data)[1]
                nice = re.split('\s*', data)[2]    
                sys = re.split('\s*', data)[3]    
                idle = re.split('\s*', data)[4]
                iowait = re.split('\s*', data)[5]
                irq = re.split('\s*', data)[6]
                softirq = re.split('\s*', data)[7]
                stealstolen  = re.split('\s*', data)[8]
                guest = re.split('\s*', data)[9]
                cpu_data.append({cpu_num:[int(us), int(nice), int(sys), int(idle), int(iowait), int(irq), int(softirq), int(stealstolen), int(guest)]})
    return cpu_data

def cal(wait):
    '''CPU使用率计算方式:(当前某态使用总数-数秒前的使用总数)/(当前的CPU使用总数-数秒前的CPU使用总数)
    '''
    old = read_file()
    time.sleep(wait)
    new = read_file()

    old_dicts = OrderedDict()
    new_dicts = OrderedDict()
    
    for i in range(len(old)):
        old_dicts.update(old[i])
        new_dicts.update(new[i])
    print "all\tusr\tnice\tsys\tidle\tiowait\tirq\tsoft\tsteal\tguest"

    for key, value in old_dicts.items():
	new_value = new_dicts[key]
        test = zip(value,new_value)
        add = sum(new_value) - sum(value)
        usr_per = ((test[0][1]-test[0][0])/add) * 100
        nice_per = ((test[1][1]-test[1][0])/add) * 100
        sys_per = ((test[2][1]-test[2][0])/add) * 100
        idle_per = ((test[3][1]-test[3][0])/add) * 100
        iowait_per = ((test[4][1]-test[4][0])/add) * 100
        irq_per = ((test[5][1]-test[5][0])/add) * 100
        soft_per = ((test[6][1]-test[6][0])/add) * 100
        steal_per = ((test[7][1]-test[7][0])/add) * 100    
        guest_per = ((test[8][1]-test[8][0])/add) * 100
        print "%s\t%.2lf\t%.2lf\t%.2lf\t%.2lf\t%.2lf\t%.2lf\t%.2lf\t%.2lf\t%.2lf" % (key,usr_per, nice_per, sys_per, idle_per,iowait_per, irq_per, soft_per, steal_per, guest_per)
    return

def main():
    if len(sys.argv) == 1:
        cal(1)
    if len(sys.argv) == 3:
        if '-t' in sys.argv:
            #while 1:
            cal(int(sys.argv[2]))

if __name__ == '__main__':
    main()
