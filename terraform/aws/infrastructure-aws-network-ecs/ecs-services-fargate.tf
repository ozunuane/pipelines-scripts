data "aws_region" "current" {}


resource "aws_service_discovery_public_dns_namespace" "namespace" {
  name = "servicemap.${local.hosted_zone_test}"
}

resource "aws_ecs_cluster" "cluster_fargate" {
  name = "${var.env}-fargate-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  tags = {
    "Environment" = "${var.env}"
  }
}


############################ Fargate Services  #########################################
module "nginx" {
  region                     = var.region
  source                     = "./modules/ecs_svc_fargate"
  service_name               = "nginx-backend-${var.env}"
  tg_name                    = "nginx-backend-${var.env}"
  fqdn                       = "svc.${var.env}.${local.hosted_zone_test}"
  container_name             = "nginx-backend-${var.env}"
  health_check_success_codes = "200"
  health_check_path          = "/"
  vpc_id                     = local.vpc_id
  subnet_ids                 = local.private_subnet_ids
  container_port             = 80
  tg_unhealthy_threshold     = 5
  desired_count              = 0
  tg_protocol                = "HTTP"
  tg_protocol_version        = "HTTP1"
  load_balancer_arn          = local.external_alb_alb_arn
  listener_arn               = local.external_alb_listener_arn
  lb_dns_name                = local.external_alb_lb_dns_name
  route53_zone_id            = local.test_dns_zone_id
  lb_zone_id                 = local.external_alb_lb_zone_id
  enable_service_discovery   = true
  namespace_id               = aws_service_discovery_public_dns_namespace.namespace.id
  ecs_cluster                = aws_ecs_cluster.cluster_fargate.id
  compute_info               = [256, 512]
  security_groups            = [local.ecs_service_sg_group]
  alb_arn_suffix             = local.external_alb_alb_arn_suffix
  nlb_port                   = null
  env                        = var.env

  container_definitions = {
    "nginx-backend-${var.env}" = {
      image          = "ksdn117/test-page:latest"
      port           = 80
      container_port = 8080
      proctocol      = "tcp"
      environment    = local.nginx_service_env
      secret         = local.nginx_service_secrets
      command        = []
      mount_path     = "/tmp/" # Provide a default value for mount_path
      volumename     = "tmp"   # Provide a default value for volumename
      essential      = true
    }
  }


}