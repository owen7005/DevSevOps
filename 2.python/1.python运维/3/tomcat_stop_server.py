__author__ = 'Shilin.Qu'
import  time,sys,os

tomcat_home='/usr/local/apache-tomcat-sso'   #机器所在tomcat的目录
shutdown_command=tomcat_home+"/bin/shutdown.sh"
start_command=tomcat_home+"/bin/startup.sh"
ps_comman='ps -ef | grep java > /home/jenkins/idp-core/result.txt'   #将linux正常输出到result.txt这个文件中

def get_psresult():
    os.system(ps_comman)

def shudown_server():
    try:
        os.system(shutdown_command)
    except Exception , e:
        print "shutdown.sh can not be run "

def check_server_if_run():   #检测是否tomcat已经启动
    get_psresult()
    f=open('/home/jenkins/idp-core/result.txt',"r")
    if str(f.read()).__contains__(tomcat_home):
        return True
    else:
        return False
    f.close()
def kill_pid():
    get_psresult()
    f=open('/home/jenkins/idp-core/result.txt',"r")
    f2=open('/home/jenkins/idp-core/result.txt',"r")
    for line in f.readlines():
            if line.__contains__(tomcat_home):
                pid=line[8:15].strip(" ")
                print "pid", pid," will be killed"
                kill_command="kill -9 "+str(pid)
                os.system(kill_command)
    if str(f2.read()).__contains__(tomcat_home):
        print "pid has been killed"
    else:
        print "pid can not been killed ,please check "
def stop_main():    #主函数
    print "begain to stop tomcat server "
    if  check_server_if_run():
        shudown_server()
        print "tomcat server is shutted please wait for 10 secends"
        time.sleep(10)
    if  check_server_if_run():
        kill_pid()
        time.sleep(3)
    if  check_server_if_run():
        print "Tomcat shut down failed"
    else:
        print "Tomcat server stoped  successfully"

stop_main()
