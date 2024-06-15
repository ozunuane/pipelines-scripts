data "aws_availability_zones" "available" {}


###### EC2 BASTION / CLOUDFLARE #####
module "ec2_bastion_sg_group" {
  source = "./modules/security_group"
  name   = "${var.name}-${var.env}-bastion"
  env    = var.env
  vpc_id = local.vpc_id
  rules  = var.ec2_bastion_rules
}

locals {
  create_bastion = terraform.workspace == "dev"
}

##### BASTION AND CLOUDFLARE ####
module "bastion" {
  count                       = local.create_bastion ? 1 : 0
  source                      = "./modules/ec2"
  vpc_security_group_ids      = [module.ec2_bastion_sg_group.id]
  ec2_volume_type             = var.bastion_volume_type
  ec2_volume_size             = var.bastion_volume_size
  key_name                    = var.bastion_key_name
  subnet_id                   = module.network.public_subnets[0]
  env                         = var.env
  instance_type_value         = var.bastion_instance_type
  associate_public_ip_address = true
  name                        = var.name
  depends_on                  = [module.network]
}

###### NETWORK ( VPC, NACL, SUBNETS, IGW, NAT ) ##########
module "network" {
  source             = "./modules/vpc"
  cidr_block         = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  env                = var.env
  private_routes     = var.private_routes
  public_routes      = var.public_routes
  name               = var.name
  private_nacl_rules = var.private_nacl_rules
  public_nacl_rules  = var.public_nacl_rules
}



######## CERTIFICATES ###########
module "cert" {
  source       = "./modules/acm"
  hosted_zone1 = local.hosted_zone_test
  env          = var.env

}

####### ecs_repo ####
module "ecr_repo" {
  source   = "./modules/ecr_module"
  ecr_repo = var.ecr_repo
}



#########################################################
#################### REDIS ##############################

locals {
  create_redis = terraform.workspace == "prod" || terraform.workspace == "staging"
}

module "redis_sg_group" {
  source = "./modules/security_group"
  name   = "${var.name}-${var.env}-redis"
  env    = var.env
  vpc_id = local.vpc_id
  rules  = var.redis_cluster_rules
}


# module "redis" {
#   count                    = local.create_redis ? 1 : 0
#   source                   = "./modules/redis"
#   num_node_groups          = var.redis_num_node_groups
#   redis_node_size          = var.redis_node_size
#   redis_pg_family          = var.redis_pg_family
#   cache_engine_verision    = var.cache_engine_verision
#   private_subnets          = module.network.private_subnets[2]
#   redis_security_group_ids = module.redis_sg_group.id
#   env                      = var.env
#   vpc_id                   = module.network.id
#   name                     = var.name
# }





#############  SUPPORTING RESOURCES ################
####################################################
##### INTERNAL APPLICATION LOAD BALANCER ###
module "internal_alb" {
  source                 = "./modules/lb_load_balancer"
  subnet_ids             = module.network.private_subnets
  vpc_id                 = module.network.id
  name                   = var.name
  env                    = var.env
  load_balancer_type     = "application"
  internal               = true
  https_default_cert_arn = module.cert.hosted_zone1_cert
  expose_type            = "internal"
  rules                  = var.internal_netwok_only_rules
  depends_on             = [module.cert]
}

###### EXTERNAL APPLICATION LOAD BALANCER ###
module "external_alb" {
  source                 = "./modules/lb_load_balancer"
  subnet_ids             = module.network.public_subnets
  vpc_id                 = module.network.id
  name                   = var.name
  env                    = var.env
  load_balancer_type     = "application"
  internal               = false
  expose_type            = "external"
  https_default_cert_arn = module.cert.hosted_zone1_cert
  rules                  = var.web_alb_expose_external_rules
  depends_on             = [module.cert]
}


# ##### INTERNAL NETWORK LOAD BALANCER ############
# module "internal_nlb" {
#   source             = "./modules/lb_load_balancer"
#   subnet_ids         = module.network.private_subnets
#   vpc_id             = module.network.id
#   name               = var.name
#   env                = var.env
#   load_balancer_type = "network"
#   internal           = true
#   expose_type = "internal"
#   https_default_cert_arn =  module.cert.hosted_zone1_cert
#   depends_on = [ module.cert ]
#   rules = var.internal_netwok_only_rules
# }





