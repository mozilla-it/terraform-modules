variable "region" {
  description = "The region where the Codebuild job will be created"
  default     = "us-west-2"
}
variable "github_head_ref" {
  description = "Git head reference used to determine which branches gets tbuilt"
}

variable "github_event_type" {
  description = "Event type which will trigger a deploy"
}

variable "github_repo" {
  description = "Adress of the Guthub repository where fetch the code from"
}

variable "project_name" {
  description = "Codebuild name"
}

variable "environment" {
}

variable "enable_webhook" {
  default = "true"
}

variable "ssm_parameters" {
  description = "Set to true if Codebuild will be relying on parameters stored on SSM. The location will be parameter/iam/<project_name>/<environment>"
  default     = "true"
}

variable "ssm_kms_key_id" {
  description = "If using SSM, the name of ID of the key used to encrypt the parameters"

  default = "alias/aws/ssm"
}
variable "enable_ecr" {
  default = "true"
}

variable "build_image" {
  default = "aws/codebuild/docker:17.09.0"
}

variable "source_version" {
  description = "Git reference to fetch code from."
  default     = ""
}

variable "fetch_submodules" {
  description = "Fetch submodules included in the repository"
  default     = "false"
}

variable "build_timeout" {
  description = "Timeout in minutes for the build to complete"
  default     = "5"
}
