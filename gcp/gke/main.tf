
resource "google_container_cluster" "primary" {
  name     = var.name
  location = var.region
  provider = google-beta

  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  addons_config {
    http_load_balancing {
      disabled = var.http_load_balancing_disabled
    }
    istio_config {
      disabled = var.istio_disabled
    }
  }
}

resource "google_container_node_pool" "default" {
  name       = "default-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  provider   = google-beta
  node_count = var.initial_node_count

  autoscaling {
    min_node_count = 1
    max_node_count = 100
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 3
    max_unavailable = 1
  }

  node_config {
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
    preemptible  = false
    machine_type = var.node_type

    metadata = {
      disable-legacy-endpoints = true
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
