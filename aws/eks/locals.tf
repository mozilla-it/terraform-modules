locals {

  tags = merge(
    {
      "Region"    = var.region
      "Terraform" = "true"
    },
    var.tags,
  )

  cluster_log_type = var.enable_logging ? ["api", "audit", "authenticator", "controllerManager", "scheduler"] : []

  cluster_autoscaler_name_prefix               = "${module.eks.cluster_id}-cluster-autoscaler"
  cluster_autoscaler_service_account_namespace = "kube-system"
  cluster_autoscaler_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler"

  # Maps k8s version to an image version
  cluster_autoscaler_versions = {
    "1.13" = "v1.13.9"
    "1.14" = "v1.14.7"
    # By default this should be 1.15.5 but
    # they have not released a version in the 1.15.x branch
    # to accept irsa yet (IAM Roles for Service accounts)
    # See: https://github.com/kubernetes/autoscaler/issues/2920
    "1.15" = "v1.14.7"
    "1.16" = "v1.16.4"
    "1.17" = "v1.17.1"
  }

  kube_state_metrics_versions = {
    "1.13" = "v1.6.0"
    "1.14" = "v1.7.2"
    "1.15" = "v1.8.0"
    "1.16" = "v1.9.5"
    "1.17" = "master"
  }

  # TODO: We should set this as a default and create
  # a variable to configure additional settings to
  # allow more configurability
  cluster_autoscaler_settings = [
    {
      name  = "awsRegion"
      value = var.region
    },
    {
      name  = "image.tag"
      value = lookup(local.cluster_autoscaler_versions, var.cluster_version)
    },
    {
      name  = "autoDiscovery.clusterName"
      value = module.eks.cluster_id
    },
    {
      name  = "autoDiscovery.enabled"
      value = "true"
    },
    {
      name  = "rbac.create"
      value = "true"
    },
    {
      # Double slash needed to escape dots
      name  = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
      value = module.cluster_autoscaler_role.this_iam_role_arn
    },
    # Recommended per aws' recommendation
    {
      name  = "extraArgs.skip-nodes-with-system-pods"
      value = "false"
    },
    {
      name  = "extraArgs.balance-similar-node-groups"
      value = "true"
    }
  ]

  reloader_settings = [
    {
      name  = "reloader.deployment.image.tag"
      value = "v0.0.58"
    }
  ]

  flux_helm_operator_settings = [
    {
      name  = "createCRD"
      value = "true"
    },
    {
      name  = "helm.versions"
      value = "v3"
    }
  ]

}
