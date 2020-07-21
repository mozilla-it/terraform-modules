
locals {
  cidr_map = {
    for region in var.regions :
    region => cidrsubnet(
      var.base_cidr, var.cidr_bit, index(var.regions, region) % length(var.regions)
    )
  }

  subnet_settings = flatten([
    for region, cidr in local.cidr_map : [
      {
        subnet_name           = "${var.vpc_name}-subnet-${region}",
        subnet_ip             = cidr,
        subnet_region         = region,
        subnet_private_access = true
      }
    ]
  ])
}

module "vpc" {
  source                  = "terraform-google-modules/network/google"
  version                 = "~> 2.4"
  project_id              = var.project_id
  network_name            = var.vpc_name
  routing_mode            = var.routing_mode
  auto_create_subnetworks = var.auto_create_subnetworks

  # Subnet setting
  subnets = var.auto_create_subnetworks ? [] : local.subnet_settings
}
