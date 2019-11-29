# 安装

```bash
# 官网地址
# https://argoproj.github.io/argo-cd/getting_started/

$ kubectl create namespace argocd
$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
$ kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# 获取登录token
$ kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

# 下载命令行工具并登录
$ wget https://github.com/argoproj/argo-cd/releases/download/v1.1.2/argocd-linux-amd64
$ chmod +x argocd-linux-amd64
$ ./argocd-linux-amd64 login <LoadBalancerIP>
Username: admin
Password: <上一步获取到的token>

# 修改密码并重新登录
$ ./argocd-linux-amd64 account update-password
$ ./argocd-linux-amd64 relogin

```

# 使用

```bash
# 查看当前集群
$ ./argocd-linux-amd64 cluster list 
SERVER                                                                      NAME      STATUS      MESSAGE
https://kubernetes.default.svc                                                        Successful  

# 增加官方示例
$ ./argocd-linux-amd64 app create guestbook \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace guestbooktest

# 查看示例
$ ./argocd-linux-amd64 app list

####### 官方示例的guestbook的镜像地址是：gcr.io/heptio-images/ks-guestbook-demo:0.2，果断放弃。创建自己的demo示例。

# 增加自定义的示例
$ ./argocd-linux-amd64 app create nginxdemo \
  --repo https://github.com/hbstarjason/spinnaker-demo.git \
  --path argocd \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace nginx-demo

# 确认示例已增加
$ ./argocd-linux-amd64 app list
NAME       CLUSTER                         NAMESPACE      PROJECT  STATUS     HEALTH    SYNCPOLICY  CONDITIONS
guestbook  https://kubernetes.default.svc  guestbooktest  default  Synced     Degraded  <none>      <none>
nginxdemo  https://kubernetes.default.svc  nginx-demo     default  OutOfSync  Healthy   <none>      <none>

# 部署示例
$ ./argocd-linux-amd64 app sync nginxdemo

# 再次确认示例已部署
$ ./argocd-linux-amd64 app list
NAME       CLUSTER                         NAMESPACE      PROJECT  STATUS  HEALTH    SYNCPOLICY  CONDITIONS
guestbook  https://kubernetes.default.svc  guestbooktest  default  Synced  Degraded  <none>      <none>
nginxdemo  https://kubernetes.default.svc  nginx-demo     default  Synced  Healthy   <none>      <none>

### 说明：应用在没有执行sync之前，应用显示的状态是OutOfSync，执行sync之后，状态会变更为Synced，表明应用已部署至指定的k8s集群上。

### 若git仓库里部署文件有变化，状态会自动变回OutOfSync，就需要重新执行Synced，才会自动部署。（注：Synced可以设置成自动）
```

```bash
# 登录ui查看
# 直接访问：http://<LoadBalancerIP>
```

