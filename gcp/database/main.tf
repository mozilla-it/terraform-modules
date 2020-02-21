resource "google_sql_database_instance" "master" {
  name             = "${var.name}"
  database_version = "${var.ver}"

  settings {
    tier = "${var.tier}"

    ip_configuration {
      ipv4_enabled = true

      authorized_networks = [{
        value = "${var.network}"
      }]
    }
  }
}

resource "random_password" "password" {
  length  = 24
  special = false
}

resource "google_sql_user" "user" {
  name     = "${var.username}"
  instance = "${google_sql_database_instance.master.name}"
  password = "${random_password.password.result}"
}

resource "google_sql_database" "database" {
  name     = "${var.database}"
  instance = "${google_sql_database_instance.master.name}"
}
