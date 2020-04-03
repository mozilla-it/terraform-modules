
resource "kubernetes_namespace" "velero" {
  count = var.enable_velero ? 1 : 0

  metadata {
    name = "velero"
  }
}

module "velero" {
  source              = "github.com/mozilla-it/terraform-modules//aws/velero-bucket?ref=master"
  cluster_name        = module.eks.cluster_id
  create_bucket       = var.enable_velero
  velero_sa_namespace = "velero"
  velero_sa_name      = "velero"
}
