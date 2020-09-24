
output "zone_id" {
  value = aws_route53_zone.subdomain.zone_id
}

output "name_servers" {
  value = aws_route53_zone.subdomain.name_servers
}
