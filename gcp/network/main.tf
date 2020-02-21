resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = var.project_id
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "allow_icmp" {
  project = var.project_id
  name    = "allow-icmp"
  network = google_compute_network.main.name

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_all_internal" {
  project = var.project_id
  name    = "allow-all-internal"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  # XXX: This is some magical default from auto_create_subnets...
  source_ranges = ["10.128.0.0/9"]
}

resource "google_compute_router" "router_us_west1" {
  project = var.project_id
  name    = "router"
  region  = "us-west1"
  network = google_compute_network.main.self_link
}

resource "google_compute_router_nat" "simple_nat_us_west1" {
  project                            = var.project_id
  name                               = "us-west1-nat-1"
  router                             = google_compute_router.router_us_west1.name
  region                             = "us-west1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_router" "router_us_central1" {
  project = var.project_id
  name    = "router"
  region  = "us-central1"
  network = google_compute_network.main.self_link
}

resource "google_compute_router_nat" "simple_nat_us_central1" {
  project                            = var.project_id
  name                               = "us-central1-nat-1"
  router                             = google_compute_router.router_us_central1.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

