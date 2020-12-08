variable "domain_name" {
  default = "es-domain"
}

variable "es_version" {
  default = "7.1"
}

variable "es_instance_type" {
  default = "t2.small.elasticsearch"
}

variable "es_instance_count" {
  default = "1"
}

variable "ebs_volume_size" {
  default = "35"
}

variable "subnet_ids" {
  type    = list(any)
  default = []
}

variable "ingress_security_groups" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
