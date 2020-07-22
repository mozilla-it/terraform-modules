locals {
  helm_stable_repository       = "https://kubernetes-charts.storage.googleapis.com"
  helm_incubator_repository    = "http://storage.googleapis.com/kubernetes-charts-incubator"
  helm_vmware_tanzu_repository = "https://vmware-tanzu.github.io/helm-charts"
}

resource "helm_release" "velero" {
  count      = local.cluster_features["velero"] ? 1 : 0
  name       = "velero"
  repository = local.helm_vmware_tanzu_repository
  chart      = "velero"
  namespace  = "velero"

  dynamic "set" {
    iterator = item
    for_each = local.velero_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.gke]
}
