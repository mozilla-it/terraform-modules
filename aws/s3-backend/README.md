# s3-backend

This module creates a S3 backend and store the state file in it.

## Usage

First, call the module and create the resources:
```hcl-terraform
module "terraform-backend" {
  source = "github.com/mozilla-it/terraform-modules//aws/s3-backend"

  # Set variables
  backend_bucket         = "my-project-state-123456789012"
  backend_key            = "terraform.tfstate"
  backend_dynamodb_table = "my-project-state-lock"
  read_capacity          = 5
  write_capacity         = 5
  region                 = "us-east-1"
  tags = {
    project     = "my-project"
    description = "Managed by Terraform"
  }
}
```

Then, add the backend configuration:
```hcl-terraform
terraform {
  backend "s3" {
    bucket         = "my-project-state-123456789012"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    profile        = "my-aws-account-profile"
    dynamodb_table = "my-project-state-lock"
  }
}
```


## Inputs

| Input                    | Description                                                                              |
|--------------------------|------------------------------------------------------------------------------------------|
| `backend_dynamodb_table` | Name of the dynamodb table used to lock Terraform's state                                |
| `backend_bucket`         | Name of bucket where Terraform's state is stored                                         |
| `backend_key`            | Name of the key that keeps Terraform's state                                             |
| `read_capacity`          | Read capacity for the DynamoDB table                                                     |
| `write_capacity`         | Write capacity for the DynamoDB table                                                    |
| `region`                 | Name of the region for the S3 bucket                                                     |
| `tags`                   | AWS tags                                                                                 |
