# AWS Database module
Use this module for deploying RDS instances in AWS

## Usage
Example on how to use module

```
module "my-database" {
  source     = "github.com/mozilla-it/terraform-modules//aws/database"
  type       = "mysql"
  name       = "db-name"
  username   = "db-username"
  identifier = "db-name"
  storage_gb = "30" # In GBs
  db_version = "5.6"
  multi_az   = "false"
  vpc_id     = module.vpc.vpc_id
  subnets    = module.vpc.private_subnets.0

  cost_center = "1410"
  project     = "your-project-name"
  environment = "dev"
}
```

## Terraform versions
This module is compatible with Terraform 0.11 as well as with Terraform 0.12.
The example above assumes using Terraform 0.12. If your code is still using Terrafor 0.11 and you want to use this module,
change the parameter `source` in the example above adding `source = "github.com/mozilla-it/terraform-modules//database?ref=7a898880c617fe34774bf331668b8b3f5d612fd7`.
