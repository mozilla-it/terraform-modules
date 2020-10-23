
output "cert_manager_role_arn" {
  value = var.cert_manager_enable_dns_challenge ? module.cert_manager_role.this_iam_role_arn : ""
}
