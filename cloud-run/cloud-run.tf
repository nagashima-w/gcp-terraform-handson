terraform {
  required_version = "= 0.12.26"
}

variable "CREDENTIAL" {}
variable "PROJECT" {}
variable "REGION" {}
variable "ZONE" {}

provider "google" {
  credentials = file(var.CREDENTIAL)
  project     = var.PROJECT
  region      = var.REGION
}

resource "google_cloud_run_service" "cloud-run" {
  name     = "nginx-cloud-run"
  location = var.REGION
  template {
    spec {
      containers {
        image = "nginx:latest"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.cloud-run.location
  project     = google_cloud_run_service.cloud-run.project
  service     = google_cloud_run_service.cloud-run.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

output "url" {
  value = "${google_cloud_run_service.cloud-run.*.url}"
}