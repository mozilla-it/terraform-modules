
resource "kubernetes_namespace" "velero" {
  count = var.create_eks && local.cluster_features["velero"] ? 1 : 0

  metadata {
    name = "velero"

    labels = {
      app = "velero"
    }
  }

  depends_on = [module.eks]
}

module "velero" {
  source              = "github.com/mozilla-it/terraform-modules//aws/velero-bucket?ref=master"
  region              = var.region
  cluster_name        = module.eks.cluster_id
  create_bucket       = var.create_eks && local.cluster_features["velero"]
  create_role         = var.create_eks && local.cluster_features["velero"]
  bucket_name         = var.velero_bucket_name
  velero_sa_namespace = "velero"
  velero_sa_name      = "velero"
}
