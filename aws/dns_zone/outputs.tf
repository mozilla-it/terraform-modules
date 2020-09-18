output "delegation_set_ns" {
  value = aws_route53_delegation_set.this.name_servers
}

output "zone_name" {
  value = var.domain_name
}

output "zone_id" {
  value = aws_route53_zone.this.zone_id
}
