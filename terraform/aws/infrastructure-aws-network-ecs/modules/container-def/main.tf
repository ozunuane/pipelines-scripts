

# module "container_1" {
#   source = "./container-def"

#   family    = var.service_name_1
#   image     = "${var.container_details}[image]"
#   memory    = 0
#   cpu       = 0
#   essential = true

#   logConfiguration = {
#     logDriver = "awslogs"
#     options = {
#       awslogs-group         = "/ecs/${service_name_1}",
#       awslogs-region        = "${data.aws_region.current_region.name}",
#       awslogs-create-group  = true,
#       awslogs-stream-prefix = "ecs"
#     }
#   }

#   portMappings = [
#     {
#       containerPort = var.container_port
#       protocol      = var.container_port_protocol
#     },
#   ]

#   register_task_definition = false
# }



# module "container_2" {
#   source = "./container-def"

#   family    = var.service_name_1
#   image     = var.image
#   memory    = 0
#   cpu       = 0
#   essential = true

#   logConfiguration = {
#     logDriver = "awslogs"
#     options = {
#       awslogs-group         = "/ecs/${service_name_2}",
#       awslogs-region        = "${data.aws_region.current_region.name}",
#       awslogs-create-group  = true,
#       awslogs-stream-prefix = "ecs"
#     }
#   }


#   portMappings = [
#     {
#       containerPort = var.container_port
#       protocol      = var.container_port_protocol
#     },
#   ]

#   register_task_definition = false
# }


# module "merged" {
#   source = "../../modules/definition"
#   container_definitions = [
#     module.container_1.container_definitions,
#     module.container_2.container_definitions,
#   ]
# }

# resource "aws_ecs_task_definition" "ecs_task_definition" {
#   container_definitions = module.merged.container_definitions
#   family                = "app"
# }





