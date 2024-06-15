resource "google_compute_address" "bastion" {
  name    = "${var.app_name}-bastion-public-ip"
  project = var.project
  region  = var.region
}

resource "google_compute_firewall" "ssh" {
  name          = "${var.app_name}-bastionssh"
  network       = var.network.self_link
  project       = var.project
  source_tags   = ["allow-ssh"]
  target_tags   = ["allow-ssh"]
  source_ranges = var.ssh_whitelist

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
