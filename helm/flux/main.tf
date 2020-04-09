
# Logic here is we can enable flux on its own and it can just run flux without operator
# but there is not really a point in running the helm operator without flux

resource "helm_release" "flux_helm_operator" {
  count      = var.enable_flux && var.enable_flux_helm_operator ? 1 : 0
  name       = "helm-operator"
  repository = data.helm_repository.fluxcd[0].metadata.0.name
  chart      = "fluxcd/helm-operator"
  namespace  = local.flux_helm_operator_settings["namespace"]

  dynamic "set" {
    iterator = item
    for_each = local.flux_helm_operator_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  skip_crds = true
}

resource "helm_release" "fluxcd" {
  count      = var.enable_flux ? 1 : 0
  name       = "flux"
  repository = data.helm_repository.fluxcd[0].metadata.0.name
  chart      = "fluxcd/flux"
  namespace  = local.flux_settings["namespace"]

  dynamic "set" {
    iterator = item
    for_each = local.flux_settings

    content {
      name  = item.key
      value = item.value
    }
  }
}
