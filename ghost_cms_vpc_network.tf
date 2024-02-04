resource "google_compute_network" "ghost_cms_vpc_network" {
  name                    = "ghost-cms-vpc-network"
  auto_create_subnetworks = false

}

resource "google_compute_subnetwork" "ghost_cms_vpc_subnetwork" {
  name          = "ghost-cms-vpc-subnetwork"
  network       = google_compute_network.ghost_cms_vpc_network.id
  ip_cidr_range = "10.2.0.0/16"
}

resource "google_vpc_access_connector" "ghost_cms_vpc_connector" {
  name = "ghost-cms-vpc-connector"
  machine_type  = "f1-micro"

  subnet {
    name = google_compute_subnetwork.ghost_cms_vpc_subnetwork.name
  }

  depends_on = [google_project_service.vpcaccess]
}