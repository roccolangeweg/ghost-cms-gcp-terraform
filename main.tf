provider "google" {
  project = var.GCP_PROJECT_ID
  region  = var.GCP_REGION
  zone    = var.GCP_ZONE
}

resource "google_project_service" "servicenetworking" {
  service = "servicenetworking.googleapis.com"
}

resource "google_project_service" "run" {
  service = "run.googleapis.com"
}