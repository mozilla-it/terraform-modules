output "sns_topic_arn" {
  value = aws_sns_topic.main.arn
}

output "asg_lifecycle_role" {
  value = aws_iam_role.lifecycle_hook.name
}

output "asg_lifecycle_role_arn" {
  value = aws_iam_role.lifecycle_hook.arn
}

