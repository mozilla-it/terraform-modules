variable "project_id" {}

variable "name" {}

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
