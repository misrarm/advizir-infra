resource "google_compute_firewall" "default-allow-icmp" {
  project = var.project_id
  name    = "default-allow-icmp-tcp"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}
