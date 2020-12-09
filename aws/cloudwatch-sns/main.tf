
locals {
  topic_name = var.display_name == "" ? var.topic_name : var.display_name

  pagerduty_endpoint = var.pagerduty_endpoint_discover ? data.aws_ssm_parameter.pagerduty_endpoint[0].value : var.pagerduty_endpoint

  default_tags = {
    "Region"    = var.region
    "Terraform" = "true"
  }
}

data "aws_ssm_parameter" "pagerduty_endpoint" {
  count = var.pagerduty_endpoint_discover ? 1 : 0
  name  = var.pagerduty_endpoint_parameter
}

resource "aws_sns_topic" "pagerduty" {
  count             = var.enabled ? 1 : 0
  name              = var.topic_name
  display_name      = local.topic_name
  kms_master_key_id = var.kms_master_key_id
  tags              = merge({ "Name" = var.topic_name }, local.default_tags)
}

resource "aws_sns_topic_subscription" "pagerduty" {
  count                  = var.enabled ? 1 : 0
  endpoint               = local.pagerduty_endpoint
  endpoint_auto_confirms = true
  protocol               = "https"
  topic_arn              = aws_sns_topic.pagerduty[0].arn
}
