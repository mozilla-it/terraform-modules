variable "name" {}

variable "region" {}

variable "project_id" {}

variable "initial_node_count" { default = 1 }

variable "node_type" { default = "n1-standard-1" }

variable "http_load_balancing_disabled" { default = false }

variable "istio_disabled" { default = true }

variable "min_nodes" { default = 1 }

variable "max_nodes" { default = 5 }
