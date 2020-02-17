locals {
  ports = {
    mysql    = 3306
    postgres = 5432
  }

  versions = {
    mysql    = "5.7"
    postgres = "11.4"
  }

  default_tags = {
    Project     = local.project
    Region      = var.region
    Environment = var.environment
    Terraform   = "true"
    CostCenter  = var.cost_center
  }

  ver        = var.version != "" ? var.version : local.versions[var.type]
  project    = var.project != "" ? var.project : var.name
  username   = var.username != "" ? var.username : var.name
  identifier = var.identifier != "" ? var.identifier : var.name
  tags       = merge(var.extra_tags, local.default_tags)
}

resource "random_password" "password" {
  length  = var.password_length
  special = false
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

resource "aws_db_subnet_group" "subnet" {
  name       = "${var.identifier}-subnet_group"
  subnet_ids = var.subnets
}

resource "aws_security_group" "default" {
  name   = "${var.identifier}-security_group"
  vpc_id = var.vpc_id

  ingress {
    description = var.type
    from_port   = local.ports[var.type]
    to_port     = local.ports[var.type]
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${var.name}-${var.environment}-rds-sg"
    },
  )
}

resource "aws_db_instance" "default" {
  allocated_storage      = var.storage_gb
  storage_type           = var.storage_type
  engine                 = var.type
  engine_version         = local.ver
  instance_class         = var.instance
  name                   = var.name
  identifier             = var.identifier
  username               = local.username
  password               = random_password.password.result
  db_subnet_group_name   = aws_db_subnet_group.subnet.id
  vpc_security_group_ids = [aws_security_group.default.id]
  skip_final_snapshot    = "true"
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az
  ca_cert_identifier     = var.ca_cert_identifier
  apply_immediately      = var.apply_immediately

  tags = merge(
    local.tags,
    {
      "Name" = var.name
    },
  )
}

