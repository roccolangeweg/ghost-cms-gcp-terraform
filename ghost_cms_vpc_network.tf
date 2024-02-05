resource "google_compute_network" "ghost_cms_vpc_network" {
  name                    = "ghost-cms-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "ghost_cms_vpc_subnetwork" {
  name          = "ghost-cms-vpc-subnetwork"
  network       = google_compute_network.ghost_cms_vpc_network.id
  ip_cidr_range = "10.2.0.0/32"
}