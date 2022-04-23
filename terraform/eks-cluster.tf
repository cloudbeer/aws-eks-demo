module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.20.5"

  cluster_name    = local.cluster_name
  cluster_version = "1.22"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true


  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }


  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]


  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # 需要部署 EC2 实例部署 coredns 等实例，
  eks_managed_node_groups = {
    xyz_shop = {
      desired_size = 3

      instance_types = ["t3.small"]
      labels = {
        xtype = "prod"
      }
      tags = {
        Owner       = "zhengwei xie"
        Environment = var.env
        Terraform   = "true"
      }
    }
  }


  # 创建 fargate 部署
  fargate_profiles = {
    xyz_shop = {
      name = "${local.cluster_name}-fargate"
      # subnet_ids = module.vpc.private_subnets
      selectors = [
        {
          namespace = "pdm"
        }
      ]

      tags = {
        Owner       = "zhengwei xie"
        Environment = var.env
        Terraform   = "true"
      }

      timeouts = {
        create = "5m"
        delete = "5m"
      }
    }
  }

}
resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
