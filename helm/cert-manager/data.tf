
data "aws_eks_cluster" "this" {
  name = var.cluster_id
}

data "aws_route53_zone" "this" {
  count = var.cert_manager_enable_dns_challenge ? 1 : 0
  name  = var.route53_zone
}

data "aws_iam_policy_document" "cert_manager" {
  count = var.cert_manager_enable_dns_challenge ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.this.id}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZonesByName",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "route53:GetChange",
    ]
    resources = [
      "arn:aws:route53:::change/*"
    ]
  }
}
