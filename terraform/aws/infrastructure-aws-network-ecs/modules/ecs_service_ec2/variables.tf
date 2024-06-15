variable "name" {
  description = "The name of the ECS service."
  type        = string
}

variable "container_name" {
  description = "The name of the container."
  type        = string
}

variable "cluster_arn" {
  description = "The ARN of the ECS cluster."
  type        = string
}

variable "capacity_provider" {
  description = "The capacity provider to use."
  type        = string
}



variable "container_port" {
  description = "The port on which the container will listen."
  type        = number
}

variable "protocol" {
  description = "The protocol used by the container."
  type        = string
  default     = "tcp"
}

# variable "sourceVolume" {
#   description = "The source volume to mount."
#   type        = string
# }

# variable "containerPath" {
#   description = "The path in the container where the source volume will be mounted."
#   type        = string
# }

# variable "cloudwatch_log_group_name" {
# }

# variable "target_group_arn" {
#   description = "The ARN of the target group to associate with the service."
#   type        = string
# }

variable "private_subnets" {
  description = "List of private subnet IDs."
  type        = list(string)
}

# variable "ecs_service_rules" {
#   description = "List of security group rules for the ECS service."
#   type = list(object({
#     description      = string
#     from_port        = number
#     to_port          = number
#     protocol         = string
#     cidr_blocks      = list(string)
#     security_groups  = list(string)
#     prefix_list_ids  = list(string)
#     ipv6_cidr_blocks = list(string)
#     self             = bool
#   }))
# }

variable "subnet_ids" {

}

variable "expose_service" {
  default = true
}

variable "lb_type" {
  default = "application"
}


variable "fqdn" {

}

variable "load_balancer_arn" {

}

variable "load_balancer_name" {

}

variable "env" {

}


# variable "elb_name" {

# }

variable "lb_dns_name" {

}

variable "lb_zone_id" {

}
#target group and lb configurations
variable "health_check_path" {
  default = "/"
}

variable "tg_protocol" {
  default = "HTTP"
}
variable "tg_target_type" {
  default = "ip"
}

variable "vpc_id" {

}

variable "tg_name" {

}

variable "service_name" {

}

variable "region" {

}
variable "tg_port" {
  default = 80
}

# variable "container_port_protocol" {
#   default = "tcp"
# }


variable "tg_unhealthy_threshold" {
  default = 5
}

variable "tg_healthy_threshold" {
  default = 5
}

variable "tg_timeout" {
  default = 10
}
variable "tg_interval" {
  default = 30
}

variable "route53_zone_id" {

}
variable "tg_protocol_version" {
  default = "HTTP1"
}

variable "health_check_success_codes" {
  default = null #comma separated
}
variable "listener_arn" {
  description = "load balancer listener arn"
  default     = null
}


variable "route53_evaluate_target_health" {
  default = false

}
variable "use_latest_image" {
  default = true
}

# variable "compute_info" {
#   description = "The cpu and memory requirement for the service"
#   default     = ["cpu", "memory"]
# }


# variable "nlb_port" {

# }
variable "desired_count" {

}

variable "namespace_id" {

}


variable "aws_security_group" {

}


variable "alb_arn_suffix" {
  description = "load balancer arn suffix"
}

variable "security_groups" {
  description = "A list of security group ids to associate the ecs service with"
}


variable "container_definitions" {
  description = "Map of container definitions"
  type = map(object({
    image                                  = string
    container_port                         = number
    protocol                               = string
    sourceVolume                           = optional(string)
    containerPath                          = optional(string)
    entry_point                            = optional(list(string), [])
    command                                = optional(list(string), [])
    essential                              = optional(bool, true)
    readonly_root_filesystem               = optional(bool, false)
    enable_cloudwatch_logging              = optional(bool, true)
    awslogs_stream_prefix                  = optional(string, "ecs")
    create_cloudwatch_log_group            = optional(bool, true)
    cloudwatch_log_group_retention_in_days = optional(number, 7)
    environment = optional(list(object({
      name  = string
      value = string
    })), [])
    secrets = optional(list(object({
      name      = string
      valueFrom = string
    })), [])
    volumes_from = optional(list(object({
      sourceContainer = string
      readOnly        = bool
    })), [])
    mount_points = optional(list(object({
      sourceVolume  = string
      containerPath = string
    })), [])
    volumes = optional(list(object({
      name = string
      host = optional(object({
        sourcePath = string
      }), null)
    })), [])
  }))
}


variable "cpu" {

}

variable "memory" {

}