################################################################################
# Service Module
################################################################################
locals {
  container_name = var.container_name
  name           = var.name
  container_port = var.container_port
}


module "ecs_service" {
  source             = "./ecs_service_ec2"
  cpu                = var.cpu
  memory             = var.memory
  namespace_id       = var.namespace_id
  service_name       = var.service_name
  name               = local.name
  cluster_arn        = var.cluster_arn
  aws_security_group = var.aws_security_group
  env                = var.env
  load_balancer_name = var.load_balancer_name
  load_balancer_arn  = var.load_balancer_arn
  # Task Definition
  requires_compatibilities = ["EC2"]
  capacity_provider_strategy = {
    # On-demand instances
    ec2_instance_on_demand = {
      capacity_provider = var.capacity_provider
      weight            = 1
      base              = 1
    }
  }

  volume = {
    my-vol = {}
  }

  # Container definition(s)
  container_definitions = local.container_definitions

  load_balancer = {
    service = {
      target_group_arn = var.lb_type == "application" ? aws_lb_target_group.target_group[0].arn : aws_lb_target_group.nlb_target_group[0].arn
      container_name   = local.container_name
      container_port   = local.container_port
    }
  }

  subnet_ids = var.subnet_ids
  # security_group_rules = var.ecs_service_rules
}


locals {
  cluster_aws_ecs_service = module.ecs_service.cluster_arn
  ecs_service_name        = module.ecs_service.name
}




# Provisioner to force a new deployment by updating the desired count
resource "null_resource" "force_redeploy" {
  triggers = {
    task_definition = module.ecs_service.task_definition_revision
  }

  provisioner "local-exec" {
    command = <<EOT
      aws ecs update-service --cluster ${local.cluster_aws_ecs_service} --service ${local.ecs_service_name} --force-new-deployment
    EOT
  }
}