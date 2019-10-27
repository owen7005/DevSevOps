#!/bin/bash
##!/bin/bash
# ----------------------------------------
# kubernetes v1.9.1 单机一键部署脚本
# 用于实验环境
# CentOS 7.2.1511下测试OK
# Powered by Jerry Wong
# 2018-03-15 hzde0128@live.cn
# ----------------------------------------

function get_local_ip() {
    IP_ADDR=`ip addr | grep inet | grep -Ev '127|inet6' | awk '{print $2}' | awk -F'/' '{print $1}'`
    export NODE_IP=${IP_ADDR}
}

function basic_settings() {
    getenforce  | grep Disabled > /dev/null
    if [ $? -ne 0 ]; then
        sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
    fi
    systemctl stop firewalld
    systemctl disable firewalld
}

function install_docker() {
    yum -y install yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    yum -y install docker-ce

    systemctl start docker
    systemctl status docker
    systemctl enable docker

    # 使用国内(腾讯)加速器
    sed -i 's#ExecStart=/usr/bin/dockerd#ExecStart=/usr/bin/dockerd --registry-mirror=https://mirror.ccs.tencentyun.com#' /usr/lib/systemd/system/docker.service 
    systemctl daemon-reload
    systemctl restart docker
}

function install_etcd() {
    chmod +x etcd etcdctl
    mv etcd etcdctl /usr/bin/
}

# 安装Kubernetes
function install_kubernetes() {
    chmod +x kube*
    mv kube{ctl,-apiserver,-scheduler,-controller-manager,let,-proxy} /usr/bin/       

    # 查看版本信息
    kube-apiserver --version
}

# 安装flanneld
function install_flanneld() {
    chmod +x flanneld mk-docker-opts.sh
    mv flanneld /usr/bin/
    mkdir /usr/libexec/flannel/
    mv mk-docker-opts.sh /usr/libexec/flannel/

    # 查看版本信息
    flanneld --version
}

# 配置并启用etcd
function config_etcd() {
cat > /usr/lib/systemd/system/etcd.service <<EOF
[Unit]
Description=etcd
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos/etcd
[Service]
Type=notify
WorkingDirectory=/var/lib/etcd
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=/usr/bin/etcd --config-file /etc/etcd/etcd.conf
Restart=on-failure
LimitNOFILE=65536
Restart=on-failure
RestartSec=5
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

mkdir -p /var/lib/etcd/
mkdir -p /etc/etcd/
export ETCD_NAME=etcd
cat > /etc/etcd/etcd.conf <<EOF 
name: '${ETCD_NAME}'
data-dir: "/var/lib/etcd/"
listen-peer-urls: http://${NODE_IP}:2380
listen-client-urls: http://${NODE_IP}:2379,http://127.0.0.1:2379
initial-advertise-peer-urls: http://${NODE_IP}:2380
advertise-client-urls: http://${NODE_IP}:2379
initial-cluster: "etcd=http://${NODE_IP}:2380"
initial-cluster-token: 'etcd-cluster'
initial-cluster-state: 'new'
EOF

systemctl start etcd
[ $? -eq 0 ] || exit
systemctl status etcd
systemctl enable etcd

# 检查安装情况
etcdctl member list
[ $? -eq 0 ] || exit
# 查看集群健康状况
etcdctl cluster-health
[ $? -eq 0 ] || exit
}

