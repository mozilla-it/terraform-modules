
locals {
  password_path = "/${var.environment}/${var.service_name}/${var.keyname}"

  password_defaults = {
    length      = "24"
    special     = true
    lower       = true
    upper       = true
    min_numeric = 2
  }
  password_config = merge(var.password_config, local.password_defaults)

  default_tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "random_password" "password" {
  count       = var.enabled ? 1 : 0
  length      = local.password_config["length"]
  special     = local.password_config["special"]
  upper       = local.password_config["upper"]
  lower       = local.password_config["lower"]
  min_numeric = local.password_config["min_numeric"]
}

resource "aws_ssm_parameter" "secret" {
  count = var.password_store == "ssm" ? var.enabled ? 1 : 0 : 0
  name  = local.password_path
  type  = "SecureString"
  value = random_password.password[0].result
  tags  = merge({ "Name" = var.service_name }, local.default_tags)
}

resource "aws_secretsmanager_secret" "secret" {
  count = var.password_store == "secretsmanager" ? var.enabled ? 1 : 0 : 0
  name  = local.password_path
  tags  = merge({ "Name" = var.service_name }, local.default_tags)
}

resource "aws_secretsmanager_secret_version" "secret" {
  count         = var.password_store == "secretsmanager" ? var.enabled ? 1 : 0 : 0
  secret_id     = aws_secretsmanager_secret.secret[0].id
  secret_string = random_password.password[0].result
}
