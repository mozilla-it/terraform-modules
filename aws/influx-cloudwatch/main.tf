
resource "aws_iam_role" "cloudwatch_fetch_metrics" {
  name               = "cloudwatch_fetch_metrics"
  path               = "/itsre/"
  description        = "Allow a delegated account to assume role"
  assume_role_policy = data.aws_iam_policy_document.allow_assume_role.json

  tags = {
    Name      = "cloudwatch_fetch_metrics"
    Terraform = "true"
  }
}

data "aws_iam_policy_document" "allow_assume_role" {

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.delegated_account_id}:root"
      ]
    }
  }
}

resource "aws_iam_role_policy" "allow_fetch_cloudwatch_metrics" {
  name   = "allow_fetch_cloudwatch_metrics"
  role   = aws_iam_role.cloudwatch_fetch_metrics.id
  policy = data.aws_iam_policy_document.allow_fetch_cloudwatch_metrics.json
}

data "aws_iam_policy_document" "allow_fetch_cloudwatch_metrics" {

  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
    ]

    resources = ["*"]
  }
}

