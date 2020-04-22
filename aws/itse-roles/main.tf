provider "aws" {
  region  = var.region
  version = "~> 2"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.external_account_id}:root"]
    }
  }
}

resource "aws_iam_role" "admin_role" {
  name                 = "itsre-admin"
  description          = "IT SRE Delegated Admin role"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name      = "itsre-admin"
    Purpose   = "IT SRE delegated role"
    Terraform = "true"
  }
}

resource "aws_iam_role" "readonly_role" {
  name                 = "itsre-readonly"
  description          = "IT SRE Delegated  Readonly role"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name      = "itsre-admin"
    Purpose   = "IT SRE delegated role"
    Terraform = "true"
  }
}

resource "aws_iam_role" "poweruser_role" {
  name                 = "itsre-poweruser"
  description          = "IT SRE Delegated PowerUser role"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name      = "itsre-admin"
    Purpose   = "IT SRE delegated role"
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "readonly_attach" {
  role       = aws_iam_role.readonly_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "poweruser_attach" {
  role       = aws_iam_role.poweruser_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
