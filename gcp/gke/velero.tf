locals {
  bucket_name = "velero-${var.name}-${data.google_project.project.number}"
  sa_name     = "velero-${var.name}-sa"
}

resource "kubernetes_namespace" "velero" {
  count = local.cluster_features["velero"] ? 1 : 0

  metadata {
    name = "velero"

    labels = {
      app = "velero"
    }
  }

  depends_on = [module.gke]
}

# TODO: Figure out encryption at rest stuff
resource "google_storage_bucket" "bucket" {
  count         = local.cluster_features["velero"] ? 1 : 0
  name          = local.bucket_name
  location      = "US"
  storage_class = "STANDARD"

  labels = {
    "name"       = local.bucket_name
    "costcenter" = var.costcenter
    "terraform"  = "true"
  }
}

# TODO: See if we can use https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/workload-identity
resource "google_service_account" "velero" {
  count        = local.cluster_features["velero"] ? 1 : 0
  project      = var.project_id
  account_id   = local.sa_name
  display_name = local.sa_name
  description  = "Service account for velero on cluster ${local.name}"
}

resource "google_project_iam_custom_role" "velero" {
  count       = local.cluster_features["velero"] ? 1 : 0
  role_id     = "velero.server.${replace(local.name, "-", "_")}"
  title       = "Velero Server ${local.name}"
  description = "Custom role for velero on cluster ${local.name}"

  permissions = [
    "compute.disks.get",
    "compute.disks.create",
    "compute.disks.createSnapshot",
    "compute.snapshots.get",
    "compute.snapshots.create",
    "compute.snapshots.useReadOnly",
    "compute.snapshots.delete",
    "compute.zones.get",
    "iam.serviceAccounts.signBlob"
  ]
}

resource "google_project_iam_member" "velero" {
  count  = local.cluster_features["velero"] ? 1 : 0
  member = "serviceAccount:${google_service_account.velero[0].email}"
  role   = google_project_iam_custom_role.velero[0].id
}

resource "google_storage_bucket_iam_member" "velero_server" {
  count  = local.cluster_features["velero"] ? 1 : 0
  bucket = google_storage_bucket.bucket[0].name
  member = "serviceAccount:${google_service_account.velero[0].email}"
  role   = "roles/storage.objectAdmin"
}
