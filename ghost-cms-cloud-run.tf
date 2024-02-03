resource "google_cloud_run_v2_service" "ghost-cms" {
  name     = "ghost-cms"
  location = var.GCP_REGION
  ingress = "INGRESS_TRAFFIC_ALL"

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
    }
  }
}