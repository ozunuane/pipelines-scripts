#network configurations

variable "vpc_id" {

}
variable "region" {

}
variable "tg_port" {
  default = 80
}

variable "container_port_protocol" {
  default = "tcp"
}

variable "container_port" {
  description = "The container port to expose"

}

variable "subnet_ids" {
  description = "list of subnet ids to associtate the service with"
}


variable "enable_service_discovery" {
  default = false
}

variable "registry_arn" {
  default = null
}

variable "service_registry_port" {
  default = 0
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

variable "tg_unhealthy_threshold" {
  default = 5
}

variable "tg_healthy_threshold" {
  default = 5
}

variable "tg_timeout" {
  default = 10
}

variable "tg_protocol_version" {
  default = "HTTP1"
}

variable "tg_interval" {
  default = 30
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

variable "route53_zone_id" {

}

variable "use_latest_image" {
  default = true
}

variable "fqdn" {
  description = "fully qualified domain name for the service to be created"
}

variable "lb_dns_name" {
  description = "load balancer dns name"
}

variable "lb_zone_id" {
  description = "load balancer zone id"
}


#ecs service configurations
variable "ecs_cluster" {

}

variable "compute_info" {
  description = "The cpu and memory requirement for the service"
  default     = ["cpu", "memory"]
}

variable "service_name" {

}

variable "tg_name" {
  default = null
}


variable "task_role_arn" {
  default = null
}

variable "execution_role_arn" {
  default = null
}



variable "create_autoscaling" {
  default = false

}

variable "expose_service" {
  default = true
}

variable "container_commands" {
  default = "[]"
}

variable "container_name" {

}

variable "desired_count" {
  default = 0
}

variable "lb_type" {
  default = "application"
}

variable "load_balancer_arn" {
  default = null

}

variable "security_groups" {
  description = "A list of security group ids to associate the ecs service with"
}



variable "env" {
}

variable "metric_name" {
  description = "The metric name used for auto scaling"
  default     = null
}

variable "scale_up_threshold" {
  description = "A threshold for scaling up number of container"
  default     = 40
}

variable "scale_down_threshold" {
  description = "A threshold for scaling down the number of application"
  default     = 41
}

variable "autoscale_min_capacity" {
  description = "Minimum number of containers in autoscaling group"
  default     = 1
}

variable "autoscale_max_capacity" {
  description = "Maximum number of containers in autoscaling group"
  default     = 4
}

variable "alb_request_count_target_value" {
  description = "number of requests  to scale up or down instances in auto scaling group"
  default     = null
}

variable "disable_scale_in" {
  description = "Allow target tracking to remove capacity from scalable resource"
  default     = false
}

variable "scale_in_cooldown" {
  description = "Period in seconds to wait before removing capacity from scalable resource"
  default     = null
}

variable "scale_out_cooldown" {
  description = "period in seconds to wait before removing capacity from scalable resource"
  default     = null
}

variable "alb_arn_suffix" {
  description = "load balancer arn suffix"
}

variable "add_container_volume" {
  type    = bool
  default = false
}

variable "add_container_volume2" {
  type    = bool
  default = false
}
variable "add_container_volume3" {
  type    = bool
  default = false
}

variable "efs_file_system_id" {
  default = null
}

variable "efs_root_dir" {
  default = null
}

variable "efs_transit_encryption" {
  default = "DISABLED"
}

variable "efs_transit_encryption_port" {
  default = null
}

variable "efs_volume_name" {
  default = null
}


variable "namespace_id" {

}



variable "container_definitions" {
  type = map(object({
    image       = string
    port        = number
    command     = list(string)
    environment = list(map(string))
    secret      = list(map(string))
    mount_path  = string
    volumename  = string
    proctocol   = string
    essential   = string
    # mount_path2 = string
    # volumename2 = string
    # mount_path3 = string
    # volumename3 = string
  }))
}




variable "nlb_port" {

}


