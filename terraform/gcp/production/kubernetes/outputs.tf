output "cba-kubernetes" {
  value = {
    name                   = module.gke-cba.name
    host                   = "https://${module.gke-cba.endpoint}"
    token                  = data.google_client_config.naijapay.access_token
    cluster_ca_certificate = base64decode(module.gke-cba.ca_certificate)
  }
  sensitive = true
}

output "noncba-kubernetes" {
  value = {
    name                   = module.gke-noncba.name
    host                   = "https://${module.gke-noncba.endpoint}"
    token                  = data.google_client_config.naijapay.access_token
    cluster_ca_certificate = base64decode(module.gke-noncba.ca_certificate)
  }
  sensitive = true
}