
output "sns_topic_arn" {
  value = element(concat(aws_sns_topic.pagerduty.*.arn, [""]), 0)
}
