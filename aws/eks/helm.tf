locals {
  helm_eks_repository              = "https://aws.github.io/eks-charts"
  helm_stable_repository           = "https://kubernetes-charts.storage.googleapis.com"
  helm_incubator_repository        = "http://storage.googleapis.com/kubernetes-charts-incubator"
  helm_vmware_tanzu_repository     = "https://vmware-tanzu.github.io/helm-charts"
  helm_external_secrets_repository = "https://godaddy.github.io/kubernetes-external-secrets"
  helm_bitnami_repository          = "https://charts.bitnami.com/bitnami"
  helm_autoscaler_repository       = "https://kubernetes.github.io/autoscaler"
  helm_mozilla_repository          = "https://mozilla-it.github.io/helm-charts"
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
  repository = local.helm_bitnami_repository
  chart      = "metrics-server"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.metrics_server_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}

resource "helm_release" "cluster_autoscaler" {
  count      = var.create_eks && local.cluster_features["cluster_autoscaler"] ? 1 : 0
  name       = "cluster-autoscaler"
  repository = local.helm_autoscaler_repository
  chart      = "cluster-autoscaler-chart"
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

resource "null_resource" "calico_crd" {
  count = var.create_eks && local.cluster_features["aws_calico"] ? 1 : 0

  provisioner "local-exec" {
    working_dir = path.module
    command     = <<EOF
for i in `seq 1 10`; do
  echo $kube_config | base64 --decode > kube_config.yaml & \
  kubectl apply -k github.com/aws/eks-charts/stable/aws-calico//crds?ref=master --kubeconfig kube_config.yaml && break ||
  sleep 10; \
done;
rm kube_config.yaml;
EOF
    interpreter = ["/bin/bash", "-c"]
    environment = {
      kube_config = base64encode(module.eks.kubeconfig)
    }
  }

  triggers = {
    endpoint       = module.eks.cluster_endpoint
    calico_version = helm_release.calico[0].version
  }

  depends_on = [
    module.eks,
    helm_release.calico[0]
  ]

}

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

resource "helm_release" "fluentd_papertrail" {
  count      = var.create_eks && local.cluster_features["fluentd_papertrail"] && local.cluster_features["external_secrets"] ? 1 : 0
  name       = "fluentd-papertrail"
  repository = local.helm_mozilla_repository
  chart      = "fluentd-papertrail"
  namespace  = "kube-system"

  depends_on = [
    module.eks,
    helm_release.kubernetes_external_secrets
  ]

  dynamic "set" {
    iterator = item
    for_each = local.fluentd_papertrail_settings

    content {
      name  = item.key
      value = item.value
    }
  }
}
