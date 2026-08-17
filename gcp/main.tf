terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Backend remoto recomendado para uso em equipe/produção.
  # Descomente e configure um bucket GCS dedicado ao state.
  # backend "gcs" {
  #   bucket = "my-terraform-state-bucket"
  #   prefix = "multicloud/gcp"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "random_id" "suffix" {
  byte_length = 4
}

# ---------------------------------------------------------------------------
# Rede: VPC, Subnet, Firewall
# ---------------------------------------------------------------------------

resource "google_compute_network" "main" {
  name                    = "${var.instance_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "${var.instance_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id
}

resource "google_compute_firewall" "allow_ssh_http" {
  name    = "${var.instance_name}-allow-ssh-http"
  network = google_compute_network.main.id

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = var.ssh_source_ranges
  target_tags   = ["cloud-reliability"]
}

# ---------------------------------------------------------------------------
# Computação: Compute Engine
# ---------------------------------------------------------------------------

resource "google_compute_instance" "main" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["cloud-reliability"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.id

    access_config {
      # Bloco vazio atribui um IP público efêmero
    }
  }

  labels = var.labels
}

# ---------------------------------------------------------------------------
# Storage: Cloud Storage Bucket
# ---------------------------------------------------------------------------

resource "google_storage_bucket" "main" {
  name                        = var.bucket_name != "" ? var.bucket_name : "cloud-reliability-${random_id.suffix.hex}"
  location                    = var.bucket_location
  force_destroy                = true
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = var.labels
}
