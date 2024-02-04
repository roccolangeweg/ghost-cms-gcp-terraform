resource "google_cloud_run_v2_service" "ghost-cms" {
  name     = "ghost-cms"
  location = var.GCP_REGION
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {

    scaling {
      max_instance_count = 2
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.ghost-cms-mysql.connection_name]
      }
    }

    containers {
      image = "ghost:5.78.0"

      volume_mounts {
        mount_path = "/cloudsql"
        name       = "cloudsql"
      }

      ports {
        name           = "http1"
        container_port = 2368
      }

      env {
        name  = "database__client"
        value = "mysql"
      }

      env {
        name  = "database__connection__socketPath"
        value = "/cloudsql/${google_sql_database_instance.ghost-cms-mysql.connection_name}"
      }

      env {
        name  = "database__connection__user"
        value = google_sql_user.ghost-cms-mysql-user.name
      }

      env {
        name  = "database__connection__password"
        value = google_sql_user.ghost-cms-mysql-user.password
      }

      env {
        name  = "database__connection__database"
        value = google_sql_database.ghost-cms-mysql-database.name
      }
    }
  }
}