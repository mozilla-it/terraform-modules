variable "name" {
}

variable "ver" {
  default = "POSTGRES_9_6"
}

variable "tier" {
  default = "db-f1-micro"
}

variable "network" {
  default = "0.0.0.0/0"
}

variable "authorized_ips" {
  type = list(object({
    name     = string
    ip_range = string
  }))
  default = []
}

variable "database" {
}

variable "username" {
}

variable "backups_enabled" {
  default = false
}
