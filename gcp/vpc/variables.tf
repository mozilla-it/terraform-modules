variable "project_id" {}

variable "regions" {
  description = "Regions to create subnetworks in"
  type        = list(string)
  default     = ["us-central1", "us-west1"]
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "main-vpc"
}

variable "routing_mode" {
  default = "REGIONAL"
}

variable "auto_create_subnetworks" {
  default = false
}

variable "base_cidr" {
  default = "10.10.0.0/16"
}

variable "cidr_bit" {
  default = "4"
}

variable "create_cloud_nat" {
  description = "Create cloud nat or not"
  default     = false
}

variable "cloud_nat_settings" {
  description = "List of cloud nat settings, refer to https://www.terraform.io/docs/providers/google/r/compute_router_nat.html for details"
  type        = map(string)
  default     = {}
}
