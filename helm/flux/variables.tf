variable "flux_helm_operator_settings" {
  type    = any
  default = {}
}

variable "flux_settings" {
  type    = any
  default = {}
}

variable "enable_flux" {
  default = true
}

variable "enable_flux_helm_operator" {
  default = true
}
