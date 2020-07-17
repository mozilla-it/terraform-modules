variable "name" {}

variable "region" {}

variable "project_id" {}

variable "initial_node_count" { default = 1 }

variable "node_type" { default = "n1-standard-1" }

variable "http_load_balancing_disabled" { default = false }

variable "istio_disabled" { default = true }

variable "min_nodes_per_zone" { default = 1 }

variable "max_nodes_per_zone" { default = 5 }

variable "release_channel" { default = "REGULAR" }

variable "min_master_version" { default = "1.16" }
