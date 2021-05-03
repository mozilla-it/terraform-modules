
resource "kubernetes_namespace" "configmapsecrets" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace

    labels = {
      app = "configmapsecrets"
    }
  }
}

resource "helm_release" "configmapsecrets" {
  name       = "configmapsecrets"
  repository = local.helm_configmapsecrets_repository
  chart      = "configmapsecrets"
  namespace  = var.namespace

  dynamic "set" {
    iterator = item
    for_each = local.configmapsecrets_helm_settings

    content {
      name  = item.key
      value = item.value
    }
  }
}
