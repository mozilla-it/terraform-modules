# Subdomain
Creates a subdomain in route53 but it requires a delegation set id

## Usage:
```hcl

module "example_com" {
  source = "github.com/mozilla-it/terraform-modules//aws/dns/apex?ref=master"
  domain = "example.com"
}

module "foo_example_com" {
  source            = "github.com/mozilla-it/terraform-modules//aws/dns/subdomain?ref=master"
  domain            = "foo.example.com"
  delegation_set_id = module.example_com.delegation_id
}
```
