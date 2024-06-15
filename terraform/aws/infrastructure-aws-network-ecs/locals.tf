locals {
  vpc_id             = module.network.id
  region             = var.region
  name               = var.name
  azs                = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnet_ids = module.network.private_subnets
  cluster_name       = "${var.name}-${var.env}-cluster"
  tags = {
    name = var.name
    env  = var.environment
    # Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecs"
  }

  snapshot_tag = {
    name = "${var.env}-lifecycle"
  }
  ecs_service_sg_group = module.ecs_service_sg_group.id

  ####### INTERNAL APPL LOAD BALANCER #####
  internal_alb_listener_arn   = module.internal_alb.lb_details["listener_arn"][0]
  internal_alb_lb_dns_name    = module.internal_alb.lb_details["lb_dns_name"]
  internal_alb_lb_zone_id     = module.internal_alb.lb_details["lb_zone_id"]
  internal_alb_alb_arn_suffix = module.internal_alb.lb_details["lb_arn_suffix"]
  internal_alb_alb_arn        = module.internal_alb.lb_details["lb_arn"]
  internal_alb_name           = module.internal_alb.lb_details["lb_name"]

  ####### EXTERNAL APP LOAD BALANCER #####
  external_alb_listener_arn   = module.external_alb.lb_details["listener_arn"][0]
  external_alb_lb_dns_name    = module.external_alb.lb_details["lb_dns_name"]
  external_alb_lb_zone_id     = module.external_alb.lb_details["lb_zone_id"]
  external_alb_alb_arn_suffix = module.external_alb.lb_details["lb_arn_suffix"]
  external_alb_alb_arn        = module.external_alb.lb_details["lb_arn"]

  ## HOSTED ZONES
  hosted_zone_test = data.terraform_remote_state.test_dns.outputs.hosted_zone_test
  ##ZONE_ID'S
  test_dns_zone_id = data.terraform_remote_state.test_dns.outputs.test_dns_zone_id
}


locals {
  nginx_service_env = terraform.workspace == "prod" ? var.test_service_prod_env : (terraform.workspace == "comtrol" ? var.test_service_control_env : var.test_service_dev_env)

  nginx_service_secrets = terraform.workspace == "prod" ? var.test_service_prod_secrets : (terraform.workspace == "control" ? var.test_service_control_secrets : var.test_service_dev_secrets)
}
