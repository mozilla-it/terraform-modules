variable "region" {
  default = "us-west-2"
}

variable "cluster_name" {}

variable "cluster_version" {
  default = "1.18"
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
  default     = {}
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

variable "worker_additional_security_group_ids" {
  description = "A list of additional security group ids to attach to worker instances"
  default     = []
}

variable "worker_create_cluster_primary_security_group_rules" {
  description = "Whether to create security group rules to allow communication between pods on workers and pods using the primary cluster security group."
  default     = false
}

variable "worker_create_security_group" {
  description = "Whether to create a security group for the workers or attach the workers to worker_security_group_id"
  default     = true
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

variable "metrics_server_settings" {
  description = "Metrics server settings"
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

variable "prometheus_settings" {
  description = "Customized or override prometheus helm chart values"
  type        = map(string)
  default     = {}
}

variable "prometheus_customization_settings" {
  description = "Customized or override prometheus helm chart values"
  type        = map(string)
  default     = {}
}

variable "configmapsecrets_settings" {
  description = "Customized or override configmapsecrets helm chart values"
  type        = map(string)
  default     = {}
}

variable "external_secrets_settings" {
  description = "Customize or override kubernetes_external_secrets helm chart values"
  type        = map(string)
  default     = {}
}

variable "external_secrets_prefixes" {
  description = "Set kubernetes_external_secrets role permissions to access AWS Secrets prefixes"
  type        = list(string)
  default     = ["*"]
}

variable "fluentd_papertrail_settings" {
  description = "Customize fluentd papertrail helm chart"
  type        = map(string)
  default     = {}
}

variable "admin_users_arn" {
  description = "List of ARNs to be mapped as a cluster global admins"
  type        = list(any)
  default     = []
}

variable "influxdb" {
  description = "A switch to set the default settings for influx"
  type        = bool
  default     = false
}
