<!-- BEGIN_TF_DOCS -->
# AWS Database module
Use this module for deploying RDS instances in AWS.

## Usage
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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_instance.read_replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_auto_minor_version_upgrade"></a> [allow\_auto\_minor\_version\_upgrade](#input\_allow\_auto\_minor\_version\_upgrade) | If set to 'true' allows upgrading automatically to new minor engine versions during maintenance windows | `string` | `"true"` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | If set to 'true', it enables engine major version upgrades | `string` | `"false"` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | n/a | `string` | `"false"` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | n/a | `number` | `30` | no |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | n/a | `string` | `"rds-ca-2019"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | n/a | `any` | n/a | yes |
| <a name="input_custom_replica_sg"></a> [custom\_replica\_sg](#input\_custom\_replica\_sg) | Custom security Group ID to use in the replica Database | `string` | `""` | no |
| <a name="input_custom_sg"></a> [custom\_sg](#input\_custom\_sg) | Custom security Group ID to use in the main Database | `string` | `""` | no |
| <a name="input_custom_subnet"></a> [custom\_subnet](#input\_custom\_subnet) | Custom subnet to use in the main Database | `string` | `""` | no |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | n/a | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | n/a | `string` | `""` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | n/a | `string` | `"db.t3.medium"` | no |
| <a name="input_instance_replica"></a> [instance\_replica](#input\_instance\_replica) | n/a | `string` | `"db.t3.medium"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | n/a | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `any` | n/a | yes |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_password_length"></a> [password\_length](#input\_password\_length) | n/a | `number` | `16` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Enables RDS performance insights feature | `string` | `"false"` | no |
| <a name="input_performance_insights_retention"></a> [performance\_insights\_retention](#input\_performance\_insights\_retention) | The amount of days to retain performance insights | `string` | `"7"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `""` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Set DB open to the internet | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-west-2"` | no |
| <a name="input_replica_allow_major_version_upgrade"></a> [replica\_allow\_major\_version\_upgrade](#input\_replica\_allow\_major\_version\_upgrade) | If set to 'true', it enables engine major version upgrades for replica DB | `string` | `"false"` | no |
| <a name="input_replica_db_version"></a> [replica\_db\_version](#input\_replica\_db\_version) | n/a | `string` | `""` | no |
| <a name="input_replica_enabled"></a> [replica\_enabled](#input\_replica\_enabled) | Set to true for creating a Read Only replica of the main DB | `string` | `"false"` | no |
| <a name="input_replica_performance_insights_enabled"></a> [replica\_performance\_insights\_enabled](#input\_replica\_performance\_insights\_enabled) | Enables RDS performance insights feature for the DB replica | `string` | `"false"` | no |
| <a name="input_replica_performance_insights_retention"></a> [replica\_performance\_insights\_retention](#input\_replica\_performance\_insights\_retention) | The amount of days to retain performance insights for the DB replica | `string` | `"7"` | no |
| <a name="input_replica_publicly_accessible"></a> [replica\_publicly\_accessible](#input\_replica\_publicly\_accessible) | Set replica DB open to the internet | `string` | `"false"` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | If a snapshot identifier is specified, a new database will be created from the snapshot | `string` | `""` | no |
| <a name="input_storage_gb"></a> [storage\_gb](#input\_storage\_gb) | n/a | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | n/a | `string` | `"gp2"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | `list(string)` | `[]` | no |
| <a name="input_type"></a> [type](#input\_type) | n/a | `string` | `"mysql"` | no |
| <a name="input_username"></a> [username](#input\_username) | n/a | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_password"></a> [password](#output\_password) | n/a |
| <a name="output_username"></a> [username](#output\_username) | n/a |
<!-- END_TF_DOCS -->