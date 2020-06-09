## terraform ecr
Creates an ECR image repository

## Usage
Example usage:

```
module "ecr" {
  source    = "github.com/mozilla-it/terraform-modules//aws/ecr?ref=master"
  repo_name = "Name-Of-My-Fancy-Repo"
}
```

## Inputs
Here are the inputs

| Inputs            | Description                                                                                               |
| ------------------|-----------------------------------------------------------------------------------------------------------|
| `repo_name`       | Name of ECR Repo                                                                                          |
| `create_user`     | (Optional) Create a role so that your CI system has permissions to push to the repo (default: `true`)     |
| `ecr_expire`      | (Optional) Creates a lifecycle rule to delete images after a certain number of days (default: `false`)    |


## Outputs
List of outputs

| Outputs                       |
| ------------------------------|
| `ecr_arn`                     |
| `ecr_name`                    |
| `ecr_registry_id`             |
| `ecr_repository_url`          |
| `ecr_iam_user`                |
| `ecr_iam_access_key`          |
| `ecr_iam_secret_access_key`   |
