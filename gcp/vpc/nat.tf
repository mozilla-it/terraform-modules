# NOTE: Creates a cloud nat in every region

locals {
  cloud_nat_settings_defaults = {
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  }

  cloud_nat_settings = merge(local.cloud_nat_settings_defaults, var.cloud_nat_settings)
}

resource "google_compute_router" "router" {
  count   = var.create_cloud_nat ? length(var.regions) : 0
  name    = "${var.vpc_name}-router-${var.regions[count.index]}"
  network = module.vpc.network_self_link
  region  = var.regions[count.index]
}

resource "google_compute_router_nat" "nat" {
  count                              = var.create_cloud_nat ? length(var.regions) : 0
  name                               = "${var.vpc_name}-nat-${var.regions[count.index]}"
  router                             = google_compute_router.router[count.index].name
  region                             = var.regions[count.index]
  nat_ip_allocate_option             = local.cloud_nat_settings["nat_ip_allocate_option"]
  source_subnetwork_ip_ranges_to_nat = local.cloud_nat_settings["source_subnetwork_ip_ranges_to_nat"]

}
