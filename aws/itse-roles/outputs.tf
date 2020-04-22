output "admin_role_arn" {
  value = aws_iam_role.admin_role.arn
}

output "readonly_role_arn" {
  value = aws_iam_role.readonly_role.arn
}

output "poweruser_role_arn" {
  value = aws_iam_role.poweruser_role.arn
}
