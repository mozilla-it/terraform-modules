variable "region" {
  default = "us-west-2"
}

variable "repo_name" {
  description = "Name of ECR Repo"
  type        = string
}

variable "create_user" {
  description = "Create a user so that your CI system has permissions to push to the repo"
  default     = true
}

variable "ecr_expire" {
  description = "Creates a lifecycle rule to delete images after a certain number of days"
  default     = false
}

variable "ecr_expire_days" {
  default = "365"
}

variable "create_gha_role" {
  description = "Creates IAM role for Github Actions"
  default     = false
}

variable "gha_subs" {
  description = "The fully qualified OIDC subjects to be added to the role policy"
  type        = set(string)
  default     = []
}

variable "gha_sub_wildcards" {
  description = "The OIDC subject using wildcards to be added to the role policy"
  type        = set(string)
  default     = []
}
