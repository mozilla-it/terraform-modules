# rand-password module
Generates random password and stores them in either AWS secrets manager or AWS SSM based on the input

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
| Inputs             | Description                                                                     |
| -------------------|---------------------------------------------------------------------------------|
| `enabled`          | Enable or disable this module (default: `true`)                                 |
| `environment`      | Name of the environment, used for path of password store                        |
| `service_name`     | Name of the service that you are generating password for                        |
| `keyname`          | Name of the key that stores the password (default: `keyname`)                   |
| `password_config`  | Config map for randomly generated password                                      |
| `password_store`   | Backend store for random password, allowed value is `ssm` or `secretsmanager`   |

## Outputs
| Outputs          | Description                    |
|------------------|--------------------------------|
| `password_store` | Name of the password store     |
| `password`       | Password that gets generated   |
