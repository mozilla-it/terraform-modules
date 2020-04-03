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

  cluster_autoscaler_defaults = {
    "awsRegion"                                                     = var.region
    "image.tag"                                                     = lookup(local.cluster_autoscaler_versions, var.cluster_version)
    "autoDiscovery.clusterName"                                     = module.eks.cluster_id
    "autoDiscovery.enabled"                                         = "true"
    "rbac.create"                                                   = "true"
    "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn" = module.cluster_autoscaler_role.this_iam_role_arn
    "extraArgs.skip-nodes-with-system-pods"                         = "false"
    "extraArgs.balance-similar-node-groups"                         = "true"
  }
  cluster_autoscaler_settings = merge(local.cluster_autoscaler_defaults, var.cluster_autoscaler_settings)

  reloader_defaults = {
    "reloader.deployment.image.tag" = "v0.0.58"
  }
  reloader_settings = merge(local.reloader_defaults, var.reloader_settings)

  flux_helm_operator_defaults = {
    "createCRD"          = "true"
    "helm.versions"      = "v3"
    "git.ssh.secretName" = "flux-git-deploy"
  }
  flux_helm_operator_settings = merge(local.flux_helm_operator_defaults, var.flux_helm_operator_settings)

  flux_defaults = {
    "git.ciSkip" = "true"
  }
  flux_settings = merge(local.flux_defaults, var.flux_settings)

  # Settings taken from
  # https://github.com/vmware-tanzu/helm-charts/tree/master/charts/velero
  velero_defaults = {
    "configuration.provider"                                           = "aws"
    "configuration.backupStorageLocation.name"                         = "aws"
    "configuration.backupStorageLocation.bucket"                       = module.velero.bucket_name
    "configuration.backupStorageLocation.config.region"                = var.region
    "configuration.volumeSnapshotLocation.name"                        = "aws"
    "configuration.volumeSnapshotLocation.config.region"               = var.region
    "configuration.volumeSnapshotLocation.name"                        = "aws"
    "configuration.volumeSnapshotLocation.config.region"               = var.region
    "serviceAccount.server.name"                                       = "velero"
    "serviceAccount.server.annotations.eks\\.amazonaws\\.com/role-arn" = module.velero.velero_role_arn
    "securityContext.fsGroup"                                          = "65534"
    "initContainers[0].name"                                           = "velero-plugin-for-aws"
    "initContainers[0].image"                                          = "velero/velero-plugin-for-aws:v1.0.1"
    "initContainers[0].volumeMounts[0].mountPath"                      = "/target"
    "initContainers[0].volumeMounts[0].name"                           = "plugins"
  }
  velero_settings = merge(local.velero_defaults, var.velero_settings)
}
