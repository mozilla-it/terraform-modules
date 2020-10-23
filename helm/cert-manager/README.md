# cert-manager module
Installs (jetstack cert-manager)[https://github.com/jetstack/cert-manager] using terraform

This module only works against AWS, so you have been warned

## Usage

```hcl
module "cert_manager" {
  source     = "github.com/mozilla-it/terraform-modules//helm/cert-manager?ref=master"
  cluster_id = "my_cluster_name"
  kubeconfig = "kubeconfig"
}
```
