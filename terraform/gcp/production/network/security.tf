# # allow http, https and ssh traffic

# resource "google_compute_firewall" "standalone_network" {
#   depends_on    = [google_compute_network.naijapay]
#   name    = "${var.app_name}-firewall"
#   network = google_compute_network.naijapay.self_link

#   allow {
#     protocol = "tcp"
#     ports    = ["22", "80", "443"]
#   }

#   source_tags = ["mynetwork"]

#   project       = google_project.naijapay.gcp_project_id

# }
