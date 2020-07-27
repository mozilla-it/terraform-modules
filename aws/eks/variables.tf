variable "region" {
  default = "us-west-2"
}

variable "cluster_name" {}

variable "cluster_version" {
  default = "1.16"
}

variable "vpc_id" {}

variable "cluster_subnets" {}

variable "tags" {
  default = {}
}

variable "create_eks" {
  type    = bool
  default = true
}

variable "map_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_accounts" {
  type    = list(string)
  default = []
}

variable "node_groups" {
  description = "Map of map of node groups to create."
  type = map(object({
    desired_capacity = number,
    min_capacity     = number,
    max_capacity     = number,
    instance_type    = string,
    disk_size        = number,
    subnets          = list(string)
  }))
  default = {}
}

variable "node_groups_defaults" {
  description = "Map of values to be applied to all node groups"
  type        = any
  default     = {}
}

variable "worker_groups" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Configurations"
  default     = []
}

variable "enable_logging" {
  default = false
}

variable "log_retention" {
  default = "30"
}

variable "velero_bucket_name" {
  default = ""
}

variable "cluster_features" {
  description = "Map of features to enable on cluster, see local.tf for all feature flags"
  type        = map(string)
  default     = {}
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

variable "alb_ingress_settings" {
  description = "Customize or override alb ingress helm chart values"
  type        = map(string)
  default     = {}
}

variable "external_secrets_settings" {
  description = "Customize or override kubernetes_external_secrets helm chart values"
  type        = map(string)
  default     = {}
}

variable "external_secrets_secret_paths" {
  description = "Paths to allow the new AWS role to fecth secrets from"
  type        = list
  default     = ["*"]
}

