terraform {
  required_version = ">= 1.3"
  cloud {
    organization = "lhtran"

    workspaces {
      name = "aws-eks-gatewise"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.3"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.14"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7"
    }
  }
}