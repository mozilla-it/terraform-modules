
locals {
  name = var.environment == "" ? var.name : "${var.name}-${var.environment}"

  cluster_addons_defaults = {
    horizontal_pod_autoscaling = true
    http_load_balancing        = true
    dns_cache                  = true
    istio                      = false
    vertical_pod_autoscaling   = false
    cloudrun                   = false
  }
  cluster_addons = merge(local.cluster_addons_defaults, var.cluster_addons)

  cluster_features_defaults = {
    "velero"             = false
    "prometheus"         = false
    "flux"               = false
    "flux_helm_operator" = false
  }
  cluster_features = merge(local.cluster_features_defaults, var.cluster_features)

  velero_defaults = {
    "configuration.provider"                             = "gcp"
    "configuration.backupStorageLocation.name"           = "gcp"
    "configuration.backupStorageLocation.bucket"         = local.cluster_features["velero"] ? google_storage_bucket.bucket[0].name : ""
    "configuration.backupStorageLocation.config.region"  = var.region
    "configuration.volumeSnapshotLocation.name"          = "gcp"
    "configuration.volumeSnapshotLocation.config.region" = var.region
    "initContainers[0].name"                             = "velero-plugin-for-gcp"
    "initContainers[0].image"                            = "velero/velero-plugin-for-gcp:v1.0.1"
    "initContainers[0].volumeMounts[0].mountPath"        = "/target"
    "initContainers[0].volumeMounts[0].name"             = "plugins"
  }
  velero_settings = merge(local.velero_defaults, var.velero_settings)

  #NOTE: Consider setting up pd-ssd storage class
  prometheus_defaults = {
    "server.persistentVolume.storageClass"       = "standard" # Up for discussion
    "server.persistentVolume.size"               = "50Gi"     # Without any idea of what normal is I'm just setting this as a random value
    "alertmanager.persistentVolume.storageClass" = "standard"
    "alertmanager.persistentVolume.size"         = "25Gi"
  }
  prometheus_settings = merge(local.prometheus_defaults, var.prometheus_settings)

}
