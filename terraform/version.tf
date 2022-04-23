terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }

  required_version = ">= 0.14"
}
