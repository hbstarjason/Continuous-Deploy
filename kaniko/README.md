# kaniko-demo

## How to Build Containers in a Kubernetes Cluster With Kaniko
### Automate container builds within K8s without a Docker daemon

```bash
# https://github.com/GoogleContainerTools/kaniko#running-kaniko-in-a-kubernetes-cluster

# 变量替换成自己的
$ export GHUSER="<YOUR_GITHUB_USER>"
$ export GHREPO="<YOUR_GITHUB_REPO>"
$ export DOCKERREPO="<YOUR_DOCKER_REPOSITORY>"
$ export DOCKEREMAIL="<YOUR_DOCKER_EMAIL>"

$ kubectl create secret docker-registry hbstarjason \
    --docker-server=<DOCKERREPO> \
    --docker-username=<GHUSER> \
	--docker-password=<GHREPO> \
	--docker-email=<DOCKEREMAIL>

$ sed -i "s/GHUSER/${GHUSER}/g" build.yaml
$ sed -i "s/GHREPO/${GHREPO}/g" build.yaml
$ sed -i "s/<repo>/${DOCKERREPO}/g" build.yaml
$ sed -i "s/<tag>/nginx:v1/g" build.yaml

$ sed -i "s/v_x/3/g" Dockerfile

$ sed -i "s/<repo>/${DOCKERREPO}/g" nginx-deployment.yaml
$ sed -i "s/<tag>/nginx:v2/g" nginx-deployment.yaml


$ kubectl apply -f build.yaml

$ kubectl get pod

$ kubectl logs kaniko-jztr6 -f

### 可以在仓库里看到已经有镜像了
```


