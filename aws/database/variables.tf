variable "type" {
  default = "mysql"
}

variable "name" {
}

variable "identifier" {
  default = ""
}

variable "storage_gb" {
  default = 20
}

variable "storage_type" {
  default = "gp2"
}

variable "instance" {
  default = "db.t3.medium"
}

variable "instance_replica" {
  default = "db.t3.medium"
}

variable "environment" {
}

variable "region" {
  default = "us-west-2"
}

variable "username" {
  default = ""
}

variable "db_version" {
  default = ""
}

variable "cost_center" {
}

variable "project" {
  default = ""
}

variable "subnets" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
}

variable "password_length" {
  default = 16
}

variable "publicly_accessible" {
  default = false
}

variable "multi_az" {
  default = true
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}

variable "ca_cert_identifier" {
  default = "rds-ca-2019"
}

variable "apply_immediately" {
  default = "false"
}

variable "parameter_group_name" {
  default = ""
}

variable "backup_retention_period" {
  default = 0
}

variable "replica_enabled" {
  description = "Set to true for creating a Read Only replica of the main DB"
  default     = "false"
}

variable "performance_insights_enabled" {
  description = "Enables RDS performance insights feature"
  default     = "false"
}

variable "performance_insights_retention" {
  description = "The amount of days to retain performance insights"
  default     = "7"
}

variable "replica_performance_insights_enabled" {
  description = "Enables RDS performance insights feature for the DB replica"
  default     = "false"
}

variable "replica_performance_insights_retention" {
  description = "The amount of days to retain performance insights for the DB replica"
  default     = "7"
}
