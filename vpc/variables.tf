variable "region" {
  default = "us-west-2"
}

variable "enable_vpc" {
  default = true
}

variable "name" {}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "az_placement" {
  description = "How many AZs do you want to place subnets in"
  default     = "3"
}

variable "enable_nat_gateway" {
  default = true
}

variable "single_nat_gateway" {
  default = true
}

variable "one_nat_gateway_per_az" {
  default = true
}

variable "vpc_enable_dns_hostnames" {
  default = true
}

variable "vpc_enable_dns_support" {
  default = true
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "kubernetes_tags" {
  default = {}
  type    = "map"
}

variable "newbits" {
  default = "4"
}

variable "enable_s3_endpoint" {
  default = true
}

variable "enable_dynamodb_endpoint" {
  default = true
}
