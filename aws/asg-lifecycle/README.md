<!-- BEGIN_TF_DOCS -->
# ASG Lifecycle
A module to create Autoscaling Group lifecycle hooks, this assumes the hook listens to an SNS queue. Very handy if you are using lifecycled

## Usage
```
module "asg_lifecycle" {
	name			= "MyASGHook"
	worker_asg		= [ "myasg-1" ]
	worker_iam_role = "myworker-role-name"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_lifecycle_hook.lifecycle_hook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_lifecycle_hook) | resource |
| [aws_cloudwatch_log_group.lifecycled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lifecycle_hook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lifecycle_hook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.worker_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_sns_topic.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.asg_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.asg_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.worker_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lifecycled_log_group"></a> [lifecycled\_log\_group](#input\_lifecycled\_log\_group) | n/a | `string` | `"/aws/lifecycled"` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-west-2"` | no |
| <a name="input_retention_log_days"></a> [retention\_log\_days](#input\_retention\_log\_days) | n/a | `string` | `"7"` | no |
| <a name="input_worker_asg"></a> [worker\_asg](#input\_worker\_asg) | n/a | `list(string)` | n/a | yes |
| <a name="input_worker_asg_count"></a> [worker\_asg\_count](#input\_worker\_asg\_count) | n/a | `any` | n/a | yes |
| <a name="input_worker_iam_role"></a> [worker\_iam\_role](#input\_worker\_iam\_role) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_lifecycle_role"></a> [asg\_lifecycle\_role](#output\_asg\_lifecycle\_role) | n/a |
| <a name="output_asg_lifecycle_role_arn"></a> [asg\_lifecycle\_role\_arn](#output\_asg\_lifecycle\_role\_arn) | n/a |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | n/a |
<!-- END_TF_DOCS -->