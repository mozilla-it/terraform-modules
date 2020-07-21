output "network" {
  value       = module.vpc
  description = "The created network"
}

output "network_self_link" {
  value       = module.vpc.network_self_link
  description = "The URI of the VPC being created"
}

output "network_name" {
  value = module.vpc.network_name
}

output "project_id" {
  value = module.vpc.project_id
}

output "subnets" {
  value = module.vpc.subnets
}

output "subnets_names" {
  value       = module.vpc.subnets_names
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = module.vpc.subnets_ips
  description = "The IPs and CIDRs of the subnets being created"
}

output "subnets_regions" {
  value       = module.vpc.subnets_regions
  description = "The region where the subnets will be created"
}

output "subnets_private_access" {
  value       = module.vpc.subnets_private_access
  description = "Whether the subnets will have access to Google API's without a public IP"
}

output "router_ids" {
  value = var.create_cloud_nat ? google_compute_router.router.*.id : [""]
}

output "nat_ids" {
  value = var.create_cloud_nat ? google_compute_router_nat.nat.*.id : [""]
}
