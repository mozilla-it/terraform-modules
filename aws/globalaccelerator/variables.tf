variable "port_ranges" {
  type = list(object({
    from_port = number
    to_port   = number
  }))
  default = [
    {
      from_port = 80
      to_port   = 80
    },
    {
      from_port = 443
      to_port   = 443
    }
  ]
}

variable "nlb_arn" {
}

variable "health_check_port" {
  default = 80
}

variable "health_check_path" {
  default = "/"
}

variable "weight" {
  default = 128
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}

variable "environment" {
}

variable "cost_center" {
}

variable "ip_address_type" {
  default = "IPV4"
}

variable "flow_logs_enabled" {
  default = false
}

variable "protocol" {
  default = "TCP"
}

variable "client_affinity" {
  default = "SOURCE_IP"
}

variable "project" {
  default = ""
}
