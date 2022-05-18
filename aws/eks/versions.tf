terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2"
    }
  }
}
