locals {
  project_id = var.project_id
}

resource "google_compute_firewall" "default-allow-icmp" {
  name    = "default-allow-icmp"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "default"
  project = local.project_id
}
