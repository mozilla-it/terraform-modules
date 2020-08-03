
resource "kubernetes_namespace" "monitoring" {
  count = var.enabled && var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace

    labels = {
      app = "prometheus"
    }
  }
}

resource "helm_release" "prometheus" {
  count      = var.enabled ? 1 : 0
  name       = "prometheus"
  repository = local.helm_stable_repository
  chart      = "prometheus"
  namespace  = var.namespace

  dynamic "set" {
    iterator = item
    for_each = local.prometheus_helm_settings

    content {
      name  = item.key
      value = item.value
    }
  }
}
