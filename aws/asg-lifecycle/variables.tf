variable "region" {
  default = "us-west-2"
}

variable "name" {
}

variable "lifecycled_log_group" {
  default = "/aws/lifecycled"
}

variable "retention_log_days" {
  default = "7"
}

variable "worker_asg" {
  type = list(string)
}

variable "worker_asg_count" {
}

variable "worker_iam_role" {
}

