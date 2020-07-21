#NOTE:  These firewall rules mimic what is there on the default vpc
#       We should figure out a better more secure firewall ruleset

resource "google_compute_firewall" "allow_icmp" {
  project  = var.project_id
  name     = "${var.vpc_name}-allow-icmp"
  network  = module.vpc.network_name
  priority = 65534

  allow {
    protocol = "icmp"
  }
}


resource "google_compute_firewall" "allow_all_internal" {
  project  = var.project_id
  name     = "${var.vpc_name}-allow-all-internal"
  network  = module.vpc.network_name
  priority = 65534

  allow {
    ports    = ["0-65535"]
    protocol = "tcp"
  }

  allow {
    ports    = ["0-65535"]
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    for cidr in module.vpc.subnets_ips : cidr
  ]
}

