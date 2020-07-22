variable "region" {
  default = "us-central1"
}

variable "environment" {
  default = ""
}

variable "kubernetes_version" {
  description = "Version of kubernetes to setup"
  default     = "latest"
}

variable "release_channel" {
  type        = string
  description = "(Beta) The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  default     = null
}

variable "costcenter" {}

variable "project_id" {}

variable "name" {}

variable "network" {}

variable "subnetwork" {}

variable "ip_range_pods" {
  default = ""
}

variable "ip_range_services" {
  default = ""
}

variable "regional" {
  description = "Configure cluster as a regional or zonal cluster"
  default     = false
}

variable "cluster_addons" {
  description = "List of addons to install on cluster"
  type        = map(string)
  default     = {}
}

variable "cluster_features" {
  description = "Additional packages to install via helm onto cluster"
  type        = map(string)
  default     = {}
}

variable "node_pools" {
  description = "List of maps containing node pools"
  type        = list(map(string))
}

variable "velero_settings" {
  description = "Settings for velero helm chart"
  type        = map(string)
  default     = {}
}
