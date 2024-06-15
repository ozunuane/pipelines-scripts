

  provider  "kubernetes" {
  host                   = "https://${module.gke-noncba.endpoint}"
  token                  = data.google_client_config.paragon.access_token
  cluster_ca_certificate = base64decode(module.gke-noncba.ca_certificate)
  alias                  = "noncba-cluster"
}

provider "kubernetes" {
  host                   = "https://${module.gke-cba.endpoint}"
  token                  = data.google_client_config.paragon.access_token
  cluster_ca_certificate = base64decode(module.gke-cba.ca_certificate)
  alias                  = "cba-cluster"
}