locals {

  tags = merge(
    {
      "Name"      = var.cluster_name
      "Region"    = var.region
      "Terraform" = "true"
    },
    var.tags,
  )

  cluster_features_defaults = {
    "cluster_autoscaler" = true
    "metrics_server"     = true
    "reloader"           = true
    "velero"             = true
    "sealed_secrets"     = false
    "aws_calico"         = false
    "alb_ingress"        = false
    "flux"               = false
    "flux_helm_operator" = false
    "external_secrets"   = false
  }
  cluster_features = merge(local.cluster_features_defaults, var.cluster_features)

  cluster_log_type = var.enable_logging ? ["api", "audit", "authenticator", "controllerManager", "scheduler"] : []

  cluster_autoscaler_name_prefix               = "${module.eks.cluster_id}-cluster-autoscaler-${var.region}"
  cluster_autoscaler_service_account_namespace = "kube-system"
  cluster_autoscaler_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler"

  # Maps k8s version to an image version
  cluster_autoscaler_versions = {
    "1.14" = "v1.14.8"
    "1.15" = "v1.15.6"
    "1.16" = "v1.16.5"
    "1.17" = "v1.17.2"
    "1.18" = "v1.18.1"
  }

  cluster_autoscaler_defaults = {
    "awsRegion"                                                     = var.region
    "image.repository"                                              = "us.gcr.io/k8s-artifacts-prod/autoscaling/cluster-autoscaler"
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

  # Settings taken from
  # https://github.com/vmware-tanzu/helm-charts/tree/master/charts/velero
  velero_defaults = {
    "configuration.provider"                                           = "aws"
    "configuration.backupStorageLocation.name"                         = "aws"
    "configuration.backupStorageLocation.bucket"                       = module.velero.bucket_name
    "configuration.backupStorageLocation.config.region"                = var.region
    "configuration.backupStorageLocation.config.kmsKeyId"              = module.velero.velero_kms_key_id
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

  alb_ingress_namespace   = "kube-system"
  alb_ingress_name_prefix = "${module.eks.cluster_id}-alb-ingress-${var.region}"
  alb_ingress_defaults = {
    "clusterName"                                                    = var.cluster_name
    "autoDiscoverAwsRegion"                                          = "true"
    "awsVpcID"                                                       = var.vpc_id
    "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.alb_ingress_role.this_iam_role_arn
  }
  alb_ingress_settings = merge(local.alb_ingress_defaults, var.alb_ingress_settings)

  external_secrets_role_name = "${module.eks.cluster_id}-kubernetes-external-secrets-${var.region}"
  external_secrets_defaults = {
    "securityContext.fsGroup"                                   = "65534"
    "serviceAccount.name"                                       = "kubernetes-external-secrets"
    "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.external_secrets.this_iam_role_arn
  }
  external_secrets_settings = merge(local.external_secrets_defaults, var.external_secrets_settings)

  node_groups_attributes = {
    k8s_labels = {
      Node = "managed"
    }

    additional_tags = {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"         = local.cluster_features["cluster_autoscaler"] ? "true" : "false"
    }
  }
  node_groups_defaults = merge(local.node_groups_attributes, var.node_groups_defaults)

  default_node_groups = {
    default_node_group = {
      desired_capacity = 3,
      min_capacity     = 3,
      max_capacity     = 10,
      instance_type    = "t3.large",
      disk_size        = 100,
      subnets          = var.cluster_subnets
    }
  }

  node_groups = length(var.node_groups) > 0 ? var.node_groups : local.default_node_groups

  admin_users = [for role in var.admin_users_arn :
    {
      username = "cluster-admin",
      rolearn  = role,
      groups   = ["system:masters"]
    }
  ]

  roles_expanded = length(local.admin_users) > 0 ? concat(local.admin_users, var.map_roles) : var.map_roles

  flux_settings_defaults = {
    "git.path"                  = "k8s/"
    "syncGarbageCollection.dry" = true
    "git.pollInterval"          = "2m"
  }
  flux_settings_expanded = merge(local.flux_settings_defaults, var.flux_settings)

}
