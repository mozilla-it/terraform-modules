# Route 53 zone module

Creates a simple DNS zone in Route53 with a delegation set

## Usage

```hcl
module "example_com" {
  source      = "github.com/mozilla-it/terraform-modules//aws/dns_zone?ref=master
  domain_name = "example.com"
}
```

## Inputs

| Variable      | Description                                                       |
| `domain_name` | The name of the zone or domain you want created, a required input |
