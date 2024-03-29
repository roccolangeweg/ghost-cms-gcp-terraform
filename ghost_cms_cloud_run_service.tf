resource "google_cloud_run_v2_service" "ghost_cms" {
  name     = "ghost-cms"
  location = var.GCP_REGION
  ingress  = "INGRESS_TRAFFIC_ALL"

  launch_stage = "BETA"

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
        value = google_sql_database_instance.ghost_cms_mysql.private_ip_address
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

      env {
        name  = "url"
        value = "https://ghost-cms-flbmbye73a-ez.a.run.app"
      }

      env {
        name  = "mail__transport"
        value = "SMTP"
      }

      env {
        name  = "mail__options__service"
        value = "Mailgun"
      }

      env {
        name  = "mail__options__auth__user"
        value = var.GHOST_CMS_MAILGUN_USERNAME
      }

      env {
        name  = "mail__options__auth__pass"
        value = var.GHOST_CMS_MAILGUN_PASSWORD
      }

      env {
        name = "mail__from"
        value = var.GHOST_CMS_MAIL_FROM
      }

      env {
        name  = "mail__options__host"
        value = "smtp.eu.mailgun.org"
      }
    }
  }
}

data "google_iam_policy" "ghost_cms" {
  binding {
    role    = "roles/run.invoker"
    members = [
      "allUsers"
    ]
  }
}

resource "google_cloud_run_v2_service_iam_policy" "ghost_cms" {
  policy_data = data.google_iam_policy.ghost_cms.policy_data
  name        = google_cloud_run_v2_service.ghost_cms.name
}