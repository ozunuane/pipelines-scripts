module "project" {
  source = "./project"

  gcp_project_id = var.gcp_project_id
}

module "network" {
  source = "./network"

  app_name       = var.app_name
  region         = var.region
  gcp_project_id = var.gcp_project_id

  depends_on = [module.project]
}


module "bastion" {
  source = "./bastion"

  app_name      = var.app_name
  region        = var.region
  ssh_whitelist = local.ssh_whitelist
  # config_hash             = var.config_hash
  # deployment_cache_buster = var.deployment_cache_buster


  project        = module.network.project
  network        = module.network.network
  private_subnet = module.network.private_subnet
  cba_cluster    = module.kubernetes.cba-kubernetes
  noncba_cluster = module.kubernetes.noncba-kubernetes

  depends_on = [module.project, module.network]
}

module "kubernetes" {
  source = "./kubernetes"

  app_name = var.app_name
  region   = var.region

  project             = module.network.project
  network             = module.network.network
  private_subnet      = module.network.private_subnet
  public_subnet       = module.network.public_subnet
  region_zone         = var.region_zone
  region_zone_backup  = var.region_zone_backup
  authorized_networks = var.authorized_networks

  k8_node_instance_type    = var.k8_node_instance_type
  k8_min_node_count        = var.k8_min_node_count
  k8_max_node_count        = var.k8_max_node_count
  k8_spot_instance_percent = var.k8_spot_instance_percent
}

module "postgres" {
  source = "./postgres"

  app_name = var.app_name
  region   = var.region

  project_service     = module.project.project_service
  project             = module.network.project
  network             = module.network.network
  private_subnet      = module.network.private_subnet
  public_subnet       = module.network.public_subnet
  authorized_networks = var.authorized_networks
  postgres_tier       = var.postgres_tier

  depends_on = [module.project]
}

# module "redis" {
#   source = "./redis"

#   app_name           = var.app_name
#   region             = var.region
#   region_zone        = var.region_zone
#   region_zone_backup = var.region_zone_backup

#   project_service = module.project.project_service
#   project         = module.network.project
#   network         = module.network.network
#   private_subnet  = module.network.private_subnet
#   public_subnet   = module.network.public_subnet

#   depends_on = [module.project]
# }

module "storage" {
  source = "./storage"

  app_name       = var.app_name
  region         = var.region
  domain         = var.domain
  gcp_project_id = var.gcp_project_id

  project_service = module.project.project_service
  project         = module.network.project
  network         = module.network.network
  private_subnet  = module.network.private_subnet
  public_subnet   = module.network.public_subnet

  depends_on = [module.project]
}
