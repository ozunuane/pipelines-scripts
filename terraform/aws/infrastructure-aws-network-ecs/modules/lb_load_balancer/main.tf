module "lb_security_group" {
  count  = var.load_balancer_type == "application" && var.security_group == "default" ? 1 : 0
  source = "../security_group"
  vpc_id = var.vpc_id
  # service_name = "${var.env}-${var.name}-lb-sg"
  env         = var.env
  description = var.lb_sg_description
  name        = "${var.env}-${var.name}-${var.expose_type}-sg"
  rules       = var.rules
}




resource "aws_lb" "lb" {
  count                      = var.load_balancer_type == "application" ? 1 : 0
  name                       = "${var.env}-${var.name}-${var.expose_type}lb"
  internal                   = var.internal
  load_balancer_type         = "application"
  drop_invalid_header_fields = true
  security_groups            = var.security_group == "default" ? [module.lb_security_group[0].id] : [var.security_group]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_lb" "nlb" {
  count                      = var.load_balancer_type == "network" ? 1 : 0
  name                       = "${var.env}-${var.name}-lb"
  internal                   = var.internal
  load_balancer_type         = "network"
  subnets                    = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Environment = "${var.env}"
  }
}



resource "aws_lb_listener" "lb_listener" {
  count             = var.create_http_listener && var.load_balancer_type == "application" ? 1 : 0
  load_balancer_arn = aws_lb.lb[0].arn
  port              = "80"
  protocol          = "HTTP"
  tags = {
    "Environment" = "${var.env}"
  }

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}




resource "aws_lb_listener" "front_end" {
  for_each          = var.load_balancer_type == "application" ? var.listeners : {}
  load_balancer_arn = aws_lb.lb[0].arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.https_default_cert_arn
  tags = {
    "Environment" = "${var.env}"
  }

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "...oops page does not exist"
      status_code  = "404"
    }
  }
}




locals {
  lb_details = {
    lb_dns_name   = try("${aws_lb.lb[0].dns_name}", null)
    lb_zone_id    = try("${aws_lb.lb[0].zone_id}", null)
    listener_arn  = try(values(aws_lb_listener.front_end)[*].arn, null)
    lb_arn_suffix = try("${aws_lb.lb[0].arn_suffix}", null)
    lb_arn        = try("${aws_lb.lb[0].arn}", null)
    lb_name       = try("${aws_lb.lb[0].name}", null)

  }

  nlb_details = {
    lb_dns_name   = try("${aws_lb.nlb[0].dns_name}", null)
    lb_zone_id    = try("${aws_lb.nlb[0].zone_id}", null)
    lb_arn_suffix = try("${aws_lb.nlb[0].arn_suffix}", null)
    lb_arn        = try("${aws_lb.nlb[0].arn}", null)
    lb_arn_suffix = try("${aws_lb.nlb[0].arn_suffix}", null)
    listener_arn  = try("${aws_lb_listener.lb_listener[*].arn_}", null)
    lb_name       = try("${aws_lb.nlb[0].name}", null)

  }
}

resource "aws_lb_listener_certificate" "alb_certs" {
  count           = var.additional_cert == null ? 0 : 1
  listener_arn    = local.lb_details["listener_arn"][0]
  certificate_arn = var.certificate_arn
}

resource "aws_lb_listener_certificate" "nlb_certs" {
  count           = var.additional_cert == null ? 0 : 1
  listener_arn    = local.nlb_details["listener_arn"][0]
  certificate_arn = var.certificate_arn
}