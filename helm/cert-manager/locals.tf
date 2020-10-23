locals {
  cert_manager_version      = var.cert_manager_version == "" ? "v1.0.2" : var.cert_manager_version
  cert_manager_crd_manifest = "https://github.com/jetstack/cert-manager/releases/download/${local.cert_manager_version}/cert-manager.crds.yaml"
  cert_manager_name_prefix  = "${var.cluster_id}-cert-manager"
  cert_manager_namespace    = "cert-manager"

  cert_manager_tags = {
    Environment = var.environment
    Terraform   = "true"
  }

  cert_manager_settings = {
    "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.cert_manager_role.this_iam_role_arn
    "extraArgs[0]"                                              = "--issuer-ambient-credentials"
    "securityContext.fsGroup"                                   = "1001"
  }

  cluster_oidc_issuer = flatten(concat(data.aws_eks_cluster.this[*].identity[*].oidc.0.issuer))[0]
}

