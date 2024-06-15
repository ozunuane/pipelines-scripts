module "dns" {
  source       = "./route53"
  hosted_zones = var.hosted_zone1
  env          = var.env
}


