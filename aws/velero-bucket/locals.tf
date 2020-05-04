locals {

  bucket_name   = var.bucket_name == "" ? "velero-${var.cluster_name}-${data.aws_caller_identity.current.account_id}" : var.bucket_name
  backup_user   = var.backup_user == "" ? "velero-${var.cluster_name}" : var.backup_user
  kms_key_alias = var.kms_key_alias == "" ? "velero-${var.cluster_name}-${var.region}" : var.kms_key_alias

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
