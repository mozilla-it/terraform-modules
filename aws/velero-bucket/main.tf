
#TODO: I believe this should be done together with the EKS cluster
# creation.
resource "aws_s3_bucket" "this" {
  count  = var.create_bucket ? 1 : 0
  bucket = local.bucket_name
  acl    = "private"

  tags = merge({
    "Name"    = local.backup_bucket
    "Cluster" = var.cluster_name
    },
    local.tags
  )

}

# TODO: Find a way to logically set create_role have
# precedent over create_user. So if both create_role and create_user
# are set to true we just have create_role created and create_role doesn't
# get created
resource "aws_iam_user" "velero_iam_user" {
  count = var.create_bucket && var.create_user ? 1 : 0
  name  = local.backup_user

  tags = merge({
    Name    = local.backup_user
    Cluster = var.cluster_name

    },
    local.tags
  )
}

resource "aws_iam_access_key" "velero_iam_access_key" {
  count = var.create_bucket && var.create_user ? 1 : 0
  user  = aws_iam_user.backup_user.name
}

resource "aws_iam_user_policy" "velero_iam_user_policy" {
  count  = var.create_bucket && var.create_user ? 1 : 0
  name   = "${local.backup_user}-policy"
  user   = aws_iam_user.backup_user.name
  policy = data.aws_iam_policy_document.this.json
}

# Create an IAM role for service accounts which is the recommended
# way of doing this.

module "velero_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.6.0"
  create_role                   = var.create_role
  role_name                     = "${local.backup_user}-role"
  provider_url                  = replace(data.aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.this.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.velero_sa_namespace}:${var.velero_sa_name}"]
}

resource "aws_iam_policy" "velero_iam_role_policy" {
  count       = var.create_role ? 1 : 0
  name_prefix = "${local.backup_user}-policy"
  description = "EKS cluster-autoscaler policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.this.json
}
