
output "this_role_arn" {
  value = aws_iam_role.cloudwatch_fetch_metrics.arn
}

output "this_role_name" {
  value = aws_iam_role.cloudwatch_fetch_metrics.name
}
