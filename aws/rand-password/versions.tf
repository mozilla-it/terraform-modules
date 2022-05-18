terraform {
  required_version = ">= 0.13"
  required_providers {

    random = {
      source  = "hashicorp/random"
      version = "> 3"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "> 3"
    }
  }
}
