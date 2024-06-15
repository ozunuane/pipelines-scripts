output "storage" {
  value = {
    project_id              = var.gcp_project_id
    private_key             = google_service_account_key.naijapay.private_key
    private_container       = google_storage_bucket.app.name
    public_container        = google_storage_bucket.cdn.name
    naijapay_microservice_user = random_string.naijapay_microservice_user.result
    naijapay_microservice_pass = random_string.naijapay_microservice_pass.result
    region                  = var.region
  }
  sensitive = true
}
