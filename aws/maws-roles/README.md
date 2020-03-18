# maws-roles
This creates roles that we can assume into using an OIDC provider

## Usage

If you know the policy ARN of a pre-existing policy that AWS has you can just reference it

```
module "admin_role" {
  source     = "github.com/mozila-it/terraform-modules//aws/maws-roles?ref=master"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
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
  source     = "github.com/mozila-it/terraform-modules//aws/maws-roles?ref=master"
  policy_arn = aws_iam_policy.policy.arn
}
```

## Inputs

| Input                   | Description                                                       |
|-------------------------|-------------------------------------------------------------------|
| `idp_client_id`         | This is the client_id of the auth0 idp, an optional value         |
| `max_session_duration`  | Max session time before your session exires (Default: 43200       |
| `policy_arn`            | The mozillians or ldap group you want to grant access to the role |
