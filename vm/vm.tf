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

resource "google_compute_network" "vm-network" {
  name = "terraform-vm-network"
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_subnetwork" "vm-subnet" {
  name          = "terraform-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vm-network.name
  region        = var.REGION
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance" "vm-instance" {
  name         = "terraform-vm-instance"
  zone         = var.ZONE
  machine_type = "n1-standard-4"
  boot_disk {
    initialize_params {
      image = "ubuntu-1608-lts"
      size  = 10
    }
  }
  labels = {
    hoge = "foo"
    huga = "bar"
  }
  network_interface {
    network_ip = "10.0.1.11"
    subnetwork = "terraform-subnet"
    access_config {}
  }
}
