module "prometheus" {
  source                   = "github.com/mozilla-it/terraform-modules//helm/prometheus?ref=master"
  enabled                  = local.cluster_features["prometheus"]
  cloud_provider           = "aws"
  prometheus_helm_settings = var.prometheus_settings
  influxdb                 = var.influxdb
}

resource "helm_release" "prometheus_customizations" {
  # only checking dependencies here, not features.  So maybe these customizations can be used in a modular way going forward.
  count      = local.cluster_features["prometheus"] && local.cluster_features["external_secrets"] && local.cluster_features["configmapsecrets"] ? 1 : 0
  name       = "prometheus-customizations"
  repository = local.helm_mozilla_repository
  chart      = "prometheus-customizations"
  namespace  = module.prometheus.namespace

  dynamic "set" {
    iterator = item
    for_each = local.prometheus_customization_settings

    content {
      name  = item.key
      value = item.value
    }
  }
}

