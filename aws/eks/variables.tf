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

variable "enable_velero" {
  default = true
}

variable "cluster_autoscaler_settings" {
  description = "Customize or override autoscaler helm chart values"
  type        = map(string)
  default     = {}
}

variable "reloader_settings" {
  description = "Customize reloader helm chart"
  type        = map(string)
  default     = {}
}

variable "velero_settings" {
  description = "Customize or override velero helm chart values"
  type        = map(string)
  default     = {}
}

variable "flux_helm_operator_settings" {
  description = "Customize or override flux helm operator chart values"
  type        = map(string)
  default     = {}
}

variable "flux_settings" {
  description = "Customize or override flux helm chart values"
  type        = map(string)
  default     = {}
}
