# Route 53 zone module

Creates a simple DNS zone in route53 which is an apex domain

## Usage

```hcl
module "example_com" {
  source = "github.com/mozilla-it/terraform-modules//aws/dns/apex?ref=master"
  domain = "example.com"
}
```

## Inputs

| Variable | Description                                                       |
| `domain` | The name of the zone or domain you want created, a required input |
