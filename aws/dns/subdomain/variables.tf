
variable "domain" {
  description = "Name of subdomain"
}

variable "nsrecord_ttl" {
  description = "TTL of NS record for subdomain"
  default     = "30"
}

variable "apex_zone_id" {
  description = "Zone id of apex domain"
}

variable "nameservers" {
  description = "Nameservers to use for ns record"
  type        = list(string)
}
