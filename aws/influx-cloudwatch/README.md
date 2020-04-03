# influx-cloudwatch

Just a simple module to create a role that will delegate AWS access into an account to grab cloudwatch metrics. By default it allows account `177680776199` access

## Usage

```hcl
module "influx_role" {
  source = "github.com/mozilla-it/terraform-modules//aws/influx-cloudwatch?ref=master
}
```

## Outputs

| Name             | Description                |
|------------------|----------------------------|
| `this_role_arn`  | ARN of the role created    |
| `this_role_name` | Name of the role           |
