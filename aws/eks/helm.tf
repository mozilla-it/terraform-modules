
data "helm_repository" "eks" {
  name = "eks"
  url  = "https://aws.github.io/eks-charts"
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "helm_repository" "vmware_tanzu" {
  count = local.cluster_features["velero"] ? 1 : 0
  name  = "vmware-tanzu"
  url   = "https://vmware-tanzu.github.io/helm-charts"
}

resource "helm_release" "node_drain" {
  name       = "aws-node-termination-handler"
  repository = data.helm_repository.eks.metadata.0.name
  chart      = "eks/aws-node-termination-handler"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "metrics_server" {
  count      = local.cluster_features["metrics_server"] ? 1 : 0
  name       = "metrics-server"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/metrics-server"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "cluster_autoscaler" {
  count      = local.cluster_features["cluster_autoscaler"] ? 1 : 0
  name       = "cluster-autoscaler"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/cluster-autoscaler"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.cluster_autoscaler_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}

resource "helm_release" "reloader" {
  count      = local.cluster_features["reloader"] ? 1 : 0
  name       = "reloader"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/reloader"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.reloader_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}

resource "helm_release" "velero" {
  count      = local.cluster_features["velero"] ? 1 : 0
  name       = "velero"
  repository = data.helm_repository.vmware_tanzu[0].metadata.0.name
  chart      = "vmware-tanzu/velero"
  namespace  = "velero"

  dynamic "set" {
    iterator = item
    for_each = local.velero_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}

resource "helm_release" "sealed_secrets" {
  count      = local.cluster_features["sealed_secrets"] ? 1 : 0
  name       = "sealed-secrets"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/sealed-secrets"
  namespace  = "kube-system"

  # TODO: Figure out the downsides of this
  skip_crds = true
}
