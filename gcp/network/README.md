# GCP VPC

Opinionated way of creating a VPC in GCP, this module wraps the upstream [network module](https://registry.terraform.io/modules/terraform-google-modules/network/google) to create a VPC

It will default to only create subnets in the `us-central1` and `us-west1` regions, the base CIDR range begins from `10.10.0.0/16` and a `/20` subnet gets created per region

## Usage
Sample Usage:

```hcl
provider "google-beta" {
  version = "~> 3"
  region  = var.region
  project = local.project_id
}

locals {
  project_id = "mozilla-it-service-engineering"
}

module "vpc" {
  source           = "https://github.com/mozilla-it/terraform-modules//gcp/network"
  project_id       = local.project_id
  vpc_name         = "main-vpc"
  regions          = ["us-central1", "us-west1"]
  create_cloud_nat = true
}
```
