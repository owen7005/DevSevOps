__author__ = 'Shilin.Qu'
import  time,sys,os,stop_server
tomcat_home='/usr/local/apache-tomcat-sso'  #机器所在tomcat的目录
shutdown_command=tomcat_home+"/bin/shutdown.sh"
start_command=tomcat_home+"/bin/startup.sh"
ps_comman='ps -ef | grep java > /home/jenkins/idp-core/result.txt'

url="http://idp-test.cdpyun.com/idp-core"   #启动之后待测试的网站，主要是为测试是否tomcat启动成功

def get_psresult():
    os.system(ps_comman)

def shudown_server():
    os.system(shutdown_command)

def start_server():
    try:
        os.system(start_command)
        print "startup.sh begin to run "
    except Exception , e:
        print "startup.sh can not be run "
def check_server_if_run():  #检测是否tomcat已经启动
    print "begin to check", url
    import urllib2
    try:
        content= urllib2.urlopen(str(url)).read()
        if str(content).__contains__("html") and str(content).__contains__("body"):
            return True
    except Exception , e:
        print "server is still not started "
        return False
def check_pid_ifexit():  #检测是否有对应的tomcat进程号
    print "begin to check if exit pid"
    get_psresult()
    f=open('/home/jenkins/idp-core/result.txt',"r")
    if str(f.read()).__contains__(tomcat_home):
        print "pid exit in  begin process"
        return True

    else:
        print "pid not found"
        return False
    f.close()

def star_main():   #主函数
    print "\n\n\n#########################################"
    print " Begain to start tomcat server "
    start_server()
    time.sleep(60)
    if not check_server_if_run():
        if not check_pid_ifexit():
            start_server()
        else:
            print "wait for  60 second"
            time.sleep(80)
    else:
        print "Tomcat server started successfully"
    if not check_server_if_run():
        print "Tomcat failed to start\n Try to shutdown and start again "
        stop_server.stop_main()
        start_server()
        time.sleep(120)
        if not check_server_if_run():
            print "#####################################\nTomcat server failed to start again, please check the application!!!"
        else:
            print "Tomcat server started successfully"
    else:
        print "Tomcat server started successfully"

star_main()
