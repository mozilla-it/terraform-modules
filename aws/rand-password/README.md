# rand-password module
Generates random password and stores them in either AWS secrets manager or AWS SSM based on the input

The resource that generates the password can be found [here](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)

The password generated has a length of `24` characters and contains special characters, lower and upper cases and a minimum numeric character of `2`

```hcl
  password_defaults = {
    length      = "24"
    special     = true
    lower       = true
    upper       = true
    min_numeric = 2
  }
```


## Usage
Example Usage:

```hcl
module "password" {
  source         = "github.com/mozilla-it/terraform-modules//aws/rand-password?ref=master"
  environment    = "stage"
  service_name   = "my-test-app"
  password_store = "ssm"
}
```

## Inputs
| Inputs             | Description                                                                                                                                                               |
| -------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `enabled`          | Enable or disable this module (default: `true`)                                                                                                                           |
| `environment`      | Name of the environment, used for path of password store                                                                                                                  |
| `service_name`     | Name of the service that you are generating password for                                                                                                                  |
| `keyname`          | Name of the key that stores the password (default: `keyname`)				                                                                                             |
| `password_path`    | The SSM and Secrets Manager path. Defaults to empty path, if its empty path it will build a path in the form of `/${var.environment}/${var.service_name}/${var.keyname}`  |
| `password_config`  | Config map for randomly generated password                                                                                                                                |
| `password_store`   | Backend store for random password, allowed value is `ssm` or `secretsmanager`                                                                                             |

## Outputs
| Outputs          | Description                    |
|------------------|--------------------------------|
| `password_store` | Name of the password store     |
| `password_path`  | Path where password is stored  |
| `password`       | Password that gets generated   |
