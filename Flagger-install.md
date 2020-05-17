安装

```bash
# 官网地址：https://docs.flagger.app/tutorials/nginx-progressive-delivery

# 安装 Helm v3
# 官网地址：https://helm.sh/docs/intro/install/
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
chmod 700 get_helm.sh && \
 ./get_helm.sh && \ 
helm repo add stable https://kubernetes-charts.storage.googleapis.com/


# 安装 ingress-nginx
$ kubectl create ns ingress-nginx
$ helm upgrade -i nginx-ingress stable/nginx-ingress \
--namespace ingress-nginx \
--set controller.metrics.enabled=true \
--set controller.podAnnotations."prometheus\.io/scrape"=true \
--set controller.podAnnotations."prometheus\.io/port"=10254

# 安装 Flagger and the Prometheus add-on
$ helm repo add flagger https://flagger.app
$ helm upgrade -i flagger flagger/flagger \
--namespace ingress-nginx \
--set prometheus.install=true \
--set meshProvider=nginx
```

启动测试应用

```bash
$ kubectl create ns test
$ kubectl apply -k github.com/weaveworks/flagger//kustomize/podinfo
$ helm upgrade -i flagger-loadtester flagger/loadtester \
--namespace=test

$ kubectl apply -f https://raw.githubusercontent.com/hbstarjason/Continuous-Deploy/master/flagger/podinfo-ingress.yaml

$ kubectl apply -f https://raw.githubusercontent.com/hbstarjason/Continuous-Deploy/master/flagger/podinfo-canary.yaml
```

验证测试自动化金丝雀

```bash
$ kubectl -n test set image deployment/podinfo \
podinfod=stefanprodan/podinfo:3.1.1

$ kubectl -n test describe canary/podinfo


$ watch kubectl get canaries --all-namespaces
```

验证自动回滚

```bash
$ kubectl -n test set image deployment/podinfo \
podinfod=stefanprodan/podinfo:3.1.2

$ watch curl http://app.example.com/status/500

$ kubectl -n test describe canary/podinfo

```





A/B测试

```bash
#
```

