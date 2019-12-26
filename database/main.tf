
variable "type" { default = "mysql" }

variable "name" { }

variable "storage_gb" { default = 20 }

variable "storage_type" { default = "gp2" }

variable "instance" { default = "db.t3.medium" }

variable "environment" { default = "dev" }

variable "region" { default = "us-west-2" }

variable "username" { default = "" }

variable "version" { default = "" }

variable "cost_center" { }

variable "project" { default = "" }

variable "subnets" { default = [] }

variable "vpc_id" { }

locals {
  ports = {
    mysql = 3306
    postgres = 5432
  }
  versions = {
    mysql = "5.7"
    postgres = "11.4"
  }
  ver = "${var.version != "" ? var.version : lookup(local.versions,var.type)}"
  project = "${var.project != "" ? var.project : var.name}"
  username = "${var.username != "" ? var.username : var.name}"
}

resource "random_string" "password" {
  length  = 16
  special = false
}

data "aws_vpc" "this" {
  id = "${var.vpc_id}"
}

resource "aws_db_subnet_group" "subnet" {
  name       = "${var.name}-subnet_group"
  subnet_ids = ["${var.subnets}"]
}

resource "aws_security_group" "default" {
  vpc_id = "${var.vpc_id}"

  ingress {
    description = "${var.type}"
    from_port   = "${lookup(local.ports,var.type)}"
    to_port     = "${lookup(local.ports,var.type)}"
    protocol    = "TCP"
    cidr_blocks = ["${data.aws_vpc.this.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name      = "${var.name}-${var.environment}-rds-sg"
    Project   = "${local.project}"
    Region    = "${var.region}"
    Terraform = "true"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = "${var.storage_gb}"
  storage_type           = "${var.storage_type}"
  engine                 = "${var.type}"
  engine_version         = "${local.ver}"
  instance_class         = "${var.instance}"
  name                   = "${var.name}-${var.environment}"
  identifier             = "${var.name}-${var.environment}"
  username               = "${local.username}"
  password               = "${random_string.password.result}"
  db_subnet_group_name   = "${aws_db_subnet_group.subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  skip_final_snapshot    = "true"

  tags {
    Name        = "${var.name}-${var.environment}"
    Project     = "${local.project}"
    Region      = "${var.region}"
    Environment = "${var.environment}"
    Terraform   = "true"
    CostCenter  = "${var.cost_center}"
  }
}

output "endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}

output "username" { 
  value = "${local.username}"
}

output "password" {
  value = "${random_string.password.result}"
}
