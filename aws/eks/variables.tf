variable "region" {
  default = "us-west-2"
}

variable "cluster_name" {}

variable "cluster_version" {
  default = "1.14"
}

variable "vpc_id" {}

variable "cluster_subnets" {}

variable "tags" {
  default = {}
}

variable "map_roles" {
  default = []
}

variable "map_users" {
  default = []
}

variable "map_accounts" {
  default = []
}

variable "node_groups" {
  default = {}
}

variable "worker_groups" {
  default = {}
}

variable "enable_flux" {
  default = false
}

variable "enable_logging" {
  default = false
}

variable "log_retention" {
  default = "30"
}
