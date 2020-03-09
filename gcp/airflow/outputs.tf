output "dag_gcs_prefix" {
  value = google_composer_environment.etl_airflow.config[0].dag_gcs_prefix
}

