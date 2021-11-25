locals {
  ecr_expire          = var.ecr_expire ? 1 : 0
  ecr_create_user     = var.create_user ? 1 : 0
  ecr_create_gha_role = var.create_gha_role ? 1 : 0
}

# ECR
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
        "tagStatus": "any",
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

# IAM user
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

resource "aws_iam_user_policy" "this" {
  count  = local.ecr_create_user
  name   = "ecr-${var.repo_name}-access"
  user   = aws_iam_user.this[0].name
  policy = data.aws_iam_policy_document.repo_access.json
}


# Github Actions IAM Role
resource "aws_iam_policy" "this" {
  count = local.ecr_create_gha_role
  name  = "ecr-${var.repo_name}-iam"

  policy = data.aws_iam_policy_document.repo_access.json

  tags = {
    Name      = "ecr-${var.repo_name}-iam"
    Terraform = "true"
  }
}

module "iam_assumable_role_github_actions" {
  count  = local.ecr_create_gha_role
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role = true

  role_name = "ecr-${var.repo_name}-iam"

  provider_url = "https://token.actions.githubusercontent.com"

  role_policy_arns = [
    aws_iam_policy.this[0].arn
  ]

  oidc_fully_qualified_subjects = var.gha_subs
  oidc_subjects_with_wildcards  = var.gha_sub_wildcards

  tags = {
    Name      = "ecr-${var.repo_name}-iam"
    Terraform = "true"
  }
}
