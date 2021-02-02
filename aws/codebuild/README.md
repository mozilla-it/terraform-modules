# AWS Codebuild Module
This module allows the creation on AWS Codebuild projects. It takes care of creating the needed IAM policies and can optionally add a webhook for getting updates when changes in the repository happen.

## Example
```
module "auth0-deploy-ci-stage" {
  source     = "github.com/mozilla-it/terraform-modules//aws/codebuild"

  project_name      = "auth0-deploy"
  environment       = "stage"
  github_repo       = "https://github.com/mozilla-iam/auth0-deploy"
  github_head_ref   = "refs/heads/master"
  github_event_type = "PUSH"
  enable_webhook    = "true"
  enable_ecr        = "false"
  build_image       = "aws/codebuild/python:3.6.5"
}
```
## Providers

The following providers are used by this module:

- aws

## Required Inputs

The following input variables are required:

### environment

Description: n/a

Type: `any`

### github\_event\_type

Description: Event type which will trigger a deploy

Type: `any`

### github\_head\_ref

Description: Git head reference used to determine which branches gets tbuilt

Type: `any`

### github\_repo

Description: Adress of the Guthub repository where fetch the code from

Type: `any`

### project\_name

Description: Codebuild name

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### build\_image

Description: n/a

Type: `string`

Default: `"aws/codebuild/docker:17.09.0"`

### enable\_ecr

Description: n/a

Type: `string`

Default: `"true"`

### enable\_webhook

Description: n/a

Type: `string`

Default: `"true"`

### fetch\_submodules

Description: Fetch submodules included in the repository

Type: `string`

Default: `"false"`

### region

Description: The region where the Codebuild job will be created

Type: `string`

Default: `"us-west-2"`

### source\_version

Description: Git reference to fetch code from.

Type: `string`

Default: `""`

### ssm\_kms\_key\_id

Description: If using SSM, the name of ID of the key used to encrypt the parameters

Type: `string`

Default: `"alias/aws/ssm"`

### ssm\_parameters

Description: Set to true if Codebuild will be relying on parameters stored on SSM. The location will be parameter/iam/<project\_name>/<environment>

Type: `string`

Default: `"true"`

## Outputs

No output.

