
module "external-secrets-workload-identity" {
  source      = "github.com/mozilla-it/terraform-modules//gcp/identity?ref=master"
  enabled     = local.cluster_features["external_secrets"]
  create_ksa  = false # Allow chart to create
  name        = "kubernetes-external-secrets"
  namespace   = "kube-system"
  gke_cluster = module.gke.name
  project_id  = var.project_id
}
