variable "enabled" {
  default = true
}

variable "region" {
  default = "us-west-2"
}

variable "topic_name" {
  default = "cloudwatch-to-pd"
}

variable "display_name" {
  default = ""
}

variable "kms_master_key_id" {
  default = "alias/aws/sns"
}

variable "pagerduty_endpoint_parameter" {
  description = "SSM parameter store location for pagerduty endpoint"
  default     = "/cloudwatch_to_pagerduty/endpoint"
}

variable "pagerduty_endpoint_discover" {
  description = "Boolean value to decide if we want to discover the value of the pagerduty endpoint, default to true"
  default     = true
}

variable "pagerduty_endpoint" {
  description = "Option to provide pagerduty endpoint instead of forcing ssm to auto discover it, this value is a secret and must be set if pagerduty_endpoint_discover is set to false"
  default     = ""
}

variable "tags" {
  default = {}
  type    = map(string)
}
