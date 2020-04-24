# 安装

```bash
# 官网地址
# https://argoproj.github.io/argo-rollouts/getting-started/

$ kubectl create namespace argo-rollouts
$ kubectl apply -n argo-rollouts -f https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml
customresourcedefinition.apiextensions.k8s.io/analysisruns.argoproj.io created
customresourcedefinition.apiextensions.k8s.io/analysistemplates.argoproj.io created
customresourcedefinition.apiextensions.k8s.io/experiments.argoproj.io created
error: error validating "https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml": error validating data: [ValidationError(CustomResourceDefinition.spec.validation.openAPIV3Schema.properties.spec.properties.strategy.properties.canary.properties.maxSurge): unknown field "x-kubernetes-int-or-string" in io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaProps, ValidationError(CustomResourceDefinition.spec.validation.openAPIV3Schema.properties.spec.properties.strategy.properties.canary.properties.maxUnavailable): unknown field "x-kubernetes-int-or-string" in io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaProps]; if you choose to ignore these errors, turn validation off with --validate=false

# 执行过程中遇到了一点问题，莫慌，根据提示再次执行
$ kubectl apply -n argo-rollouts -f https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml --validate=false

# 安装成功
$ kubectl get po  -n argo-rollouts
NAME                             READY   STATUS    RESTARTS   AGE
argo-rollouts-5557cd85f9-bthgv   1/1     Running   0          35s

# 查看相关CRD资源
$ kubectl get crd
NAME                            CREATED AT
analysisruns.argoproj.io        2020-04-22T05:34:43Z
analysistemplates.argoproj.io   2020-04-22T05:34:45Z
experiments.argoproj.io         2020-04-22T05:34:48Z
rollouts.argoproj.io            2020-04-22T05:37:22Z

# 下载命令行插件
# https://argoproj.github.io/argo-rollouts/features/kubectl-plugin/

$ curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64 && \
  chmod +x ./kubectl-argo-rollouts-linux-amd64 && \
  sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts && \
  kubectl argo rollouts version
```

# 使用

