output "endpoint" {
  value = google_container_cluster.primary.endpoint
}
output "ca_cert" {
  value = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
}

