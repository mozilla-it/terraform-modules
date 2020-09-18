
resource "aws_route53_delegation_set" "this" {
  lifecycle {
    create_before_destroy = true
  }

  reference_name = var.domain_name
}

resource "aws_route53_zone" "this" {
  name = var.domain_name

  delegation_set_id = aws_route53_delegation_set.this.id

  tags = {
    Name      = var.domain_name
    Purpose   = "${var.domain_name} master zone"
    Terraform = "true"
  }
}
