# locals {
#   create_monitoring_alarms = terraform.workspace == "prod" || terraform.workspace == "dev"
#   services_to_monitor = [
#     "${module.nginx_ecs_service_ec2.service_name}",
#     # "another_service",  # Add more services as needed
#   ]
# }


# # Module for ECS events monitoring for dev environment
# module "ecs_events" {
#   for_each = local.create_monitoring_alarms ? { for service in local.services_to_monitor : service => service } : {}

#   source                      = "./modules/monitoring"
#   log_group_name              = "/ecs/${each.key}/${var.env}"
#   log_group_retention_in_days = 7
#   event_rule_name             = "ecs-${each.key}-events-${var.env}"
#   event_rule_description      = "Capture all ECS ${each.key} events"
#   cluster_arn                 = module.ecs_cluster_1.arn
#   alarm_name                  = "ECS service is stopped with error"
#   alarm_description           = "crashes occurred"
#   service_name                = each.key
#   env                         = var.env
#   aws_region                  = var.region
# }
