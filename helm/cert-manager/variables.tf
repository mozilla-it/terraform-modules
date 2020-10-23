variable "enabled" {
  type    = bool
  default = true
}

variable "cluster_id" {}

variable "environment" {
  default = "stage"
}

variable "cert_manager_version" {
  default = ""
}

variable "cert_manager_settings" {
  type    = map(string)
  default = {}
}

variable "cert_manager_enable_dns_challenge" {
  type    = bool
  default = false
}

variable "route53_zone" {
  default = ""
}

variable "kubeconfig" {}

variable "null_resource_interpreter" {
  description = "Helpful feature for humans who has no bash shell"
  default     = ["/bin/bash", "-c"]
}
