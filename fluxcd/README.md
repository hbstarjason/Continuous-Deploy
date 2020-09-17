FluxCD+Kaniko

```bash
# https://docs.fluxcd.io/en/latest/references/fluxctl/
# Install fluxctl
$ wget https://github.com/fluxcd/flux/releases/download/1.20.2/fluxctl_linux_amd64 && \
  mv fluxctl_linux_amd64 /usr/bin/fluxctl && \
  sudo chmod +x /usr/bin/fluxctl && \
  fluxctl version

$ export GHUSER="hbstarjason"
$ export GHREPO="Continuous-Deploy"

$ kubectl create ns flux

$ fluxctl install \
--git-user=${GHUSER} \
--git-email=${GHUSER}@users.noreply.github.com \
--git-url=git@github.com:${GHUSER}/${GHREPO}.git \
--git-path=fluxcd \
--namespace=flux | kubectl apply -f -

$ kubectl -n flux rollout status deployment/flux
deployment "flux" successfully rolled out

$ kubectl get all  -n flux

$ fluxctl identity --k8s-fwd-ns flux 

### 添加key，选上“Allow write access”
# https://github.com/hbstarjason/Continuous-Deploy/settings/keys

# 变量替换成自己的
$ export DOCKERSERVER="https://index.docker.io/v1/"
$ export DOCKERREPO="hbstarjason"
$ export DOCKERPASS="<YOUR_DOCKER_PASS"
$ export DOCKEREMAIL="<YOUR_DOCKER_EMAIL>"

$ kubectl create secret docker-registry hbstarjason \
    --docker-server=${DOCKERSERVER} \
    --docker-username=${DOCKERREPO} \
    --docker-password=${DOCKERPASS} \
    --docker-email=${DOCKEREMAIL}

$ fluxctl sync --k8s-fwd-ns flux


$ sed -i "s/nginx:v4/nginx:v5/g" fluxcd/nginx-deployment.yaml

$ git add --all
$ git commit -m 'Updated version to v5'
$ git push origin master




```