# 配置并启用 `flanneld`
function config_flanneld() {
cat > /etc/systemd/system/flanneld.service <<EOF
[Unit]
Description=Flanneld overlay address etcd agent
After=network.target
After=network-online.target
Wants=network-online.target
After=etcd.service
Before=docker.service
[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/flanneld
EnvironmentFile=-/etc/sysconfig/docker-network
ExecStart=/usr/bin/flanneld-start \$FLANNEL_OPTIONS
ExecStartPost=/usr/libexec/flannel/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker
Restart=on-failure
[Install]
WantedBy=multi-user.target
RequiredBy=docker.service
EOF

cat > /usr/bin/flanneld-start <<EOF
#!/bin/sh
exec /usr/bin/flanneld \\
        -etcd-endpoints=\${FLANNEL_ETCD_ENDPOINTS:-\${FLANNEL_ETCD}} \\
        -etcd-prefix=\${FLANNEL_ETCD_PREFIX:-\${FLANNEL_ETCD_KEY}} \\
        "\$@"
EOF

chmod 755 /usr/bin/flanneld-start

etcdctl mkdir /kube/network
etcdctl set /kube/network/config '{ "Network": "10.254.0.0/16" }'

cat > /etc/sysconfig/flanneld <<EOF
FLANNEL_ETCD_ENDPOINTS="http://${NODE_IP}:2379"
FLANNEL_ETCD_PREFIX="/kube/network"
EOF

systemctl start flanneld
[ $? -eq 0 ] || exit
systemctl status flanneld
systemctl enable flanneld

# 更改docker网段为flannel分配的网段
source /var/run/flannel/subnet.env

cat > /etc/docker/daemon.json <<EOF 
{
  "bip" : "$FLANNEL_SUBNET"
}
EOF

# 重启 docker
systemctl daemon-reload
systemctl restart docker
[ $? -eq 0 ] || exit
}

function config_apiserver() {
mkdir -p /etc/kubernetes/
cat > /etc/kubernetes/config <<EOF
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_LEVEL="--v=0"
KUBE_ALLOW_PRIV="--allow-privileged=false"
KUBE_MASTER="--master=http://${NODE_IP}:8080"
KUBE_ADMISSION_CONTROL=ServiceAccount
EOF

# 配置kube-apiserver启动项
cat > /etc/systemd/system/kube-apiserver.service <<EOF
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes
After=network.target
After=etcd.service
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/apiserver
ExecStart=/usr/bin/kube-apiserver \\
            \$KUBE_LOGTOSTDERR \\
            \$KUBE_LOG_LEVEL \\
            \$KUBE_ETCD_SERVERS \\
            \$KUBE_API_ADDRESS \\
            \$KUBE_API_PORT \\
            \$KUBELET_PORT \\
            \$KUBE_ALLOW_PRIV \\
            \$KUBE_SERVICE_ADDRESSES \\
            \$KUBE_ADMISSION_CONTROL \\
            \$KUBE_API_ARGS
Restart=on-failure
Type=notify
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

# 配置apiserver配置文件
cat > /etc/kubernetes/apiserver <<EOF
KUBE_API_ADDRESS="--advertise-address=${NODE_IP} --bind-address=${NODE_IP} --insecure-bind-address=0.0.0.0"
KUBE_ETCD_SERVERS="--etcd-servers=http://${NODE_IP}:2379"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota"
KUBE_API_ARGS="--enable-swagger-ui=true --apiserver-count=3 --audit-log-maxage=30 --audit-log-maxbackup=3 --audit-log-maxsize=100 --audit-log-path=/var/log/apiserver.log"
EOF

# 启动kube-apiserver
systemctl start kube-apiserver
[ $? -eq 0 ] || exit
systemctl status kube-apiserver
systemctl enable kube-apiserver
}

# 配置kube-controller-manager
function config_controller-manager() {
cat > /etc/systemd/system/kube-controller-manager.service <<EOF
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/controller-manager
ExecStart=/usr/bin/kube-controller-manager \\
            \$KUBE_LOGTOSTDERR \\
            \$KUBE_LOG_LEVEL \\
            \$KUBE_MASTER \\
            \$KUBE_CONTROLLER_MANAGER_ARGS
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/kubernetes/controller-manager <<EOF
KUBE_CONTROLLER_MANAGER_ARGS="--address=127.0.0.1 --service-cluster-ip-range=10.254.0.0/16 --cluster-name=kubernetes"
EOF

# 启动kube-controller-manager
systemctl start kube-controller-manager
[ $? -eq 0 ] || exit
systemctl status kube-controller-manager
systemctl enable kube-controller-manager
}

# 配置kube-scheduler
function config_scheduler() {
cat > /usr/lib/systemd/system/kube-scheduler.service <<EOF
[Unit]
Description=Kubernetes Scheduler Plugin
Documentation=https://github.com/kubernetes/kubernetes
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/scheduler
ExecStart=/usr/bin/kube-scheduler \\
            \$KUBE_LOGTOSTDERR \\
            \$KUBE_LOG_LEVEL \\
            \$KUBE_MASTER \\
            \$KUBE_SCHEDULER_ARGS
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

# 配置kube-scheduler配置文件
cat > /etc/kubernetes/scheduler <<EOF
KUBE_SCHEDULER_ARGS="--address=127.0.0.1"
EOF

# 启动kube-scheduler
systemctl start kube-scheduler
[ $? -eq 0 ] || exit
systemctl status kube-scheduler
systemctl enable kube-scheduler

#验证Master节点
kubectl get cs
}

## 9. 配置并启用  `Kubernetes Node`  节点 

# 配置kubelet
function config_kubelet() {
cat > /usr/lib/systemd/system/kubelet.service <<EOF
[Unit]
Description=Kubernetes Kubelet Server
Documentation=https://github.com/kubernetes/kubernetes
After=docker.service
Requires=docker.service
[Service]
WorkingDirectory=/var/lib/kubelet
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/kubelet
ExecStart=/usr/bin/kubelet \\
            \$KUBE_LOGTOSTDERR \\
            \$KUBE_LOG_LEVEL \\
            \$KUBELET_ADDRESS \\
            \$KUBELET_PORT \\
            \$KUBELET_HOSTNAME \\
            \$KUBE_ALLOW_PRIV \\
            \$KUBELET_POD_INFRA_CONTAINER \\
            \$KUBELET_ARGS
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

mkdir -p /var/lib/kubelet
export KUBECONFIG_DIR=/etc/kubernetes

cat > "${KUBECONFIG_DIR}/kubelet.kubeconfig" <<EOF
apiVersion: v1
kind: Config
clusters:
  - cluster:
      server: http://${NODE_IP}:8080/
    name: local
contexts:
  - context:
      cluster: local
    name: local
current-context: local
EOF

cat > /etc/kubernetes/kubelet <<EOF
KUBELET_ADDRESS="--address=${NODE_IP}"
KUBELET_PORT="--port=10250"
KUBELET_HOSTNAME="--hostname-override=master"
KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=hub.c.163.com/k8s163/pause-amd64:3.0"
KUBELET_ARGS="--kubeconfig=/etc/kubernetes/kubelet.kubeconfig --fail-swap-on=false --cluster-dns=10.254.0.2 --cluster-domain=cluster.local. --serialize-image-pulls=false"
EOF

# 启动kubelet
systemctl start kubelet
[ $? -eq 0 ] || exit
systemctl status kubelet
systemctl enable kubelet
}

# 配置kube-proxy
function config_proxy() {
cat > /etc/systemd/system/kube-proxy.service <<EOF
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/kubernetes/kubernetes
After=network.target
[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/proxy
ExecStart=/usr/bin/kube-proxy \\
            \$KUBE_LOGTOSTDERR \\
            \$KUBE_LOG_LEVEL \\
            \$KUBE_MASTER \\
            \$KUBE_PROXY_ARGS
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

# 配置kube-proxy配置文件
cat > /etc/kubernetes/proxy <<EOF
KUBE_PROXY_ARGS="--bind-address=${NODE_IP} --hostname-override=${NODE_IP} --cluster-cidr=10.254.0.0/16"
EOF

# 启动kube-proxy
systemctl start kube-proxy
[ $? -eq 0 ] || exit
systemctl status kube-proxy
systemctl enable kube-proxy
}

### G. 查看  `Nodes` 相关信息
function view_status() {
kubectl get nodes -o wide
kubectl get nodes --show-labels
kubectl version --short
kubectl cluster-info
}

#部署KubeDNS插件
function deploy_kubedns() {
cat > kube-dns.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: kube-dns
  namespace: kube-system
  labels:
    k8s-app: kube-dns
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
    kubernetes.io/name: "KubeDNS"
spec:
  selector:
    k8s-app: kube-dns
  clusterIP: 10.254.0.2
  ports:
  - name: dns
    port: 53
    protocol: UDP
  - name: dns-tcp
    port: 53
    protocol: TCP
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kube-dns
  namespace: kube-system
  labels:
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: kube-dns
  namespace: kube-system
  labels:
    k8s-app: kube-dns
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
spec:
  # replicas: not specified here:
  # 1. In order to make Addon Manager do not reconcile this replicas parameter.
  # 2. Default is 1.
  # 3. Will be tuned in real time if DNS horizontal auto-scaling is turned on.
  strategy:
    rollingUpdate:
      maxSurge: 10%
      maxUnavailable: 0
  selector:
    matchLabels:
      k8s-app: kube-dns
  template:
    metadata:
      labels:
        k8s-app: kube-dns
      annotations:
        scheduler.alpha.kubernetes.io/critical-pod: ''
    spec:
      priorityClassName: system-cluster-critical
      tolerations:
      - key: "CriticalAddonsOnly"
        operator: "Exists"
      volumes:
      - name: kube-dns-config
        configMap:
          name: kube-dns
          optional: true
      containers:
      - name: kubedns
        image: registry.cn-hangzhou.aliyuncs.com/google_containers/k8s-dns-kube-dns-amd64:1.14.8
        resources:
          # TODO: Set memory limits when we've profiled the container for large
          # clusters, then set request = limit to keep this container in
          # guaranteed class. Currently, this container falls into the
          # "burstable" category so the kubelet doesn't backoff from restarting it.
          limits:
            memory: 170Mi
          requests:
            cpu: 100m
            memory: 70Mi
        livenessProbe:
          httpGet:
            path: /healthcheck/kubedns
            port: 10054
            scheme: HTTP
          initialDelaySeconds: 60
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 5
        readinessProbe:
          httpGet:
            path: /readiness
            port: 8081
            scheme: HTTP
          # we poll on pod startup for the Kubernetes master service and
          # only setup the /readiness HTTP server once that's available.
          initialDelaySeconds: 3
          timeoutSeconds: 5
        args:
        - --domain=cluster.local.
        - --kube-master-url=http://${NODE_IP}:8080
        - --dns-port=10053
        - --config-dir=/kube-dns-config
        - --v=2
        env:
        - name: PROMETHEUS_PORT
          value: "10055"
        ports:
        - containerPort: 10053
          name: dns-local
          protocol: UDP
        - containerPort: 10053
          name: dns-tcp-local
          protocol: TCP
        - containerPort: 10055
          name: metrics
          protocol: TCP
        volumeMounts:
        - name: kube-dns-config
          mountPath: /kube-dns-config
      - name: dnsmasq
        image: registry.cn-hangzhou.aliyuncs.com/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.8
        livenessProbe:
          httpGet:
            path: /healthcheck/dnsmasq
            port: 10054
            scheme: HTTP
          initialDelaySeconds: 60
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 5
        args:
        - -v=2
        - -logtostderr
        - -configDir=/etc/k8s/dns/dnsmasq-nanny
        - -restartDnsmasq=true
        - --
        - -k
        - --cache-size=1000
        - --no-negcache
        - --log-facility=-
        - --server=/cluster.local/127.0.0.1#10053
        - --server=/in-addr.arpa/127.0.0.1#10053
        - --server=/ip6.arpa/127.0.0.1#10053
        ports:
        - containerPort: 53
          name: dns
          protocol: UDP
        - containerPort: 53
          name: dns-tcp
          protocol: TCP
        # see: https://github.com/kubernetes/kubernetes/issues/29055 for details
        resources:
          requests:
            cpu: 150m
            memory: 20Mi
        volumeMounts:
        - name: kube-dns-config
          mountPath: /etc/k8s/dns/dnsmasq-nanny
      - name: sidecar
        image: registry.cn-hangzhou.aliyuncs.com/google_containers/k8s-dns-sidecar-amd64:1.14.8
        livenessProbe:
          httpGet:
            path: /metrics
            port: 10054
            scheme: HTTP
          initialDelaySeconds: 60
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 5
        args:
        - --v=2
        - --logtostderr
        - --probe=kubedns,127.0.0.1:10053,kubernetes.default.svc.cluster.local,5,SRV
        - --probe=dnsmasq,127.0.0.1:53,kubernetes.default.svc.cluster.local,5,SRV
        ports:
        - containerPort: 10054
          name: metrics
          protocol: TCP
        resources:
          requests:
            memory: 20Mi
            cpu: 10m
      dnsPolicy: Default  # Don't use cluster DNS.
      serviceAccountName: kube-dns

EOF

kubectl create -f kube-dns.yaml
sleep 30
kubectl get pod -n kube-system

kubectl get service -n kube-system | grep dns
}

# 部署Heapster组件
function deploy_heapster() {
cat > heapster-rbac.yaml <<EOF
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: heapster
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:heapster
subjects:
- kind: ServiceAccount
  name: heapster
  namespace: kube-system
EOF

cat > grafana.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: monitoring-grafana
  namespace: kube-system
spec:
  replicas: 1
  template:
    metadata:
      labels:
        task: monitoring
        k8s-app: grafana
    spec:
      containers:
      - name: grafana
        image: registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-grafana-amd64:v4.4.3
        ports:
        - containerPort: 3000
          protocol: TCP
        volumeMounts:
        - mountPath: /etc/ssl/certs
          name: ca-certificates
          readOnly: true
        - mountPath: /var
          name: grafana-storage
        env:
        - name: INFLUXDB_HOST
          value: monitoring-influxdb
        - name: GF_SERVER_HTTP_PORT
          value: "3000"
        - name: GF_AUTH_BASIC_ENABLED
          value: "false"
        - name: GF_AUTH_ANONYMOUS_ENABLED
          value: "true"
        - name: GF_AUTH_ANONYMOUS_ORG_ROLE
          value: Admin
        - name: GF_SERVER_ROOT_URL
          value: /
      volumes:
      - name: ca-certificates
        hostPath:
          path: /etc/ssl/certs
      - name: grafana-storage
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  labels:
    kubernetes.io/cluster-service: 'true'
    kubernetes.io/name: monitoring-grafana
  name: monitoring-grafana
  namespace: kube-system
spec:
  ports:
  - port: 80
    targetPort: 3000
  selector:
    k8s-app: grafana
EOF

cat > heapster.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: heapster
  namespace: kube-system
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: heapster
  namespace: kube-system
spec:
  replicas: 1
  template:
    metadata:
      labels:
        task: monitoring
        k8s-app: heapster
    spec:
      serviceAccountName: heapster
      containers:
      - name: heapster
        image: registry.cn-hangzhou.aliyuncs.com/google-containers/heapster-amd64:v1.4.0
        imagePullPolicy: IfNotPresent
        command:
        - /heapster
        - --source=kubernetes:http://${NODE_IP}:8080?inClusterConfig=false
        - --sink=influxdb:http://monitoring-influxdb.kube-system.svc:8086
---
apiVersion: v1
kind: Service
metadata:
  labels:
    task: monitoring
    kubernetes.io/cluster-service: 'true'
    kubernetes.io/name: Heapster
  name: heapster
  namespace: kube-system
spec:
  ports:
  - port: 80
    targetPort: 8082
  selector:
    k8s-app: heapster
EOF

cat > influxdb.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: monitoring-influxdb
  namespace: kube-system
spec:
  replicas: 1
  template:
    metadata:
      labels:
        task: monitoring
        k8s-app: influxdb
    spec:
      containers:
      - name: influxdb
        image: registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-influxdb-amd64:v1.3.3
        volumeMounts:
        - mountPath: /data
          name: influxdb-storage
      volumes:
      - name: influxdb-storage
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  labels:
    task: monitoring
    kubernetes.io/cluster-service: 'true'
    kubernetes.io/name: monitoring-influxdb
  name: monitoring-influxdb
  namespace: kube-system
spec:
  ports:
  - port: 8086
    targetPort: 8086
  selector:
    k8s-app: influxdb
EOF

kubectl create -f heapster-rbac.yaml -f grafana.yaml -f heapster.yaml -f influxdb.yaml

# 检查执行结果
kubectl get deployments -n kube-system | grep -E 'heapster|monitoring'

# 检查Pods
kubectl get pods -n kube-system | grep -E 'heapster|monitoring'
kubectl get svc -n kube-system  | grep -E 'heapster|monitoring'

# 查看集群信息
kubectl cluster-info
}

# 部署Kubernetes Dashboard
function deploy_dashboard() {
cat > kubernetes-dashboard.yaml <<EOF
# ------------------- Dashboard Service Account ------------------- #

apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system

---
# ------------------- Dashboard Role & Role Binding ------------------- #

kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: kubernetes-dashboard-minimal
  namespace: kube-system
rules:
  # Allow Dashboard to create 'kubernetes-dashboard-key-holder' secret.
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["create"]
  # Allow Dashboard to create 'kubernetes-dashboard-settings' config map.
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["create"]
  # Allow Dashboard to get, update and delete Dashboard exclusive secrets.
- apiGroups: [""]
  resources: ["secrets"]
  resourceNames: ["kubernetes-dashboard-key-holder"]
  verbs: ["get", "update", "delete"]
  # Allow Dashboard to get and update 'kubernetes-dashboard-settings' config map.
- apiGroups: [""]
  resources: ["configmaps"]
  resourceNames: ["kubernetes-dashboard-settings"]
  verbs: ["get", "update"]
  # Allow Dashboard to get metrics from heapster.
- apiGroups: [""]
  resources: ["services"]
  resourceNames: ["heapster"]
  verbs: ["proxy"]
- apiGroups: [""]
  resources: ["services/proxy"]
  resourceNames: ["heapster", "http:heapster:", "https:heapster:"]
  verbs: ["get"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: kubernetes-dashboard-minimal
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: kubernetes-dashboard-minimal
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kube-system

---
# ------------------- Dashboard Deployment ------------------- #

kind: Deployment
apiVersion: apps/v1beta2
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: kubernetes-dashboard
  template:
    metadata:
      labels:
        k8s-app: kubernetes-dashboard
    spec:
      containers:
      - name: kubernetes-dashboard
        image: registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.8.3
        ports:
        - containerPort: 9090
          protocol: TCP
        args:
          # Uncomment the following line to manually specify Kubernetes API server Host
          # If not specified, Dashboard will attempt to auto discover the API server and connect
          # to it. Uncomment only if the default does not work.
          # - --apiserver-host=http://my-address:port
          - --apiserver-host=http://${NODE_IP}:8080
        volumeMounts:
          # Create on-disk volume to store exec logs
        - mountPath: /tmp
          name: tmp-volume
        livenessProbe:
          httpGet:
            path: /
            port: 9090
          initialDelaySeconds: 30
          timeoutSeconds: 30
      volumes:
      - name: tmp-volume
        emptyDir: {}
      serviceAccountName: kubernetes-dashboard
      # Comment the following tolerations if Dashboard must not be deployed on master
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule

---
# ------------------- Dashboard Service ------------------- #

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  ports:
  - port: 80
    targetPort: 9090
  selector:
    k8s-app: kubernetes-dashboard
EOF

kubectl create -f kubernetes-dashboard.yaml

# 检查kubernetes-dashboard服务
kubectl get pods -n kube-system | grep dashboard
}

function main() {
    get_local_ip
    basic_settings
    install_docker
    install_etcd
    install_kubernetes
    install_flanneld
    config_etcd
    config_flanneld
    config_apiserver
    config_controller-manager
    config_scheduler
    config_kubelet
    config_proxy
    view_status
    deploy_kubedns
    deploy_heapster
    deploy_dashboard
}

main