
variable "create_https_lister" {
  default = true
}

variable "listeners" {
  type = map(any)
  default = {
    listener1 = {
      port     = "443"
      protocol = "HTTPS"
    }
  }
}

variable "name" {

}

variable "internal" {
  default = false
}

variable "https_default_cert_arn" {
  default = null
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "vpc_id" {

}

variable "env" {
}

# variable "service_cluster" {

# }

variable "subnet_ids" {

}

variable "create_http_listener" {
  default = true
}

variable "lb_sg_description" {
  default = "Allow public web traffic on HTTP/HTTPS to ECS Dev Frontend Web App"
}

variable "load_balancer_type" {
  default = "application"
}

variable "security_group" {
  default = "default"
}

variable "additional_cert" {
  default = null
}

variable "certificate_arn" {
  default = null
}

variable "expose_type" {

}


variable "rules" {
  type = map(object({
    from_port          = number
    to_port            = number
    protocol           = string
    allowed_cidr_block = string
  }))
  default = {}
}


