## VPC module
This is a module that calls the [terraform registry vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.72.0) module.
That being said it simplifies the calling of the registry module by doing the subnet cidr calculations for you. This module does assume that you
will only have a `private` and `public` subnet only

## Usage
Example on how to use module

```
module "vpc" {
  source = "github.com/mozilla-it/terraform-modules//vpc"
  region = "us-west-2"
  tags   = {
    Name      = "MyVPC"
    Region    = "us-west-2"
    Terraform = "true"
  }
}
```
