# Info module
Provider this module with a vpc module and outputs the subnet ID for the public and private subnets

This is useful to avoid duplication of doing the same data resource lookup on other terraform projects / code

## Usage
```hcl
module "info" {
  source = "github.com/mozilla-it/terraform-modules//aws/info?ref=master"
  vpc_id = "vpc-1234"
}

output "public_subnet_id" {
  value = module.info.public_subnets
}
```
