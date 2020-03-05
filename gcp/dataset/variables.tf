variable "project" {
}

variable "name" {
}

variable "description" {
  default = ""
}

variable "mozilla_data_classification" {
}

variable "data_owner" {
}

variable "data_consumer" {
}

variable "data_source" {
}

variable "retention_period" {
  default = "forever"
}

variable "has_pii" {
  default = "false"
}

variable "location" {
  default = "US"
}

variable "owner_email" {
}

variable "extra_access" {
  default = []
}

variable "extra_labels" {
  default = {}
}

