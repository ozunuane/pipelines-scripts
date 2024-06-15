module "asm-cba" {
  source                = "terraform-google-modules/kubernetes-engine/google//modules/asm"
#   version               = "18.0.0"
  project_id            = var.project
  cluster_name          = module.gke-cba.name
  cluster_location      = module.gke-cba.location
#   cluster_endpoint      = module.gke-cba.endpoint
#   enable_all            = true
#   outdir                = "./asm-dir-${module.gke-cba.name}"
  # provider             = kubernetes.cba-cluster
}

module "asm-noncba" {
  source                = "terraform-google-modules/kubernetes-engine/google//modules/asm"
#   version               = "18.0.0"
  project_id            = var.project
  cluster_name          = module.gke-noncba.name
  cluster_location      = module.gke-noncba.location
#   cluster_endpoint      = module.gke-noncba.endpoint
#   enable_all            = true
#   outdir                = "./asm-dir-${module.gke-noncba.name}"
  # provider             = kubernetes.noncba-cluster
  
}