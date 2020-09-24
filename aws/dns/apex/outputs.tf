output "delegation_set_ns" {
  value = aws_route53_delegation_set.this.name_servers
}

output "delegation_set_id" {
  value = aws_route53_delegation_set.this.id
}

output "zone_name" {
  value = var.domain
}

output "zone_id" {
  value = aws_route53_zone.this.zone_id
}
