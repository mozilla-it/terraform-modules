output "role_id" {
  value = var.create_role ? aws_iam_role.this[0].arn : ""
}

output "role_arn" {
  value = var.create_role ? aws_iam_role.this[0].arn : ""
}
