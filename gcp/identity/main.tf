
resource "google_service_account" "gsa" {
  account_id = var.name
  project    = var.project_id
  provider   = google-beta
}

resource "google_project_iam_member" "iam" {
  project  = var.project_id
  role     = "roles/secretmanager.admin"
  member   = "serviceAccount:${google_service_account.gsa.email}"
  provider = google-beta
}

resource "google_project_iam_member" "iam-logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

resource "kubernetes_service_account" "ksa" {
  metadata {
    namespace = "default"
    name = var.name
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.gsa.email
    }
  }
  automount_service_account_token = true
  depends_on = [
    var.gke_cluster,
  ]
}

resource "google_service_account_iam_binding" "ksa-gsa-binding" {
  provider = google-beta
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${kubernetes_service_account.ksa.metadata.0.namespace}/${kubernetes_service_account.ksa.metadata.0.name}]",
  ]

  depends_on = [
    kubernetes_service_account.ksa,
  ]

}

