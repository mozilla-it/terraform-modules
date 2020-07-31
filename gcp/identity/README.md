# Identity module
Connects Kubernetes Service Accounts (KSA) with GCP Service Accounts (GSA) to enable the use of `Workload Identity` for kubernetes to access GCP resources

This module creates:

 * GCP Service Account
 * IAM Service Account binding to `roles/iam.workloadIdentityUser`
 * A Kubernetes service account which can be optionally be disabled
 * Attaches `roles/secretmanager.secretAccessor` and `roles/logging.logWriter` role

## Usage:

Basic usage that creates kubernetes service account as well as annotating the service account

```hcl
module "sample-workload-identity" {
  source      = "github.com/mozilla-it/terraform-modules//gcp/identity?ref=master
  name        = "my-service-account"
  namespace   = "my-service-account-namespace"
  gke_cluster = "my-gke-cluster"
  project_id  = "my-project-id"
}
```

Using module if there you have an existing kubernetes service account

```hcl
resource "kubernetes_service_account" "preexisting" {
  metadata {
    name = "my-service-account"
    namespace = "my-service-account-namespace"
    annotations = {
      "iam.gke.io/gcp-service-account" = "my-service-account@${var.project_id}.iam.gserviceaccount.com"
    }
  }
}

module "sample-workload-identity" {
  source      = "github.com/mozilla-it/terraform-modules//gcp/identity?ref=master
  create_ksa  = false
  name        = "my-service-account"
  namespace   = "my-service-account-namespace"
  gke_cluster = "my-gke-cluster"
  project_id  = "my-project-id"
}
```
