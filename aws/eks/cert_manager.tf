resource "kubernetes_namespace" "cert_manager" {
  count = var.create_eks && local.cluster_features["cert_manager"] ? 1 : 0

  metadata {
    name = "cert-manager"

    labels = {
      app = "cert-manager"
    }
  }

  depends_on = [module.eks]
}
