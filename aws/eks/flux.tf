resource "kubernetes_namespace" "flux" {
  count = var.create_eks && local.cluster_features["flux"] ? 1 : 0
  metadata {
    name = "fluxcd"

    labels = {
      app = "fluxcd"
    }
  }
}

module "flux" {
  source                    = "github.com/mozilla-it/terraform-modules//helm/flux?ref=master"
  enable_flux               = var.create_eks && local.cluster_features["flux"]
  enable_flux_helm_operator = var.create_eks && local.cluster_features["flux_helm_operator"]
  flux_settings             = var.flux_settings
}
