data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {
  count = var.create_bucket ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]

    resources = [
      "${aws_s3_bucket.this[0].arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.this[0].arn
    ]
  }
  statement {
    sid = "kmskeys"

    actions = [
      "kms:ListKeys",
      "kms:ListAliases",
    ]

    resources = ["*"]
  }

  statement {
    sid = "kms"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = [
      aws_kms_key.this.arn,
    ]
  }
}

data "aws_eks_cluster" "this" {
  count = var.create_bucket && var.create_role ? 1 : 0
  name  = var.cluster_name
}

