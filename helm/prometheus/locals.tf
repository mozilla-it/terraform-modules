locals {
  helm_prometheus_repository = "https://prometheus-community.github.io/helm-charts"

  storage_class_defaults = {
    "aws" = "gp2"
    "gcp" = "standard"
  }
  storage_class = merge(local.storage_class_defaults, var.storage_class)

  prometheus_helm_defaults = {
    "server.persistentVolume.storageClass" = lookup(local.storage_class, var.cloud_provider, "gp2")
    "server.persistentVolume.size"         = "20Gi"
    "server.retention"                     = "7d"
    "alertmanager.enabled"                 = "False"
    "grafana.enabled"                      = "False"
    "configmapReload.prometheus.enabled"   = "False"
    "server.statefulsetReplica.enabled"    = "True"
    "server.statefulSet.enabled"           = "True"
    "server.replicaCount"                  = 2
    "server.strategy.type"                 = "Recreate"
  }

  prom_influx_settings = {
    "server.configPath"                      = "/etc/secret/prometheus.yml"
    "server.extraSecretMounts[0].name"       = "secret-files"
    "server.extraSecretMounts[0].mountPath"  = "/etc/secret"
    "server.extraSecretMounts[0].subPath"    = ""
    "server.extraSecretMounts[0].secretName" = "prometheus-config"
    "server.extraSecretMounts[0].readOnly"   = "True"
  }
  # create a new dict to merge in, based on if the settings should be passed or not.
  tmp_prom_influx_settings = var.influxdb ? local.prom_influx_settings : {}

  prometheus_helm_settings = merge(local.tmp_prom_influx_settings, local.prometheus_helm_defaults, var.prometheus_helm_settings)

}
