locals {

  helm_fluxcd_repository = "https://charts.fluxcd.io"

  flux_helm_operator_defaults = {
    "createCRD"          = "true"
    "helm.versions"      = "v3"
    "git.ssh.secretName" = "flux-git-deploy"
    "namespace"          = "fluxcd"
  }
  flux_helm_operator_settings = merge(local.flux_helm_operator_defaults, var.flux_helm_operator_settings)

  flux_defaults = {
    "git.ciSkip"                    = true
    "rbac.pspEnabled"               = true
    "syncGarbageCollection.enabled" = true
    "namespace"                     = "fluxcd"
  }
  flux_settings = merge(local.flux_defaults, var.flux_settings)

}
