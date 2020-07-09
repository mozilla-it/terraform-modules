data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/auth.mozilla.auth0.com/"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "auth.mozilla.auth0.com/:aud"
      values = [
        var.idp_client_id
      ]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "auth.mozilla.auth0.com/:amr"
      values   = var.role_mapping
    }
  }
}

locals {
  default_tags = {
    Service   = "MAWS"
    Terraform = "true"
  }
}

resource "aws_iam_role" "this" {
  count                = var.create_role ? 1 : 0
  name                 = var.role_name
  description          = "MAWS role for ${var.role_name}, managed by terraform"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    {
      "Name" = var.role_name
    },
    local.default_tags
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.create_role ? length(var.policy_arn) : 0
  role       = aws_iam_role.this[0].name
  policy_arn = var.policy_arn[count.index]
}
