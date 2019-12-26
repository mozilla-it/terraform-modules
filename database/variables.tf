variable "type" {
  default = "mysql"
}

variable "name" {}

variable "storage_gb" {
  default = 20
}

variable "storage_type" {
  default = "gp2"
}

variable "instance" {
  default = "db.t3.medium"
}

variable "environment" {}

variable "region" {
  default = "us-west-2"
}

variable "username" {
  default = ""
}

variable "version" {
  default = ""
}

variable "cost_center" {}

variable "project" {
  default = ""
}

variable "subnets" {
  default = []
}

variable "vpc_id" {}

variable "password_length" {
  default = 16
}

variable "publicly_accessible" {
  default = false
}

variable "multi_az" {
  default = true
}

variable "extra_tags" {
  default = {}
}