```bash
# 官网示例
# https://argoproj.github.io/argo-rollouts/getting-started/

$ cat << EOF > rollout-demo.yaml
apiVersion: argoproj.io/v1alpha1 # Changed from apps/v1
kind: Rollout # Changed from Deployment
# ----- Everything below this comment is the same as a deployment -----
metadata:
  name: example-rollout
spec:
  replicas: 5
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.15.4
        ports:
        - containerPort: 80
  minReadySeconds: 30
  revisionHistoryLimit: 3
  strategy:
  # ----- Everything above this comment are the same as a deployment -----
    canary: # A new field that used to provide configurable options for a Canary strategy
      steps:
      - setWeight: 20
      - pause: {}
EOF

$ kubectl apply -f rollout-demo.yaml

# 查看
$ kubectl get replicaset -w -o wide
NAME                         DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES         SELECTOR
example-rollout-76f5bddc69   5         5         1       26s   nginx        nginx:1.15.4   app=nginx,rollouts-pod-template-hash=76f5bddc69
example-rollout-76f5bddc69   5         5         2       27s   nginx        nginx:1.15.4   app=nginx,rollouts-pod-template-hash=76f5bddc69
example-rollout-76f5bddc69   5         5         3       29s   nginx        nginx:1.15.4   app=nginx,rollouts-pod-template-hash=76f5bddc69
example-rollout-76f5bddc69   5         5         4       30s   nginx        nginx:1.15.4   app=nginx,rollouts-pod-template-hash=76f5bddc69
example-rollout-76f5bddc69   5         5         5       32s   nginx        nginx:1.15.4   app=nginx,rollouts-pod-template-hash=76f5bddc69

$ kubectl patch rollout example-rollout --type merge -p '{"spec": {"template": { "spec": { "containers": [{"name": "nginx","image": "nginx:1.15.5"}]}}}}'

# 使用插件进行canary发布
$ kubectl argo rollouts promote example-rollout

# 再次查看
$ kubectl get replicaset -w -o wide
NAME                         DESIRED   CURRENT   READY   AGE     CONTAINERS   IMAGES         SELECTOR
example-rollout-66767759b    1         1         1       15s     nginx        nginx:1.15.5   app=nginx,rollouts-pod-template-hash=66767759b
example-rollout-76f5bddc69   5         5         5       2m42s   nginx        nginx:1.15.4   app=nginx,rollouts-pod-template-hash=76f5bddc69
example-rollout-66767759b    1         1         1       36s     nginx        nginx:1.15.5   app=nginx,rollouts-pod-template-hash=66767759b
example-rollout-76f5bddc69   4         5         5       3m4s    nginx        nginx:1.15.4   app=nginx,rollouts-pod-template-hash=76f5bddc69
example-rollout-76f5bddc69   4         5         5       3m4s    nginx        nginx:1.15.4   app=nginx,rollouts-pod-template-hash=76f5bddc69
example-rollout-76f5bddc69   4         4         4       3m4s    nginx        nginx:1.15.4   app=nginx,rollouts-pod-template-hash=76f5bddc69

# 查看资源情况
$ kubectl get all
NAME                                   READY   STATUS    RESTARTS   AGE
pod/example-rollout-66767759b-t2bnh    1/1     Running   0          2m38s
pod/example-rollout-76f5bddc69-4c4mr   1/1     Running   0          5m5s
pod/example-rollout-76f5bddc69-8gkbt   1/1     Running   0          5m5s
pod/example-rollout-76f5bddc69-n4wvq   1/1     Running   0          5m5s
pod/example-rollout-76f5bddc69-wbwgc   1/1     Running   0          5m5s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3h20m

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/example-rollout-66767759b    1         1         1       2m38s
replicaset.apps/example-rollout-76f5bddc69   4         4         4       5m5s

# 使用插件查看具体的执行详情
$ kubectl argo rollouts get rollout example-rollout
Name:            example-rollout
Namespace:       default
Status:          ◌ Progressing
Strategy:        Canary
  Step:          2/2
  SetWeight:     100
  ActualWeight:  100
Images:          nginx:1.15.4 (stable)
                 nginx:1.15.5 (canary)
Replicas:
  Desired:       5
  Current:       7
  Updated:       5
  Ready:         7
  Available:     5

NAME                                         KIND        STATUS         AGE    INFO
⟳ example-rollout                            Rollout     ◌ Progressing  7m29s
├──# revision:2
│  └──⧉ example-rollout-66767759b            ReplicaSet  ◌ Progressing  5m2s   canary
│     ├──□ example-rollout-66767759b-t2bnh   Pod         ✔ Running      5m2s   ready:1/1
│     ├──□ example-rollout-66767759b-nn88k   Pod         ✔ Running      50s    ready:1/1
│     ├──□ example-rollout-66767759b-vlxk7   Pod         ✔ Running      50s    ready:1/1
│     ├──□ example-rollout-66767759b-2hzx4   Pod         ✔ Running      18s    ready:1/1
│     └──□ example-rollout-66767759b-n4xr8   Pod         ✔ Running      18s    ready:1/1
└──# revision:1
   └──⧉ example-rollout-76f5bddc69           ReplicaSet  ✔ Healthy      7m29s  stable
      ├──□ example-rollout-76f5bddc69-8gkbt  Pod         ✔ Running      7m29s  ready:1/1
      └──□ example-rollout-76f5bddc69-wbwgc  Pod         ✔ Running      7m29s  ready:1/1
```

# 总结

```bash
# 重点在于以下字段
strategy:
    canary: 
      steps:
      - setWeight: 20
      - pause: {}

# 各个字段详细说明：https://argoproj.github.io/argo-rollouts/features/canary/

# 官网blog介绍：https://blog.argoproj.io/introducing-argo-rollouts-59dd0fad476c

# 大道至简！简单到只需要一个pod加几个CRD资源和一个yaml定义文件，就可以自动化实现蓝绿部署、金丝雀部署等。
```

