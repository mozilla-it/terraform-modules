locals {
  helm_stable_repository = "https://kubernetes-charts.storage.googleapis.com"

  storage_class_defaults = {
    "aws" = "gp2"
    "gcp" = "standard"
  }
  storage_class = merge(local.storage_class_defaults, var.storage_class)

  prometheus_helm_defaults = {
    "server.persistentVolume.storageClass"       = lookup(local.storage_class, var.cloud_provider, "gp2")
    "server.persistentVolume.size"               = "500Gi" # Without any idea of what normal is I'm just setting this as a random value
    "server.retention"                           = "7d"
    "alertmanager.persistentVolume.storageClass" = lookup(local.storage_class, var.cloud_provider, "gp2")
    "alertmanager.persistentVolume.size"         = "100Gi"
  }
  prometheus_helm_settings = merge(local.prometheus_helm_defaults, var.prometheus_helm_settings)

}
