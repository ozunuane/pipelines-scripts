resource "google_service_account" "naijapay" {
  account_id   = "naijapay-root-user"
  display_name = "naijapay"
  description  = "Allows naijapay to read and write to Google Cloud Storage."
  project      = var.project
}

resource "google_service_account_key" "naijapay" {
  service_account_id = google_service_account.naijapay.name
}
