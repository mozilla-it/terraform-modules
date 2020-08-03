# Prometheus module
Installs prometheus via a helm chart, this supports both gcp and aws

## Usage

```hcl
module "prometheus" {
  source         = "github.com/mozilla-it/terraform-modules//helm/prometheus?ref=master
  enabled        = true
  cloud_provider = "aws"
}
```

