data "google_compute_network" "gke_network" {
  name    = "default"
  project = var.project_id
}

module "gke" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  project_id = var.project_id
  name       = var.project_id
  region     = var.region
  network    = "default"
  subnetwork = "default"

  ip_range_pods = ""

  ip_range_services          = ""
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = true
  regional                   = true
  grant_registry_access      = true
  monitoring_service         = "monitoring.googleapis.com/kubernetes"
  logging_service            = "logging.googleapis.com/kubernetes"

  identity_namespace = "${var.project_id}.svc.id.goog"

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-1"
      min_count          = 1
      max_count          = 100
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_labels = {
    all = var.labels
    default-node-pool = {
      default-node-pool = true
    }
  }
}

