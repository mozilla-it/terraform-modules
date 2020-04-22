# IT SE Delegated role
Module that creates roles on accounts to allow delegated access  from another account. It will create 3 different roles.

* itsre-admin		- Admin role
* itsre-readonly	- Readonly role
* itsre-poweruser	- Similar to admin but can't do any IAM tasks

## Usage

```hcl
module "roles" {
  source = "github.com/mozilla-it/terraform-modules//aws/itse-roles?ref=master
}
```
