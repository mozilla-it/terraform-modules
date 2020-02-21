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
  name   = "the-name-of-your-vpc"
  tags   = {
    Name      = "MyVPC"
    Region    = "us-west-2"
    Terraform = "true"
  }
}
```

## Terraform versions
This module is compatible with Terraform 0.11 as well as with Terraform 0.12.
The example above assumes using Terraform 0.12. If your code is still using Terrafor 0.11 and you want to use this module,
change the parameter `source` in the example above adding `source = "github.com/mozilla-it/terraform-modules//vpc?ref=bf05773fd43e91c070364ce164b9fdec13c5a311`.
