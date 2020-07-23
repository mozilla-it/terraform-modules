resource "kubernetes_namespace" "monitoring" {
  count = local.cluster_features["prometheus"] ? 1 : 0
  metadata {
    name = "monitoring"

    labels = {
      app = "prometheus"
    }
  }
}

resource "helm_release" "prometheus" {
  count      = local.cluster_features["prometheus"] ? 1 : 0
  name       = "prometheus"
  repository = local.helm_stable_repository
  chart      = "prometheus"
  namespace  = "monitoring"

  dynamic "set" {
    iterator = item
    for_each = local.prometheus_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.gke]
}
