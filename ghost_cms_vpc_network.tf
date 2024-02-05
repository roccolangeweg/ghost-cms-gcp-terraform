resource "google_compute_network" "ghost_cms_vpc_network" {
  name                    = "ghost-cms-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_global_address" "ghost_cms_vpc_global_address" {
  provider      = google-beta
  name          = "ghost-cms-vpc-global-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.ghost_cms_vpc_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = google_compute_network.ghost_cms_vpc_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.ghost_cms_vpc_global_address.name]
}

resource "google_compute_subnetwork" "ghost_cms_vpc_subnetwork" {
  name          = "ghost-cms-vpc-subnetwork"
  network       = google_compute_network.ghost_cms_vpc_network.id
  ip_cidr_range = "10.2.0.0/32"
}