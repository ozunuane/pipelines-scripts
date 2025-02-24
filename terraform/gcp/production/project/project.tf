# resource "google_project_service" "naijapay" {
#   for_each                   = toset(local.services)
#   project                    = var.gcp_project_id
#   service                    = each.value
#   disable_dependent_services = true
# }

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"

  project_id  = var.gcp_project_id
  disable_services_on_destroy = false
  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "anthos.googleapis.com",
    "cloudtrace.googleapis.com",
    "meshca.googleapis.com",
    "meshtelemetry.googleapis.com",
    "meshconfig.googleapis.com",
    "iamcredentials.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"

  ]
}