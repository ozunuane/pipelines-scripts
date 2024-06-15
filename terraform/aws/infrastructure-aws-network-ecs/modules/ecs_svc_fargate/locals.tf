
# locals {
#   container_info = flatten([
#     for service_name, container_details in var.container_definitions : [
#       {
#         container_def = <<TASK_DEFINITION


#   {
#     "logConfiguration": {
#       "logDriver": "awslogs",
#       "options": {
#         "awslogs-group": "/ecs/${service_name}",
#         "awslogs-region": "${data.aws_region.current.name}",
#         "awslogs-create-group": "true",
#         "awslogs-stream-prefix": "ecs"
#       }
#     },

#     "portMappings": [

#         %{if container_details["port"] != 0~}
#         {"hostPort": ${container_details["port"]},
#         "containerPort": ${container_details["port"]},
#         "protocol":"tcp"}
#         %{~endif}

#     ],
#     "command": [ ${join(", ", [for command in container_details["command"] : format("%q", command)])} ],
#     "environment": ${jsonencode(container_details["environment"])},
#     "secrets": ${jsonencode(container_details["secret"])},
#     "mountPoints": [
#               %{if var.add_container_volume}
#               {
#           "containerPath": ${jsonencode(container_details["mount_path"])},
#           "sourceVolume": ${jsonencode(container_details["volumename"])}
#         }
#         %{~endif}
#         %{if var.add_container_volume2}
#         ,{
#           "containerPath": ${jsonencode(container_details["mount_path2"])},
#           "sourceVolume": ${jsonencode(container_details["volumename2"])}
#         }
#         %{~endif}
#         %{if var.add_container_volume3}
#         ,{
#           "containerPath": ${jsonencode(container_details["mount_path3"])},
#           "sourceVolume": ${jsonencode(container_details["volumename3"])}
#         }
#         %{~endif}
#     ],
#     "essential": true,
#     "cpu": 0,
#     "volumesFrom": [],
#     "image": "${container_details["image"]}",
#     "name": "${service_name}"
#   }
# TASK_DEFINITION
#       }
#     ]
#   ])

#   containers = "[${join(",", [for k, v in local.container_info : "${v.container_def}"])}]"
#   depends_on = [
#     #data.aws_ecs_container_definition.ecs,
#     aws_ecs_task_definition.task_definition
#   ]
# }
