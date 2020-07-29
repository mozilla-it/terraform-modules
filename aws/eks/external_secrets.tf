data "aws_iam_policy_document" "external_secrets" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      for path in var.external_secrets_secret_paths : "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${path}"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      data.aws_kms_alias.ssm.target_key_arn
    ]
  }
}

module "external_secrets" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.12.0"
  create_role                   = var.create_eks && local.cluster_features["external_secrets"]
  role_name                     = local.external_secrets_role_name
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = var.create_eks && local.cluster_features["external_secrets"] ? [aws_iam_policy.external_secrets[0].arn] : []
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:kubernetes-external-secrets"]
  tags                          = merge({ "Name" = local.external_secrets_role_name }, local.tags)
}

resource "aws_iam_policy" "external_secrets" {
  count       = var.create_eks && local.cluster_features["external_secrets"] ? 1 : 0
  name_prefix = "${var.cluster_name}-external-secrets-"
  path        = "/"
  description = "kubernetes-external-secrets policy for ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.external_secrets.json
}

data "aws_kms_alias" "ssm" {
  name = "alias/aws/ssm"
}
