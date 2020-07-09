variable "idp_client_id" {
  default = "N7lULzWtfVUDGymwDs0yDEq6ZcwmFazj" #pragma: allowlist secret
}

variable "max_session_duration" {
  default = "43200" # 12 hours
}

variable "role_mapping" {
  type        = list(string)
  description = "The Mozilla LDAP or Mozillians group name to grant access to the roles"
}

variable "role_name" {
  description = "The name of the role you want created"
}

variable "policy_arn" {
  type        = list(string)
  description = "List of policy arns"
}

variable "create_role" {
  default     = true
  description = "Set to false to do not perform any action on module instanciation"
}
