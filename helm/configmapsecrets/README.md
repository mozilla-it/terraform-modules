# Configmapsecrets module
Installs configmapsecrets via a helm chart

## Usage

```hcl
module "configmapssecret" {
  source         = "github.com/mozilla-it/terraform-modules//helm/configmapsecrets?ref=master
  enabled        = true
}
```

