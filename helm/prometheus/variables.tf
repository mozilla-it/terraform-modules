variable "enabled" {
  default = true
}

variable "create_namespace" {
  description = "Flag to create namespace or use existing namespace"
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Namespace to install prometheus helm chart"
  default     = "monitoring"
}

variable "cloud_provider" {
  description = "Cloud provider, accepted value is aws or gcp"
  default     = "aws"
}

variable "storage_class" {
  description = "A map of cloud provider and names of kubernetes storage classes"
  type        = map(string)
  default     = {}
}

variable "prometheus_helm_settings" {
  description = "Helm prometheus settings, see https://github.com/helm/charts/tree/master/stable/prometheus for details"
  type        = map(string)
  default     = {}
}

variable "influxdb" {
  description = "A switch to set the default settings for influx"
  type        = bool
  default     = false
}
