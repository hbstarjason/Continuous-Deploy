# kaniko-demo

## How to Build Containers in a Kubernetes Cluster With Kaniko
### Automate container builds within K8s without a Docker daemon

```bash
# https://github.com/GoogleContainerTools/kaniko#running-kaniko-in-a-kubernetes-cluster

# 变量替换成自己的
$ export GHUSER="hbstarjason"
$ export GHREPO="Continuous-Deploy"
$ export DOCKERSERVER="https://index.docker.io/v1/"
$ export DOCKERREPO="hbstarjason"
$ export DOCKERPASS="<YOUR_DOCKER_PASS"
$ export DOCKEREMAIL="<YOUR_DOCKER_EMAIL>"

$ kubectl create secret docker-registry hbstarjason \
    --docker-server=${DOCKERSERVER} \
    --docker-username=${DOCKERREPO} \
	--docker-password=${DOCKERPASS} \
	--docker-email=${DOCKEREMAIL}

$ git clone https://github.com/hbstarjason/Continuous-Deploy && cd Continuous-Deploy/kaniko

$ sed -i "s/GHUSER/${GHUSER}/g" build.yaml
$ sed -i "s/GHREPO/${GHREPO}/g" build.yaml
$ sed -i "s/<repo>/${DOCKERREPO}/g" build.yaml
$ sed -i "s/<tag>/nginx:v1/g" build.yaml

###### 已将原始的gcr.io镜像同步至github

### 此处需要特别注意build.yaml里的Dockerfile存放目录
$ sed -i "s/v_x/1/g" Dockerfile

$ sed -i "s/<repo>/${DOCKERREPO}/g" nginx-deployment.yaml
$ sed -i "s/<tag>/nginx:v1/g" nginx-deployment.yaml


$ kubectl apply -f build.yaml
job.batch/kaniko created

$ kubectl get pod
NAME           READY   STATUS    RESTARTS   AGE
kaniko-nlg7j   1/1     Running   0          8s

$ kubectl  logs -f  kaniko-nlg7j
Enumerating objects: 242, done.
Counting objects: 100% (242/242), done.
Compressing objects: 100% (211/211), done.
Total 242 (delta 84), reused 142 (delta 27), pack-reused 0
E0729 08:10:33.301808       1 aws_credentials.go:77] while getting AWS credentials NoCredentialProviders: no valid providers in chain. Deprecated.
        For verbose messaging see aws.Config.CredentialsChainVerboseErrors
INFO[0030] Retrieving image manifest nginx:alpine
INFO[0032] Retrieving image manifest nginx:alpine
INFO[0034] Built cross stage deps: map[]
INFO[0034] Retrieving image manifest nginx:alpine
INFO[0036] Retrieving image manifest nginx:alpine
INFO[0038] Executing 0 build triggers
INFO[0038] Unpacking rootfs as cmd RUN echo 'This is version v_x' > /usr/share/nginx/html/index.html requires it.
INFO[0040] RUN echo 'This is version v_x' > /usr/share/nginx/html/index.html
INFO[0040] Taking snapshot of full filesystem...
INFO[0040] cmd: /bin/sh
INFO[0040] args: [-c echo 'This is version v_x' > /usr/share/nginx/html/index.html]
INFO[0040] Running: [/bin/sh -c echo 'This is version v_x' > /usr/share/nginx/html/index.html]
INFO[0040] Taking snapshot of full filesystem...

### 可以在仓库里看到已经有镜像了
$ kubectl get po
NAME           READY   STATUS      RESTARTS   AGE
kaniko-nlg7j   0/1     Completed   0          9m53s
```



## Running-kaniko-in-Docker

```bash
# https://github.com/GoogleContainerTools/kaniko#running-kaniko-in-docker

# 
$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to createone.
Username: hbstarjason
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

$ ls $HOME/.docker/
config.json

#### 已自动生成dockerhub的认证信息

$ git clone https://github.com/hbstarjason/Continuous-Deploy && cd Continuous-Deploy/kaniko

$ docker run --name kaniko \
    -v $HOME/.docker/:/kaniko/.docker \
    -v $PWD:/workspace \
    hbstarjason/executor:v0.24.0 \
    --dockerfile Dockerfile \
    --destination hbstarjason/nginx:v3 \
    --context /workspace
# --no-push
# --cache

# 原镜像gcr.io/kaniko-project/executor:v0.24.0已同步至hbstarjason/executor:v0.24.0
# 执行完毕后，可以直接在镜像仓库里看到对应的镜像了，默认镜像本地不会保存。


```

