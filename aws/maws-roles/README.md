# maws-roles
This module creates roles that we can be assumed using an OIDC provider.

## Usage

If you know the policy ARN of a pre-existing policy you can just reference it, like in the next example:

```
module "admin_role" {
  source       = "github.com/mozilla-it/terraform-modules//aws/maws-roles?ref=master"
  role_name    = "maws-admin"
  role_mapping = [ "team_foo" ]
  policy_arn   = "arn:aws:iam::aws:policy/AdministratorAccess"
}
```

If you want to create a specific role with specific permission you will need to create
the policy first and then attach it to the module

```
data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "test_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.example.json
}

module "role" {
  source       = "github.com/mozilla-it/terraform-modules//aws/maws-roles?ref=master"
  role_name    = "maws-role"
  role_mapping = [ "team_foo" ]
  policy_arn   = aws_iam_policy.policy.arn
}
```

## Inputs

| Input                   | Description                                                                              |
|-------------------------|------------------------------------------------------------------------------------------|
| `role_name`             | Name of the role you want created                                                        |
| `role_mapping`          | Name of the ldap or mozillian group you want to map to this role, can be multiple groups |
| `idp_client_id`         | This is the client_id of the auth0 idp, an optional value                                |
| `max_session_duration`  | Max session time before your session exires (Default: 43200)                             |
| `policy_arn`            | The mozillians or ldap group you want to grant access to the role                        |
| 'create_role'           | Set to false to do not perform any action on module instanciation                        |
