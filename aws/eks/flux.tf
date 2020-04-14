
resource "kubernetes_namespace" "flux" {
  count = local.cluster_features["flux"] ? 1 : 0
  metadata {
    name = "fluxcd"
  }
}

module "flux" {
  source                    = "github.com/mozilla-it/terraform-modules//helm/flux?ref=master"
  enable_flux               = local.cluster_features["flux"]
  enable_flux_helm_operator = local.cluster_features["flux_helm_operator"]
  flux_settings             = var.flux_settings
}
