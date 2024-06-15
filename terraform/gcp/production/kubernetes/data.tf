data "google_client_config" "naijapay" {}

data "google_project" "project" {
    project_id = var.project
}