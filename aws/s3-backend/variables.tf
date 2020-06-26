variable "backend_dynamodb_table" {
  description = "Name of the dynamodb table used to lock Terraform's state"
  type        = string
  default     = ""
}

variable "backend_bucket" {
  description = "Name of bucket where Terraform's state is stored"
  type        = string
  default     = ""
}

variable "backend_key" {
  description = "Name of the key that keeps Terraform's state"
  type        = string
  default     = ""
}

variable "read_capacity" {
  description = "Read capacity for the DynamoDB table"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity for the DynamoDB table"
  type        = number
  default     = 5
}

variable "region" {
  description = "Name of the region for the S3 bucket"
  type        = string
  default     = ""
}

variable "tags" {
  description = "AWS tags"
  type        = map(string)
  default     = {}
}
