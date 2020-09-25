
resource "aws_route53_zone" "subdomain" {
  name = var.domain

  tags = {
    "Name"      = var.domain
    "Terraform" = "true"
  }
}

resource "aws_route53_record" "ns" {
  zone_id = var.apex_zone_id
  name    = var.domain
  type    = "NS"
  ttl     = var.nsrecord_ttl
  records = var.nameservers
}
