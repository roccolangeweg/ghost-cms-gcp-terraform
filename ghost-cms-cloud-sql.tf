resource "random_password" "ghost-cms-mysql-password" {
  length = 16
  special = true
}

resource "google_sql_database_instance" "ghost-cms-mysql" {
  name = "ghost-cms-mysql-1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      private_network = google_compute_network.ghost-cms-vpc-network.self_link
    }
  }

  # Creating an instance takes around ~18 minutes, so we need to increase the timeout from default (15).
  timeouts {
    create = "30m"
  }
}

resource "google_sql_database" "ghost-cms-mysql-database"{
  name="ghost-cms"
  instance=google_sql_database_instance.ghost-cms-mysql.name
}

resource "google_sql_user" "ghost-cms-mysql-user" {
  name = "ghost-cms"
  instance = google_sql_database_instance.ghost-cms-mysql.name
  password = random_password.ghost-cms-mysql-password.result
}