locals {
  helm_stable_repository     = "https://kubernetes-charts.storage.googleapis.com"
  helm_prometheus_repository = "https://prometheus-community.github.io/helm-charts"

  storage_class_defaults = {
    "aws" = "gp2"
    "gcp" = "standard"
  }
  storage_class = merge(local.storage_class_defaults, var.storage_class)

  prometheus_helm_defaults = {
    "server.persistentVolume.storageClass"       = lookup(local.storage_class, var.cloud_provider, "gp2")
    "server.persistentVolume.size"               = "20Gi"
    "server.retention"                           = "7d"
    "alertmanager.persistentVolume.storageClass" = lookup(local.storage_class, var.cloud_provider, "gp2")
    "alertmanager.persistentVolume.size"         = "5Gi"
  }
  prometheus_helm_settings = merge(local.prometheus_helm_defaults, var.prometheus_helm_settings)

}
