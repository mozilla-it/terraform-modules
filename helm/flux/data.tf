data "helm_repository" "fluxcd" {
  count = var.enable_flux ? 1 : 0
  name  = "fluxcd"
  url   = "https://charts.fluxcd.io"
}

data "helm_repository" "stable" {
  count = var.enable_flux && var.enable_flux_helm_operator ? 1 : 0
  name  = "stable"
  url   = "https://kubernetes-charts.storage.googleapis.com"
}
