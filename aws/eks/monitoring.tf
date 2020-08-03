
module "prometheus" {
  source                   = "github.com/mozilla-it/terraform-modules//helm/prometheus?ref=master"
  enabled                  = local.cluster_features["prometheus"]
  cloud_provider           = "aws"
  prometheus_helm_settings = var.prometheus_settings
}
