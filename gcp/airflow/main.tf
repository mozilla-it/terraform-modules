locals {
  project_id = "${var.project}-${var.environment}"

  labels = {
    cost_center  = var.cost_center
    project_code = var.project_code
  }
}

resource "google_service_account" "airflow" {
  project    = local.project_id
  account_id = "airflow"
}

resource "google_project_iam_member" "airflow_worker" {
  project = local.project_id
  role    = "roles/composer.worker"
  member  = "serviceAccount:${google_service_account.airflow.email}"
}

resource "google_project_iam_member" "airflow_worker_logging" {
  project = local.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.airflow.email}"
}

resource "google_project_iam_member" "airflow_worker_monitoring" {
  project = local.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.airflow.email}"
}

resource "google_project_iam_member" "airflow_worker_bigquery" {
  project = local.project_id
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${google_service_account.airflow.email}"
}

resource "google_project_iam_member" "airflow_worker_bigquery_editor" {
  project = local.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.airflow.email}"
}

resource "google_composer_environment" "etl_airflow" {
  project  = local.project_id
  provider = google-beta
  name     = "etl-airflow-${var.project}-${var.environment}-${terraform.workspace}"
  region   = var.region

  timeouts {
    create = "180m"
  }

  # if we destroy airflow we lose all job histories and that could be bad?
  # Instead, we should either:
  # 1. create a new airflow, and migrate everything to that (start_date and end_date in DAGs would help)
  # or
  # 2. set-up airflow ourselves so we can manage the database, GKE cluster, and web instance all separately
  #
  lifecycle {
    prevent_destroy = "true"
  }

  config {
    node_count = var.node_count_default # this does not appear to be changable after creation

    node_config {
      zone         = "us-central1-a"
      machine_type = var.machine_type_default

      disk_size_gb = var.disk_size_gb_default

      network = var.network

      service_account = google_service_account.airflow.email
    }

    software_config {
      image_version = var.composer_image_version

      airflow_config_overrides = {
        core-dags_are_paused_at_creation = "True"
        core-max_active_runs_per_dag     = "64"
        core-dag_concurrency             = "64"
        core-parallelism                 = "64"
        core-max_active_runs_per_dag     = "64"
        core-dagbag_import_timeout       = "90"
        celery-worker_concurrency        = "16"
        scheduler-catchup_by_default     = "False"
      }

      env_variables = {
        gcp_project        = "${var.project}-${var.environment}"
        gcp_admin_project  = var.admin_project
        bq_tag             = "master"
        di_tag             = "master"
        job_container_tag  = "master"
        SENDGRID_MAIL_FROM = var.sendgrid_mail_from
        SENDGRID_API_KEY   = var.sendgrid_api_key
        project            = "${var.project}-${var.environment}"
        project_id         = "${var.project}-${var.environment}"
      }
    }
  }

  labels = local.labels
}

resource "google_container_node_pool" "airflow" {
  project     = local.project_id
  name_prefix = "airflow-"
  cluster = element(
    split(
      "/",
      google_composer_environment.etl_airflow.config[0].gke_cluster,
    ),
    11,
  )

  #region = "${var.airflow_region}"
  location = "us-central1-a"

  initial_node_count = var.node_count_additional

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 16
  }

  node_config {
    machine_type    = var.machine_type_additional
    disk_size_gb    = var.disk_size_gb_additional
    service_account = google_service_account.airflow.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = local.labels
  }
}

