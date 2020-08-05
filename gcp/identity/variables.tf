variable "project_id" {}

variable "name" {
  description = "Name of the google service account to create, optionally if `var.create_ksa` is set to `true` then the ksa will be the same as the gsa"
}

variable "gke_cluster" {}

variable "namespace" {
  description = "Namespace SA will be created in"
  default     = "default"
}

variable "enabled" {
  default = true
  type    = bool
}

variable "create_ksa" {
  description = "Create kubernetes service account instead of using existing one, KSA will be named using `var.name`"
  type        = bool
  default     = true
}

variable "additional_permissions" {
  description = "Option to add additonal `secretmanager.secretAccessor` and `logging.logWriter` permission to SA"
  type        = bool
  default     = true
}

variable "ksa_name" {
  description = "Name of kubernetes service account, only configure this value if `var.create_ksa` is set to false"
  default     = ""
}
