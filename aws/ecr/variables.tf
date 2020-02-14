variable "region" {
  default = "us-west-2"
}

variable "repo_name" {}

variable "create_user" {
  default = true
}

variable "ecr_expire" {
  default = false
}

variable "ecr_expire_days" {
  default = "365"
}
