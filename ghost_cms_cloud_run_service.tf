resource "google_cloud_run_v2_service" "ghost_cms" {
  name     = "ghost-cms"
  location = var.GCP_REGION
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {

    scaling {
      max_instance_count = 2
    }

    vpc_access {
      network_interfaces {
        network    = google_compute_network.ghost_cms_vpc_network.name
        subnetwork = google_compute_subnetwork.ghost_cms_vpc_subnetwork.name
      }
      egress = "ALL_TRAFFIC"
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
        value = google_sql_user.ghost_cms_mysql_user.name
      }

      env {
        name  = "database__connection__password"
        value = google_sql_user.ghost_cms_mysql_user.password
      }

      env {
        name  = "database__connection__database"
        value = google_sql_database.ghost_cms_mysql_database.name
      }
    }
  }
}