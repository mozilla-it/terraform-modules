locals {
  helm_eks_repository              = "https://aws.github.io/eks-charts"
  helm_stable_repository           = "https://kubernetes-charts.storage.googleapis.com"
  helm_incubator_repository        = "http://storage.googleapis.com/kubernetes-charts-incubator"
  helm_vmware_tanzu_repository     = "https://vmware-tanzu.github.io/helm-charts"
  helm_external_secrets_repository = "https://godaddy.github.io/kubernetes-external-secrets"
  helm_jetstack_repository         = "https://charts.jetstack.io"
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

resource "helm_release" "kubernetes_external_secrets" {
  count      = var.create_eks && local.cluster_features["external_secrets"] ? 1 : 0
  name       = "kubernetes-external-secrets"
  repository = local.helm_external_secrets_repository
  chart      = "kubernetes-external-secrets"
  namespace  = "kube-system"

  depends_on = [module.eks]


  dynamic "set" {
    iterator = item
    for_each = local.external_secrets_settings

    content {
      name  = item.key
      value = item.value
    }
  }
}

resource "helm_release" "cert_manager" {
  # CRDs have to be installed by hand, there is a drama about it in the community.
  # TL;DR: Helm is not yet ready to upgrade CRDs and this can cause an outage.
  # For more info read https://github.com/helm/helm/issues/7735
  #
  # Manually install CRDs with:
  # kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.0/cert-manager.crds.yaml
  count      = var.create_eks && local.cluster_features["cert_manager"] ? 1 : 0
  name       = "cert-manager"
  repository = local.helm_jetstack_repository
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v0.16.0"

  depends_on = [module.eks]
}
