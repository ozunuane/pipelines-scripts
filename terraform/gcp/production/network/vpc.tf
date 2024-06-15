resource "google_compute_network" "naijapay" {
  name                    = "${var.app_name}-network"
  auto_create_subnetworks = "false"
  project                 = var.gcp_project_id
}

resource "google_compute_subnetwork" "private" {
  name          = "${var.app_name}-private-subnet"
  ip_cidr_range = cidrsubnet(var.vpc_cidr, 8, 1)
  region        = var.region
  network       = google_compute_network.naijapay.id
  project       = var.gcp_project_id
  secondary_ip_range {
    range_name    = "ip-pods-secondary-range"
    ip_cidr_range = "192.168.0.0/16"
  }
  secondary_ip_range {
    range_name    = "ip-services-secondary-range"
    ip_cidr_range = "152.100.0.0/16"
  }
}

resource "google_compute_subnetwork" "public" {
  name          = "${var.app_name}-public-subnet"
  ip_cidr_range = cidrsubnet(var.vpc_cidr, 8, 2)
  region        = var.region
  network       = google_compute_network.naijapay.id
  project       = var.gcp_project_id
}


resource "google_compute_address" "nat-ip" {
  name    = "${var.app_name}-nap-ip"
  project = var.gcp_project_id
  region  = var.region
}

resource "google_compute_router" "nat-router" {
  name    = "${var.app_name}-nat-router"
  network = google_compute_network.naijapay.name
}

resource "google_compute_router_nat" "nat-gateway" {
  name                               = "${var.app_name}-nat-gateway"
  router                             = google_compute_router.nat-router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat-ip.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_address.nat-ip]
  project                            = var.gcp_project_id
}
