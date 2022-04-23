# Deploy micro-services on Amazon EKS 

This demo show how to deploy micro-services system on Amazon EKS. 

It includes:

- Create EKS (Managed EC2 and fargate) instance, use terraform.  See folder ./terraform

- 3 services source code:
    - mall (reactjs), frontend SPA app, folder ./src/mall
    - product (java), provide product list and detail restful api, folder ./src/product
    - review (php), provide product review restful api, folder ./src/review

- product and review will deploy to Fargate severless pod.


## Step 1. Create EKS and its dependencies.

```shell
cd terraform
terraform apply
```
- Create a VPC and 6 subnets. Apps will be deployed in 3 private subnets 

- Create an EKS instance, a manged EC2 group with 3 t3.small instances, a Fargate profile, review and product will be doployed to Fargate.

- Please note that EKS API server is public in this demo. Use Bastion instances access EKS is suggusted.

- These services will be created too: NAT gateway, security group,.

After terraform scripts finished, Export a kubeconfig file to ~/.kube/config on your local machine.

```
aws eks update-kubeconfig --region ap-south-1 --name xyz-shop-eks-prod
```
- Please change region and name as same as your EKS enviroment.


## Step 2. Create ECR instacne

Create ECR instance in AWS web console. It is simple.

create 2 repos： `xyz-shop/review`, `xyz-shop/product`


Login to ECR on your local machine：

```shell
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 88888888888.dkr.ecr.ap-south-1.amazonaws.com
```


## Step 3. Build Docker images




--- 

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

```shell
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 88888888888.dkr.ecr.ap-south-1.amazonaws.com
```


## 部署应用