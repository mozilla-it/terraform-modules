locals {

  bucket_name_default = "${var.bucket_name}-${var.cluster_name}-${var.region}-${data.aws_caller_identity.current.account_id}"
  backup_user_default = "${var.backup_user}-${var.cluster_name}-${var.region}"

  bucket_name = merge(local.bucket_name_default, var.bucket_name)
  backup_user = merge(local.backup_user_default, var.backup_user)

  tags = merge(
    {
      "Cluster"   = var.cluster_name
      "Region"    = var.region
      "Service"   = "velero"
      "Terraform" = "true"
    },
    var.tags
  )

}
