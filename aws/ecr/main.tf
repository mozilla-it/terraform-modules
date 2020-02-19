locals {
  ecr_expire      = var.ecr_expire ? 1 : 0
  ecr_create_user = var.create_user ? 1 : 0
}

resource "aws_ecr_repository" "this" {
  name = var.repo_name

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name      = var.repo_name
    Region    = var.region
    Terraform = "true"
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = local.ecr_expire
  repository = aws_ecr_repository.this.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged image older than ${var.ecr_expire_days} days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${var.ecr_expire_days}
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

resource "aws_iam_user" "this" {
  count = local.ecr_create_user
  name  = "ecr-${var.repo_name}-iam"

  tags = {
    Name      = "ecr-${var.repo_name}-iam"
    Terraform = "true"
  }
}

resource "aws_iam_access_key" "this" {
  count = local.ecr_create_user
  user  = aws_iam_user.this[0].name
}

## TODO: Instead of giving the user direct policies, we should instead use a role
resource "aws_iam_user_policy" "this" {
  count  = local.ecr_create_user
  name   = "ecr-${var.repo_name}-access"
  user   = aws_iam_user.this[0].name
  policy = data.aws_iam_policy_document.repo_access.json
}

data "aws_iam_policy_document" "repo_access" {
  statement {
    sid    = "GetAuthorizationToken"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowPush"
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]

    resources = [
      aws_ecr_repository.this.arn,
    ]
  }
}
