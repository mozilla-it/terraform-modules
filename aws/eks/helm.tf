
locals {
  helm_eks_repository          = "https://aws.github.io/eks-charts"
  helm_stable_repository       = "https://kubernetes-charts.storage.googleapis.com"
  helm_incubator_repository    = "http://storage.googleapis.com/kubernetes-charts-incubator"
  helm_vmware_tanzu_repository = "https://vmware-tanzu.github.io/helm-charts"
}

resource "helm_release" "node_drain" {
  name       = "aws-node-termination-handler"
  repository = local.helm_eks_repository
  chart      = "aws-node-termination-handler"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "metrics_server" {
  count      = var.create_eks && local.cluster_features["metrics_server"] ? 1 : 0
  name       = "metrics-server"
  repository = local.helm_stable_repository
  chart      = "metrics-server"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "cluster_autoscaler" {
  count      = var.create_eks && local.cluster_features["cluster_autoscaler"] ? 1 : 0
  name       = "cluster-autoscaler"
  repository = local.helm_stable_repository
  chart      = "cluster-autoscaler"
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
  count      = var.create_eks && local.cluster_features["reloader"] ? 1 : 0
  name       = "reloader"
  repository = local.helm_stable_repository
  chart      = "reloader"
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
  count      = var.create_eks && local.cluster_features["velero"] ? 1 : 0
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

  depends_on = [module.eks]
}

resource "helm_release" "sealed_secrets" {
  count      = var.create_eks && local.cluster_features["sealed_secrets"] ? 1 : 0
  name       = "sealed-secrets"
  repository = local.helm_stable_repository
  chart      = "sealed-secrets"
  namespace  = "kube-system"

  # TODO: Figure out the downsides of this
  skip_crds = true
}

# NOTE: Does not install the CRD, to install the crd run this
# kubectl apply -k github.com/aws/eks-charts/stable/aws-calico//crds?ref=master -n kube-system
resource "helm_release" "calico" {
  count      = var.create_eks && local.cluster_features["aws_calico"] ? 1 : 0
  name       = "aws-calico"
  repository = local.helm_eks_repository
  chart      = "aws-calico"
  namespace  = "kube-system"
}

resource "helm_release" "alb_ingress" {
  count      = var.create_eks && local.cluster_features["alb_ingress"] ? 1 : 0
  name       = "aws-alb-ingress-controller"
  repository = local.helm_incubator_repository
  chart      = "aws-alb-ingress-controller"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.alb_ingress_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}
