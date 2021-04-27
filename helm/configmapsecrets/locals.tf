locals {
  helm_configmapsecrets_repository = "https://mozilla-it.github.io/helm-charts"


  configmapsecrets_helm_defaults = {

  }
  configmapsecrets_helm_settings = merge(local.configmapsecrets_helm_defaults, var.configmapsecrets_helm_settings)

}
