
resource "kubernetes_namespace" "flux" {
  count = var.enable_flux ? 1 : 0
  metadata {
    name = "flux"
  }
}
