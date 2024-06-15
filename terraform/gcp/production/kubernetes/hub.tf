module "hub-cba" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"

  project_id       = var.project
  cluster_name     = module.gke-cba.name
  location         = module.gke-cba.location
#   cluster_endpoint = module.gke-cba.endpoint
#   gke_hub_membership_name = "cba"
#   gke_hub_sa_name = "cba"
}

module "hub-noncba" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"

  project_id       = var.project
  cluster_name     = module.gke-noncba.name
  location         = module.gke-noncba.location
#   cluster_endpoint = module.nongke-cba.endpoint
#   gke_hub_membership_name = "noncba"
#   gke_hub_sa_name = "noncba"
}