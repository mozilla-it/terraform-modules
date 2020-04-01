locals {
  bucket_name = "${var.bucket_name}-${var.cluster_name}-${data.aws_caller_identity.current.account_id}"
  backup_user = "${var.backup_user}-${var.cluster_name}"

  tags = merge(
    {
      "Region"    = var.region
      "Service"   = "velero"
      "Terraform" = "true"
    },
    var.tags
  )

}
