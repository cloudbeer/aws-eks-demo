# 使用 AWS EKS 部署微服务应用

## 开通 eks 资源

使用如下的脚本创建资源：

```shell
cd terraform

terraform apply
```

- 上述脚本创建了 VPC 网络，私有子网和公有子网

- 创建了一个 EKS，包含了 3 台 t3.small 机型的 EC2，并开通了 API 外网访问。（实际过程中，请不要开放公网）

- 创建了一个 Fargate 配置文件，由于部署业务 Pod，后面 pdm 命名空间的服务将会部署到 fargate pod， xyz 命名空间的 mall 服务仍将部署在 ec2。



大约需要 10 分钟，所有的资源会创建完成。

完成之后执行：

```shell
aws eks update-kubeconfig --region ap-south-1 --name xyz-shop-eks-prod
```

此命令会覆盖 ~/.kube/config 文件。

## 开通 ECR

创建仓库： `xyz-shop/review`, `xyz-shop/product`


在本地登录仓库：

``` shell
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 88888888888.dkr.ecr.ap-south-1.amazonaws.com
```


## 部署应用