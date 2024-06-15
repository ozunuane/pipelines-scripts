variable "environment" {

}

variable "name" {

}



# variable "lb_name" {

# }

# variable "db_identifier" {

# }



variable "env" {

}



variable "vpc_cidr" {

}
variable "db_name" {

}

variable "public_subnets" {
  type = map(object({
    subnets = list(string)
  }))
}

variable "private_subnets" {
  type = map(object({
    subnets = list(string)
  }))
}

variable "private_routes" {
  type = map(any)
  default = {
    route1 = {
      "route" = ["0.0.0.0/0", "nat_gw"]
    }
    # route2 = {
    #   "route" = ["10.0.0.0/16", "vpc_peering_connection"]
    # }
    # route2 = {
    #   "route" = ["192.168.156.0/24", "network_interface"]
    # }
  }
}

variable "public_routes" {
  type = map(any)
  default = {
    route1 = {
      "route" = ["0.0.0.0/0", "internet_gw"]
    }
    # route2 = {
    #   "route" = ["10.0.0.0/16", "vpc_peering_connection"]
    # }
    # route2 = {
    #   "route" = ["192.168.156.27/32", "network_interface"]
    # }
  }
}


##### NACL PRIVATE RULES ###
variable "private_nacl_rules" {
  type = map(any)
  default = {
    rule1 = {
      "rule" = ["allow", "0.0.0.0/0", null, null, "-1", 5000, "egress"]
    }
    rule2 = {
      "rule" = ["allow", "0.0.0.0/0", null, null, "-1", 5000, "ingress"]
    }
  }
}


####### NACL PUBLIC RULES ########
variable "public_nacl_rules" {
  type = map(any)
  default = {
    rule1 = {
      "rule" = ["allow", "0.0.0.0/0", null, null, "-1", 5000, "egress"]
    }
    rule2 = {
      "rule" = ["allow", "0.0.0.0/0", null, null, "-1", 5000, "ingress"]
    }
  }
}



######## ECR DOCKER REPO #######
variable "ecr_repo" {
  type = map(object({
    image_tag_mutability     = bool
    image_scan_on_push       = bool
    encryption_type          = string
    attach_repository_policy = bool
    create_lifecycle_policy  = bool
    lifecycle_policy         = map(string)
  }))
}

variable "ecr_repo_url" {

}

variable "ecs_service_rules" {

}

variable "ecs_instance_type" {

}

variable "ecs_volume_size" {

}

variable "ecs_volume_type" {

}

variable "bastion_volume_size" {
}

variable "bastion_volume_type" {
}

variable "bastion_instance_type" {
}

variable "bastion_key_name" {
}

variable "region" {

}



variable "ec2_bastion_rules" {

}


variable "web_alb_expose_external_rules" {

}
# variable "hosted_zone1" {

# }

# variable "backend_compute_info" {

# }

variable "internal_netwok_only_rules" {

}

variable "rds_storage_type" {

}
variable "rds_allocated_storage" {

}


variable "cache_engine_verision" {

}

variable "redis_node_size" {

}

variable "redis_num_node_groups" {

}

variable "redis_pg_family" {

}

variable "mysql_db_engine_version" {

}

variable "use_multi_az" {

}
variable "rds_mysql_max_allocated_storage" {

}

variable "rds_instance_class" {

}

variable "ec2_template_key_name" {

}

variable "maximum_scaling_step_size" {

}


variable "minimum_scaling_step_size" {

}
variable "target_capacity" {

}

variable "redis_cluster_rules" {

}