provider "google" {
  region  = var.region
  zone    = var.region_zone
  project = var.gcp_project_id
  credentials = jsonencode({
    type                        = "service_account",
    gcp_project_id              = var.gcp_project_id,
    private_key_id              = var.gcp_private_key_id,
    private_key                 = var.gcp_private_key,
    client_email                = var.gcp_client_email,
    client_id                   = var.gcp_client_id,
    auth_uri                    = "https://accounts.google.com/o/oauth2/auth",
    token_uri                   = "https://oauth2.googleapis.com/token",
    auth_provider_x509_cert_url = "https://www.googleapis.com/oauth2/v1/certs",
    client_x509_cert_url        = var.gcp_client_x509_cert_url,
  })
}

provider "google-beta" {
  region  = var.region
  zone    = var.region_zone
  project = var.gcp_project_id
  credentials = jsonencode({
    type                        = "service_account",
    gcp_project_id              = var.gcp_project_id,
    private_key_id              = var.gcp_private_key_id,
    private_key                 = var.gcp_private_key,
    client_email                = var.gcp_client_email,
    client_id                   = var.gcp_client_id,
    auth_uri                    = "https://accounts.google.com/o/oauth2/auth",
    token_uri                   = "https://oauth2.googleapis.com/token",
    auth_provider_x509_cert_url = "https://www.googleapis.com/oauth2/v1/certs",
    client_x509_cert_url        = var.gcp_client_x509_cert_url,
  })
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "cloudflare" {
  api_token = var.cloudflare_dns_api_token
}
