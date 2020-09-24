
variable "domain_name" {
  description = "Name of subdomain"
}

variable "delegation_set_id" {
  description = "Delegation set ID, we require this so create your apex domain with a delegation set id"
}
