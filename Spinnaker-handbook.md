# Spinnaker安装

### 一、安装方法总结

官网介绍的安装方法：https://www.spinnaker.io/setup/quickstart/

官网还有一个隐藏的All-in-one安装方法：

```
kubectl apply -f https://spinnaker.io/downloads/kubernetes/quick-install.yml

# 请放心，不修改yaml文件和配置相关的StorageClass，直接执行肯定是无法安装的！所谓的quick-install一点都不quick！
```

本人总结主要4种：

1、Full Install（官网地址：https://www.spinnaker.io/setup/install/ ）

2、Helm方式安装（地址：https://www.qikqiak.com/post/deploy-spinnaker-on-k8s/ ）

3、Operator方式安装

4、Docker-compose安装（地址：https://github.com/hbstarjason/spinnaker-local ）

点评：无论用何种方法，本人强烈推荐Full Install安装方法（不解释）。



### 二、Spinnaker架构与组件

1、架构，官网地址：https://www.spinnaker.io/reference/architecture/

2、组件



# Spinnaker使用

### 一、概念介绍

Project

Applications

Pipeline

Infrastructure

Cluster

Load balancers

Firewalls

Tasks

### 二、基础使用

通过UI直接创建k8s资源

1、新建应用（Create Application）

访问路径：Applications—>Actions下的Create Application

2、Clusters下创建服务器组（Create Server Group）

访问路径：Applications—>Infrastructure—>Clusters—>Create Server Group

3、Load balancers下创建负载均衡器（Create Load Balancer）

访问路径：Applications—>Infrastructure—>Load balancers—>Create Load Balancer

4、Firewalls下创建防火墙（Create Firewall）

访问路径：Applications—>Infrastructure—>Firewalls—>Create Firewall

### 三、进阶使用

通过设置pipeline创建k8s资源

### 四、项目实战

1、对接Jenkins Master，设置好Spinnaker pipeline Trigger，实现自动检测Jenkins Job完成后，自动触发自动化部署应用。

2、对接Image Registry，设置好Spinnaker Pipeline Trigger，实现自动检测Image Tag更新后，自动触发自动化部署应用。

### 五、高级项目实战

对接Prometheus与Kayenta组件，实现自动化金丝雀（Automated Canary）部署。
