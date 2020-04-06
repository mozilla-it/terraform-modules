resource "google_logging_metric" "metric" {
  name    = "${var.name}-${terraform.workspace}"
  project = var.project
  filter  = "resource.type=global jsonPayload.Error_Code=${var.error_code}"

  metric_descriptor {
    metric_kind = var.metric_kind
    value_type  = var.value_type
  }
}

resource "google_monitoring_notification_channel" "notification-email" {
  count        = var.notification_path == "email-legacy" ? 1 : 0
  display_name = "${var.name}-${terraform.workspace}-${var.notification_path}"
  type         = "email"
  project      = var.project

  labels = {
    email_address = var.target
  }
}

resource "google_monitoring_notification_channel" "notification-pagerduty" {
  count        = var.notification_path == "pagerduty" ? 1 : 0
  display_name = "${var.name}-${terraform.workspace}-${var.notification_path}"
  type         = "pagerduty"
  project      = var.project

  labels = {
    service_key = var.target
  }
}

resource "google_monitoring_notification_channel" "notification-webhook" {
  count        = var.notification_path == "webhook" ? 1 : 0
  display_name = "${var.name}-${terraform.workspace}-${var.notification_path}"
  type         = "webhook_tokenauth"
  project      = var.project

  labels = {
    url = var.target
  }
}

resource "google_monitoring_alert_policy" "alert-policy-email" {
  count        = var.notification_path == "email-legacy" ? 1 : 0
  display_name = "${var.name}-${terraform.workspace}-${var.notification_path}"
  combiner     = "OR"
  project      = var.project

  conditions {
    display_name = "${var.name}-${terraform.workspace}-${var.notification_path}"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.metric.name}\" resource.type=\"global\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.alert_threshold

      aggregations {
        alignment_period   = var.alignment_period
        per_series_aligner = var.aligner
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.notification-email[0].id,
  ]
}

resource "google_monitoring_alert_policy" "alert-policy-webhook" {
  count        = var.notification_path == "webhook" ? 1 : 0
  display_name = "${var.name}-${terraform.workspace}-webhook"
  combiner     = "OR"
  project      = var.project

  conditions {
    display_name = "${var.name}-${terraform.workspace}-webhook"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.metric.name}\" resource.type=\"global\""
      duration        = "60s"
      comparison      = "COMPARISON_${var.operator}"
      threshold_value = var.alert_threshold

      aggregations {
        alignment_period   = var.alignment_period
        per_series_aligner = var.aligner
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.notification-webhook[0].id,
  ]
}

resource "google_monitoring_alert_policy" "alert-policy-pagerduty" {
  count        = var.notification_path == "pagerduty" ? 1 : 0
  display_name = "${var.name}-${terraform.workspace}-pagerduty"
  combiner     = "OR"
  project      = var.project

  conditions {
    display_name = "${var.name}-${terraform.workspace}-pagerduty"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.metric.name}\" resource.type=\"global\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.alert_threshold

      aggregations {
        alignment_period   = var.alignment_period
        per_series_aligner = var.aligner
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.notification-pagerduty[0].id,
  ]
}

