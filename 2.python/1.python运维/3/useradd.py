#!/bin/env python
#coding=utf-8
#Filename=useradd.py

#useradd script
#-----------------------------------begin--------------------------------

import os
import datetime
import time
import getpass

choose = input('Please choose batch create username or single create username(1:single/2:batch/3:batch file):')
if choose == 1:
    while True:
        username = raw_input('Please input username:')
        password = getpass.getpass('Please enter password:')
        print('create username')
        os.system('useradd %(name1)s -s /bin/bash' %{'name1':username})
        os.system('echo %(pass)s |passwd --stdin %(name1)s' %{'name1':username,'pass':password})
        print('Created user! and password add successfully.')
        tocreate = raw_input('Please yes or no (yes/no):')
        tocreate = tocreate.lower()
        t = True
        while t:
            if tocreate == 'yes':
                print('Please continue create username.')
                t = False
            else:
                break
        if tocreate =='no':
            break

if choose == 2:
    username_list = []
    username_numb = raw_input('Please enter create how many users:')
    t = True
    while t:
        username = raw_input('Please input username:')
        password = raw_input('Please input password:')
        t = False

    for uu in range(1,int(username_numb)+1):
        print('create username')
        os.system('useradd %s%s -s /bin/bash' %(username,uu))
        username_list.append('%s%s'%(username,uu))
    for us in username_list:
        os.system('echo %(pass)s |passwd --stdin %(name1)s' %{'name1':us,'pass':password})
        print('Created user! and password add successfully.')

if choose ==3:
    username_list = 'user_list.txt'
    with open(username_list) as file_object:
        lines = file_object.readlines()
    for line in lines:
        print('create username')
        os.system('useradd %s -s /bin/bash'%(line.rstrip()))
        os.system('echo %s |passwd --stdin %s' %(line.rstrip(),line.rstrip()))
        print('Created user! and password add successfully.')
