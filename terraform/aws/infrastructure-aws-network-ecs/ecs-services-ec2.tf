################################################################################
# Service
# ################################################################################

# ##### ECS service module call ####
# module "nginx_ecs_service_ec2" {
#   source                     = "./modules/ecs_service_ec2"
#   region                     = var.region
#   name                       = "nginx-backend-ec2"
#   cluster_arn                = module.ecs_cluster_1.arn
#   capacity_provider          = module.ecs_cluster_1.autoscaling_capacity_providers["ec2_instance_on_demand"].name
#   tg_protocol_version        = "HTTP1"
#   protocol                   = "http"
#   tg_target_type             = "ip"
#   service_name               = "nginx-backend-ec2"
#   tg_name                    = "nginx-backend-ec2"
#   fqdn                       = "svc-internal.${var.env}.${local.hosted_zone_test}"
#   container_name             = "nginx-backend-ec2"
#   container_port             = 80
#   health_check_success_codes = "200"
#   health_check_path          = "/"
#   private_subnets            = module.network.private_subnets
#   vpc_id                     = local.vpc_id
#   subnet_ids                 = local.private_subnet_ids
#   tg_unhealthy_threshold     = 5
#   desired_count              = 1
#   aws_security_group         = [module.ecs_service_sg_group.id]
#   listener_arn               = local.internal_alb_listener_arn
#   lb_dns_name                = local.internal_alb_lb_dns_name
#   route53_zone_id            = local.test_dns_zone_id
#   lb_zone_id                 = local.internal_alb_lb_zone_id
#   namespace_id               = aws_service_discovery_public_dns_namespace.namespace.id
#   security_groups            = [local.ecs_service_sg_group]
#   alb_arn_suffix             = local.internal_alb_alb_arn_suffix
#   env                        = var.env
#   load_balancer_name         = local.internal_alb_name
#   load_balancer_arn          = local.internal_alb_alb_arn
#   cpu    = 128
#   memory = 256


#   container_definitions = {
#     "nginx-backend-ec2" = {
#       image          = "ksdn117/test-page:latest"
#       port           = 80
#       container_port = 80
#       protocol       = "tcp"
#       environment    = local.nginx_service_env
#       secret         = local.nginx_service_secrets
#       command        = []
#       mount_path     = "/tmp"      # Provide a default value for mount_path
#       volumename     = "temporary" # Provide a default value for volumename
#       essential      = true
#     }
#   }

# }