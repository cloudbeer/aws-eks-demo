variable "env" {
  default = "prod"
}

variable "cidr" {
  default = "10.0"
}

locals {
  app_name     = "xyz-shop"
  region       = "ap-south-1"
  cluster_name = "${local.app_name}-eks-${var.env}"
}


provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name            = "${local.app_name}-vpc"
  cidr            = "${var.cidr}.0.0/16"
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["${var.cidr}.1.0/24", "${var.cidr}.2.0/24", "${var.cidr}.3.0/24", "${var.cidr}.128.0/24"]
  public_subnets  = ["${var.cidr}.4.0/24", "${var.cidr}.5.0/24", "${var.cidr}.6.0/24"]

  enable_nat_gateway                   = true
  single_nat_gateway                   = true
  enable_dns_hostnames                 = true
  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
