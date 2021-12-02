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

<!-- BEGIN_TF_DOCS -->
# Module Docs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_project_iam_member.iam](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_iam_member) | resource |
| [google-beta_google_project_iam_member.iam-secret-viewing](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_iam_member) | resource |
| [google-beta_google_service_account.gsa](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_service_account) | resource |
| [google-beta_google_service_account_iam_binding.ksa-gsa-binding](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_service_account_iam_binding) | resource |
| [google_project_iam_member.iam-logging](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [kubernetes_service_account.ksa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_permissions"></a> [additional\_permissions](#input\_additional\_permissions) | Option to add additonal `secretmanager.secretAccessor` and `logging.logWriter` permission to SA | `bool` | `true` | no |
| <a name="input_create_ksa"></a> [create\_ksa](#input\_create\_ksa) | Create kubernetes service account instead of using existing one, KSA will be named using `var.name` | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_gke_cluster"></a> [gke\_cluster](#input\_gke\_cluster) | n/a | `any` | n/a | yes |
| <a name="input_ksa_name"></a> [ksa\_name](#input\_ksa\_name) | Name of kubernetes service account, only configure this value if `var.create_ksa` is set to false | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the google service account to create, optionally if `var.create_ksa` is set to `true` then the ksa will be the same as the gsa | `any` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace SA will be created in | `string` | `"default"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gcp_service_account_email"></a> [gcp\_service\_account\_email](#output\_gcp\_service\_account\_email) | Email address of GCP service account. |
| <a name="output_gcp_service_account_fqn"></a> [gcp\_service\_account\_fqn](#output\_gcp\_service\_account\_fqn) | FQN of GCP service account. |
| <a name="output_k8s_service_account_name"></a> [k8s\_service\_account\_name](#output\_k8s\_service\_account\_name) | Name of k8s service account. |
| <a name="output_k8s_service_account_namespace"></a> [k8s\_service\_account\_namespace](#output\_k8s\_service\_account\_namespace) | Namespace of k8s service account. |
<!-- END_TF_DOCS -->