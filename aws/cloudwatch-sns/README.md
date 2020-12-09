# cloudwatch sns topic
Creates an sns topic to send info to a pagerduty service endpoint

## Pre-requisite
Before using this module you will need to have an integration endpoint created on the pagerduty side. Documentation on how to this can be found [here](https://support.pagerduty.com/docs/aws-cloudwatch-integration-guide)

Once you have the endpoint you have 2 option for this module, you place the integration endpoint into AWS SSM
```bash
$ aws ssm put-parameter --name "/cloudwatch_to_pagerduty/endpoint" --type SecureString --key-id alias/aws/ssm --value "https://events.pagerduty.com/integration/[INTEGRATION KEY]/enqueue"
```

Or you can set it as an input argument in this terraform module. Caveat: If you do set it as an argument you must find a way to encrypt or hide the integration endpoint as it contains the integration key

## Usage
```hcl
module "sns" {
  source     = "github.com/mozilla-it/terraform-modules//aws/cloudwatch-sns?ref=master"
  topic_name = "cloudwatch-to-pd"
}
```
