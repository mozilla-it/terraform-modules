variable "metric_kind" {
  default = "DELTA"
}

variable "value_type" {
  default = "INT64"
}

variable "name" {}

variable "error_code" {}

variable "project" {}

variable "alert_threshold" {
  default = "0"
}

variable "description" {
  default = ""
}

variable "severity" {
  default = "HIGH"
}

variable "notification_path" {
  default = "email"
}

variable "target" {
  default = "afrank+noreply@mozilla.com"
}

variable "aligner" {
  default = "ALIGN_MAX"
}

variable "alignment_period" {
  default = "60s"
}
