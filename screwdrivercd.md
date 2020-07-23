安装：

```bash
# https://screwdriver.cd
# https://docs.screwdriver.cd/cluster-management/running-locally

$ python <(curl -L https://git.io/sd-in-a-box)
```

安装流程：

1、根据提示，先去github上去创建OAuth。

2、然后执行python脚本，创建带有key的docker-compose.yaml文件，并自动执行安装。



>注意：python脚本只能获取到本地的local的Ip地址，无法获取道公网IP地址。
>
>利用脚本自动生成docker-compose.yaml后，手动更改为公网IP地址。



使用：

```bash
# 访问ui，使用github授权登录。
# 创建pipeline，填入https://github.com/hbstarjason/screwdriver-test
# 点start，启动pipeline。

提示：
 (HTTP code 404) no such container - No such image: screwdrivercd/launcher:stable
 
然后看到pipeline无限的等待中…… 
```



吐槽：（2020-7-23）

- 官网大幅的team头像而已，没什么实质性的介绍。
- 安装命令只是放在首页，并没有放进文档里，在文档里找了半天都找不到如何安装。
- 安装还算简单，只是费劲了一点。但是，只找到docker方式安装，没看到怎么安装到k8s上。
- 安装完成后只有一个界面而已，官网的quickstart，都跑不起来。官网的实例仓库都是3-4年前建立的。
- 感觉这货就是一个半残品，真怀疑这货是怎么进入CDF基金会的！？？？