
resource "aws_route53_zone" "subdomain" {
  name              = var.domain_name
  delegation_set_id = var.delegation_set_id

  tags = {
    "Name"      = var.domain_name
    "Terraform" = "true"
  }
}
