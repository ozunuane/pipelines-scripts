output "project" {
  value = var.gcp_project_id
}

output "network" {
  value = google_compute_network.naijapay
}

output "private_subnet" {
  value = google_compute_subnetwork.private
}

output "public_subnet" {
  value = google_compute_subnetwork.public
}

output "nat_ip_address" {
  value = google_compute_address.nat-ip.address
}
