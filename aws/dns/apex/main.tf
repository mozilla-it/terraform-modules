
resource "aws_route53_delegation_set" "this" {
  lifecycle {
    create_before_destroy = true
  }

  reference_name = var.domain
}

resource "aws_route53_zone" "this" {
  name = var.domain

  delegation_set_id = aws_route53_delegation_set.this.id

  tags = {
    Name      = var.domain
    Purpose   = "${var.domain} master zone"
    Terraform = "true"
  }
}
