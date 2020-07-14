Skaffold

安装

```bash
$ curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin

$ skaffold version
v1.12.0

```

使用

```bash
# https://github.com/GoogleContainerTools/skaffold/tree/master/examples/getting-started

# 只下载指定skaffold目录
$ mkdir work && cd work && \
    git init && \
    git remote add -f origin https://github.com/hbstarjason/Continuous-Deploy.git && \
    git config core.sparsecheckout true && \
    echo skaffold >> .git/info/sparse-checkout && \
    git pull origin master
$ cd skaffold && ls  
Dockerfile  k8s-pod.yaml  main.go  skaffold.yaml

$ skaffold dev
WARN[0000] Could not get minikube docker env, falling back to local docker daemon: getting minikube env: running [minikube docker-env --shellnone]
 - stdout: ""
 - stderr: "* 'none' driver does not support 'minikube docker-env' command\n"
 - cause: exit status 64
Listing files to watch...
 - hbstarjason/skaffold-demo
Generating tags...
 - hbstarjason/skaffold-demo -> hbstarjason/skaffold-demo:ee71542
Checking cache...
 - hbstarjason/skaffold-demo: Not found. Building
Found [minikube] context, using local docker daemon.
Building [hbstarjason/skaffold-demo]...
Sending build context to Docker daemon  3.072kB
Step 1/7 : FROM golang:1.12.9-alpine3.10 as builder
 ---> e0d646523991
Step 2/7 : COPY main.go .
 ---> 1fa40272d90e
Step 3/7 : RUN go build -o /app main.go
 ---> Running in 7a2c219e3deb
 ---> 896ea3edc2d7
Step 4/7 : FROM alpine:3.10
 ---> be4e4bea2c2e
Step 5/7 : ENV GOTRACEBACK=single
 ---> Using cache
 ---> 7550881d1554
Step 6/7 : CMD ["./app"]
 ---> Using cache
 ---> 2ac5fe0cb680
Step 7/7 : COPY --from=builder /app .
 ---> 85c2d8856e61
Successfully built 85c2d8856e61
Successfully tagged hbstarjason/skaffold-demo:ee71542
Tags used in deployment:
 - hbstarjason/skaffold-demo -> hbstarjason/skaffold-demo:85c2d8856e61767b5d4ba46fc22b6ed0dff26712cba53173fb4e66d59ddde42b
Starting deploy...
 - pod/skaffold-example created
Waiting for deployments to stabilize...
Deployments stabilized in 64.433541ms
Press Ctrl+C to exit
Watching for changes...
[skaffold-example] Hello world，Hello hbstarjason!
[skaffold-example] Hello world，Hello hbstarjason!
[skaffold-example] Hello world，Hello hbstarjason!
^CCleaning up...
 - pod "skaffold-example" deleted
Help improve Skaffold! Take a 10-second anonymous survey by running
   skaffold survey

# 编辑更改
$ vi main.go
package main

import (
        "fmt"
        "time"
)

func main() {
        for {
                fmt.Println("Hello world，Hello hbstarjason! This is Artifact!")

                time.Sleep(time.Second * 1)
        }
}

$ skaffold dev
…………
### 中间内容省略，可以看到自动输出
[skaffold-example] Hello world，Hello hbstarjason! This is Artifact!
[skaffold-example] Hello world，Hello hbstarjason! This is Artifact!
[skaffold-example] Hello world，Hello hbstarjason! This is Artifact!
[skaffold-example] Hello world，Hello hbstarjason! This is Artifact!
```

