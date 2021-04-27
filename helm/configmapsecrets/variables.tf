variable "enabled" {
  default = true
}

variable "create_namespace" {
  description = "Flag to create namespace or use existing namespace"
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Namespace to install configmapsecrets helm chart"
  default     = "configmapsecrets"
}

variable "configmapsecrets_helm_settings" {
  description = "Helm configmapsecrets settings, we are custom building the helm chart. see https://github.com/mozilla-it/helm-charts/blob/main/charts/configmapsecrets/values.yaml for details"
  type        = map(string)
  default     = {}
}
