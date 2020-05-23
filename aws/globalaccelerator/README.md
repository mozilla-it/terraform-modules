# AWS Global Accelerator module
Use this module for deploying Global Accelerator instances in AWS

## Usage
Example on how to use module

```
module "my-globalaccelerator" {
  source = "github.com/mozilla-it/terraform-modules//aws/globalaccelerator?ref=master"

  name        = "myapp-stage"
  nlb_arn     = "arn:aws:elasticloadbalancing:us-west-2:783633885093:loadbalancer/net/a57238492f21a4984923452e2001fe24/f9b5d3ddd19fd12f"
  environment = "stage"
  cost_center = "1440"
}
```

## Terraform versions
This module is compatible with Terraform 0.12
