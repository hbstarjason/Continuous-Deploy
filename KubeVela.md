# KubeVela

## 安装

```bash
# https://kubevela.io/#/en/install

## minikube
$ minikube start
$ minikube addons enable ingress

## Kind
$ cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml


$ helm repo add kubevela https://kubevelacharts.oss-cn-hangzhou.aliyuncs.com/core
$ helm repo update
$ kubectl create namespace vela-system 
$ helm install -n vela-system kubevela kubevela/vela-core
# helm install -n vela-system kubevela kubevela/vela-core --set installCertManager=true

```

## 使用

```bash
# https://kubevela.io/#/en/quick-start

$ curl -fsSl https://kubevela.io/install.sh | bash

$ vela up -f https://raw.githubusercontent.com/oam-dev/kubevela/master/docs/examples/vela.yaml

$ vela status first-vela-app

$ curl -H "Host:testsvc.example.com" http://localhost/

```

