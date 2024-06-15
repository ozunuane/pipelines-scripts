###############################################################################
### ECS Cluster AND Capacity Provider
###############################################################################
############### ECS SERVICE SECURITY GROUP RULES #####


module "ecs_service_sg_group" {
  source = "./modules/security_group"
  name   = "${var.name}-ecs-asg"
  env    = var.env
  vpc_id = local.vpc_id
  rules  = var.ecs_service_rules
}

# module "ecs_cluster_1" {
#   source = "./modules/ecs-cluster"

#   cluster_name = "${var.name}-${var.env}-cluster"

#   # Capacity provider - autoscaling groups
#   default_capacity_provider_use_fargate = false
#   autoscaling_capacity_providers = {
#     # On-demand instances
#     ec2_instance_on_demand = {
#       auto_scaling_group_arn         = module.autoscaling["ec2_instance_on_demand"].autoscaling_group_arn
#       managed_termination_protection = "ENABLED"

#       managed_scaling = {
#         maximum_scaling_step_size = 1
#         minimum_scaling_step_size = 1
#         status                    = "ENABLED"
#         target_capacity           = 50
#       }

#       default_capacity_provider_strategy = {
#         weight = 1
#         base   = 0
#       }
#     }
#   }
#   tags       = local.snapshot_tag
#   depends_on = [module.autoscaling]
# }






# #######  AUTO SCALING GROUP ######
# module "autoscaling" {
#   source = "terraform-aws-modules/autoscaling/aws"
#   for_each = {
#     ec2_instance_on_demand = {
#       instance_type              = var.ecs_instance_type
#       use_mixed_instances_policy = false
#       mixed_instances_policy     = {}
#       volume_size                = var.ecs_volume_size
#       volume_type                = var.ecs_volume_type
#       user_data                  = <<-EOT
#         #!/bin/bash
#         cat <<'EOF' >> /etc/ecs/ecs.config
#         ECS_CLUSTER=${local.cluster_name}
#         ECS_LOGLEVEL=debug
#         ECS_CONTAINER_INSTANCE_TAGS=${jsonencode(local.tags)}
#         ECS_ENABLE_TASK_IAM_ROLE=true
#         EOF
#       EOT
#     }

#   }

#   name                            = "${local.name}-${var.env}-${each.key}"
#   image_id                        = module.ecs_instance.ecs_instance_tmp_ami
#   instance_type                   = each.value.instance_type
#   key_name                        = module.ecs_instance.ecs_instance_tmp_arn_key
#   security_groups                 = [module.ecs_service_sg_group.id]
#   user_data                       = base64encode(each.value.user_data)
#   ignore_desired_capacity_changes = true

#   create_iam_instance_profile = true
#   iam_role_name               = local.name
#   iam_role_description        = "ECS role for ${local.name}-${var.env}"
#   iam_role_policies = {
#     AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
#     AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   }

#   vpc_zone_identifier = module.network.private_subnets
#   health_check_type   = "EC2"
#   min_size            = 1
#   max_size            = 2
#   desired_capacity    = 1
#   autoscaling_group_tags = {
#     AmazonECSManaged = true
#   }
#   protect_from_scale_in      = true
#   use_mixed_instances_policy = each.value.use_mixed_instances_policy
#   mixed_instances_policy     = each.value.mixed_instances_policy
#   tags                       = local.snapshot_tag
#   depends_on                 = [module.ecs_instance]
# }




# ########### ECS INSTANCE TEMPLATE (ECS-EC2) #################
# module "ecs_instance" {
#   source                = "./modules/ecs-instance"
#   ecs_security_group_id = module.ecs_service_sg_group.id
#   subnet_ids            = [module.network.private_subnets[0], module.network.private_subnets[1]]
#   env                   = var.env
#   name                  = var.name
#   ecs_instance_type     = var.ecs_instance_type
#   ecs_volume_size       = var.ecs_volume_size
#   ecs_volume_type       = var.ecs_volume_type
#   cluster_name          = local.cluster_name
#   ec2_template_key_name = var.ec2_template_key_name
# }
