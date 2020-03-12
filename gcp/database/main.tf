resource "google_sql_database_instance" "master" {
  name             = var.name
  database_version = var.ver

  settings {
    tier = var.tier

    backup_configuration {
      enabled = var.backups_enabled
    }

    ip_configuration {
      ipv4_enabled = true

      dynamic "authorized_networks" {
        for_each = var.authorized_ips
        iterator = allowed_ip

        content {
            name  = allowed_ip.value.name
            value = allowed_ip.value.ip_range
        }
      }
    }
  }
}

resource "random_password" "password" {
  length  = 24
  special = false
}

resource "google_sql_user" "user" {
  name     = var.username
  instance = google_sql_database_instance.master.name
  password = random_password.password.result
}

resource "google_sql_database" "database" {
  name     = var.database
  instance = google_sql_database_instance.master.name
}

