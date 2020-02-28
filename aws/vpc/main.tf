data "aws_availability_zones" "available" {
}

locals {
  az_placement = slice(
    data.aws_availability_zones.available.names,
    0,
    var.az_placement,
  )

  public_subnets = [
    for num in local.az_placement :
    cidrsubnet(
      var.vpc_cidr,
      4,
      index(local.az_placement, num) % length(local.az_placement)
    )
  ]

  private_subnets = [
    for num in local.az_placement :
    cidrsubnet(
      var.vpc_cidr,
      4,
      index(local.az_placement, num) % length(local.az_placement) + length(local.az_placement)
    )
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.24.0"

  create_vpc             = var.enable_vpc
  name                   = var.name
  azs                    = local.az_placement
  cidr                   = var.vpc_cidr
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  private_subnets        = local.private_subnets
  public_subnets         = local.public_subnets

  # DNS
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support   = var.vpc_enable_dns_support

  # VPC endpoint for S3
  enable_s3_endpoint = var.enable_s3_endpoint

  # VPC endpoint for DynamoDB
  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint

  tags = merge(var.tags, var.kubernetes_tags)

  vpc_tags = {
    Name = "${var.name}-vpc"
  }

  # We have no idea if the vpc will host an eks
  # cluster but we put this here anyway
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

