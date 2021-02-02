data "aws_caller_identity" "current" {
}

data "aws_kms_key" "ssm" {
  key_id = var.ssm_kms_key_id
}

#---
# CodeBuild and GitHub webhooks
#---

resource "aws_codebuild_webhook" "webhook" {
  count        = var.enable_webhook ? 1 : 0
  project_name = aws_codebuild_project.build.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = var.github_event_type
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.github_head_ref
    }
  }
}

resource "aws_codebuild_project" "build" {
  name          = "${var.project_name}-${var.environment}"
  description   = "CI pipeline for ${var.project_name}-${var.environment}"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = var.build_image
    type            = "LINUX_CONTAINER"
    privileged_mode = "true"

    environment_variable {
      name = "DOCKER_REPO"
      value = coalesce(
        join("", aws_ecr_repository.registry.*.repository_url),
        "UNUSED",
      )
    }

    environment_variable {
      name  = "ENV"
      value = var.environment
    }
  }

  source {
    type     = "GITHUB"
    location = var.github_repo

    git_submodules_config {
      fetch_submodules = var.fetch_submodules
    }
  }

  source_version = var.source_version

  tags = {
    App         = var.project_name
    Environment = var.environment
    Name        = var.project_name
    Region      = var.region
    Terraform   = true
  }
}

#---
# IAM configuration
#---

resource "aws_iam_role" "codebuild" {
  name               = "${var.project_name}-codebuild-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.codebuild-assume-role.json
}

data "aws_iam_policy_document" "codebuild-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name = "${var.project_name}-codebuild-${var.environment}"
  role = aws_iam_role.codebuild.id

  policy = data.aws_iam_policy_document.codebuild.json
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
  statement {
    resources = ["*"]
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ecr:*"
    ]
  }
}

data "aws_iam_policy_document" "codebuild-ssm" {
  statement {
    actions   = ["ssm:GetParameter*"]
    resources = ["arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/iam/${var.project_name}/${var.environment}/*"]
  }
  statement {
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/${data.aws_kms_key.ssm.id}"]
  }
}

resource "aws_iam_role_policy" "codebuild-ssm" {
  count = var.ssm_parameters ? 1 : 0
  name  = "${var.project_name}-codebuild-ssm-${var.environment}"
  role  = aws_iam_role.codebuild.id

  policy = data.aws_iam_policy_document.codebuild-ssm.json
}

#---
# ECR
#---

resource "aws_ecr_repository" "registry" {
  count = var.enable_ecr ? 1 : 0
  name  = "${var.project_name}/${var.environment}"
}

resource "aws_ecr_repository_policy" "registrypolicy" {
  count      = var.enable_ecr ? 1 : 0
  repository = aws_ecr_repository.registry[0].name

  policy = data.aws_iam_policy_document.codebuild-ecr.json
}

data "aws_iam_policy_document" "codebuild-ecr" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.codebuild.arn]
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy"
    ]
  }
}
