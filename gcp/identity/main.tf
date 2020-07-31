locals {

  # Shamelessly stolen from https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/7.1.0/submodules/workload-identity
  k8s_sa_gcp_derived_name = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.name}]"
  gsa_email               = var.enabled ? google_service_account.gsa[0].email : ""
  gsa_fqdn                = var.enabled ? "serviceAccount:${google_service_account.gsa[0].email}" : null

  # This will cause terraform to block returning outputs until the service account is created
  output_k8s_name      = var.create_ksa ? kubernetes_service_account.ksa[0].metadata[0].name : var.name
  output_k8s_namespace = var.create_ksa ? kubernetes_service_account.ksa[0].metadata[0].namespace : var.namespace
}

resource "google_service_account" "gsa" {
  count      = var.enabled ? 1 : 0
  account_id = var.name
  project    = var.project_id
  provider   = google-beta
}

# NOTE: Consider moving this outside of this module?
#       This allows accessing of secrets versions and viewing of secrets
#       should really figure out how to scope this as well
resource "google_project_iam_member" "iam" {
  count    = var.enabled && var.additional_permissions ? 1 : 0
  project  = var.project_id
  role     = "roles/secretmanager.secretAccessor"
  member   = local.gsa_fqdn
  provider = google-beta
}

resource "google_project_iam_member" "iam-secret-viewing" {
  count    = var.enabled && var.additional_permissions ? 1 : 0
  project  = var.project_id
  role     = "roles/secretmanager.viewer"
  member   = local.gsa_fqdn
  provider = google-beta
}

resource "google_project_iam_member" "iam-logging" {
  count   = var.enabled && var.additional_permissions ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = local.gsa_fqdn
}

resource "kubernetes_service_account" "ksa" {
  count = var.enabled && var.create_ksa ? 1 : 0
  metadata {
    namespace = var.namespace
    name      = var.name
    annotations = {
      "iam.gke.io/gcp-service-account" = local.gsa_email
    }
  }
  automount_service_account_token = true
  depends_on = [
    var.gke_cluster,
  ]
}

resource "google_service_account_iam_binding" "ksa-gsa-binding" {
  count              = var.enabled ? 1 : 0
  provider           = google-beta
  service_account_id = google_service_account.gsa[0].name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    local.k8s_sa_gcp_derived_name
  ]
}
