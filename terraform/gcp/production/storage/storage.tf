########################################
########################################
# private bucket

resource "google_storage_bucket" "app" {
  name          = "${var.app_name}-app"
  location      = var.region
  project       = var.project
  storage_class = "STANDARD"
  force_destroy = "false"
}

resource "google_storage_bucket_iam_member" "app" {
  bucket = google_storage_bucket.app.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.naijapay.email}"
}

########################################
########################################
# public bucket
resource "google_storage_bucket" "cdn" {
  name          = "${var.app_name}-cdn"
  location      = var.region
  project       = var.project
  storage_class = "STANDARD"
  force_destroy = "false"
}

resource "google_storage_bucket_iam_member" "cdn" {
  bucket = google_storage_bucket.cdn.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.naijapay.email}"
}

resource "google_storage_bucket_acl" "cdn_public_read_access" {
  bucket = google_storage_bucket.cdn.name
  role_entity = [
    "READER:allUsers"
  ]
}

# configure all objects added to the public bucket to have public read access
resource "google_storage_default_object_acl" "cdn_public_read_access" {
  bucket = google_storage_bucket.cdn.name
  role_entity = [
    "READER:allUsers"
  ]
}

########################################
########################################
# naijapay microservice access

resource "random_string" "naijapay_microservice_user" {
  length  = 10
  special = false
  number  = true
  lower   = true
  upper   = false
}

resource "random_string" "naijapay_microservice_pass" {
  length  = 10
  special = false
  number  = true
  lower   = true
  upper   = false
}
