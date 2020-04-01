variable "region" {
  default = "us-west-2"
}

variable "cluster_name" {}

variable "bucket_name" {
  default = "velero"
}

variable "backup_user" {
  default = "velero"
}

variable "create_user" {
  default = false
}

variable "create_role" {
  default = true
}

variable "velero_sa_namespace" {
  description = "Namespace of the velero service account"
  default     = "velero"
}

variable "velero_sa_name" {
  description = "Name of velero service account"
  default     = "velero"
}
