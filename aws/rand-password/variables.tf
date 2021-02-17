variable "enabled" {
  default = true
}

variable "environment" {}

variable "service_name" {
  description = "Name of service"
}

variable "keyname" {
  description = "Keyname for password"
  default     = "password"
}

variable "password_config" {
  description = "Password config map"
  type        = map(string)
  default     = {}
}

variable "password_store" {
  description = "The password storing method, can use ssm or secretsmanager"
  type        = string

  validation {
    condition     = can(regex("ssm|secretsmanager", var.password_store))
    error_message = "Error: Only ssm or secretsmanager is allowed as an input."
  }
}
