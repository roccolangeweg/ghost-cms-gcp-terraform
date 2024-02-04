resource "google_compute_network" "ghost-cms-vpc-network" {
  name = "ghost-cms-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "ghost-cms-vpc-subnetwork" {
  name          = "ghost-cms-vpc-subnetwork"
  network       = google_compute_network.ghost-cms-vpc-network.id
  ip_cidr_range = "10.2.0.0/16"
}

resource "google_vpc_access_connector" "ghost-cms-vpc-access-connector" {
  name    = "vpc-access-connector"
  ip_cidr_range = "10.4.0.0/28"
  machine_type = "f1-micro"

  subnet {
    name = google_compute_subnetwork.ghost-cms-vpc-subnetwork.name
  }
}
