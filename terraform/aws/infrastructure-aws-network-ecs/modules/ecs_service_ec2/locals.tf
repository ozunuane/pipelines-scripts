locals {
  container_definitions = {
    for container_name, container in var.container_definitions : container_name => {
      image = container.image
      port_mappings = [
        {
          name          = container_name
          containerPort = container.container_port
          protocol      = container.protocol
        }
      ]

      mount_points = lookup(container, "mount_points", [])
      volumes      = lookup(container, "volumes", [])
      network_mode = "bridge"

      entry_point                            = lookup(container, "entry_point", [])
      command                                = lookup(container, "command", [])
      essential                              = lookup(container, "essential", true)
      readonly_root_filesystem               = lookup(container, "readonly_root_filesystem", false)
      enable_cloudwatch_logging              = lookup(container, "enable_cloudwatch_logging", true)
      awslogs_stream_prefix                  = lookup(container, "awslogs_stream_prefix", "ecs")
      create_cloudwatch_log_group            = lookup(container, "create_cloudwatch_log_group", true)
      cloudwatch_log_group_retention_in_days = lookup(container, "cloudwatch_log_group_retention_in_days", 7)
      # cloudwatch_log_group_name = "/ecs/${var.service_name}/${var.env}"

      log_configuration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${local.log_group_name}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = lookup(container, "awslogs_stream_prefix", "ecs")
          "awslogs-create-group"  = lookup(container, "awslogs_create_group", "true")
        }


      }

      # Add other container attributes here
      environment  = lookup(container, "environment", [])
      secrets      = lookup(container, "secrets", [])
      volumes_from = lookup(container, "volumes_from", [])
    }
  }
}


resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.service_name}/${var.env}"
  retention_in_days = 7
}

locals {

  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}

