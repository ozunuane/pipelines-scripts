variable "gcp_project_id" {
  description = "The GCP region to deploy resources"
}

locals {
  services = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "redis.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "dns.googleapis.com",
    "container.googleapis.com"

  ]
}
