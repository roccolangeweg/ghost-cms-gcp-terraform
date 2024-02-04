resource "google_cloud_run_v2_service" "ghost-cms" {
  name     = "ghost-cms"
  location = var.GCP_REGION
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {

    scaling {
      max_instance_count = 2
    }

    vpc_access {
      connector = google_vpc_access_connector.ghost-cms-vpc-access-connector.id
      egress = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = "ghost:5.78.0"

      ports {
        name           = "http1"
        container_port = 2368
      }

      env {
        name  = "database__client"
        value = "mysql"
      }

      env {
        name  = "database__connection__host"
        value = google_sql_database_instance.ghost-cms-mysql.private_ip_address
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