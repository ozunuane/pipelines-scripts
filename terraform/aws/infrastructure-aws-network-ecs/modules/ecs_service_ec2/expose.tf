
resource "aws_lb_target_group" "target_group" {
  count            = var.lb_type == "application" ? 1 : 0
  name             = var.tg_name == null ? var.service_name : var.tg_name
  port             = var.tg_port
  protocol         = var.tg_protocol
  target_type      = var.tg_target_type
  protocol_version = var.tg_protocol_version
  vpc_id           = var.vpc_id
  health_check {
    path                = var.health_check_path
    healthy_threshold   = var.tg_healthy_threshold
    unhealthy_threshold = var.tg_unhealthy_threshold
    timeout             = var.tg_timeout
    interval            = var.tg_interval
    matcher             = var.health_check_success_codes
  }
}
# resource "random_id" "suffix" {
#   keepers = {
#     protocol    = local.tg_protocol
#     target_type = local.tg_target_type
#     port        = local.container_port
#     vpc_id      = var.vpc_id
#   }

#   byte_length = 2
# }


# resource "aws_lb_target_group" "foo" {
#   name        = "${var.environment}-foo-${random_id.suffix.hex}"
#   port        = local.container_port
#   protocol    = local.tg_protocol
#   target_type = local.tg_target_type
#   vpc_id      = var.vpc_id
#   health_check {
#     path = "/health"
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }


resource "aws_lb_target_group" "nlb_target_group" {
  count       = var.lb_type == "network" ? 1 : 0
  name        = var.tg_name == null ? var.service_name : var.tg_name
  port        = var.tg_port
  protocol    = var.tg_protocol
  target_type = var.tg_target_type
  vpc_id      = var.vpc_id
  health_check {
    healthy_threshold   = var.tg_healthy_threshold
    unhealthy_threshold = var.tg_unhealthy_threshold
    timeout             = var.tg_timeout
    interval            = var.tg_interval
    protocol            = var.tg_protocol
  }


}













########################## Expose service  #############################
resource "aws_lb_listener_rule" "account_rule" {
  count        = var.expose_service && var.lb_type == "application" ? 1 : 0
  listener_arn = var.listener_arn

  action {
    type             = "forward"
    target_group_arn = var.lb_type == "application" ? aws_lb_target_group.target_group[0].arn : aws_lb_target_group.nlb_target_group[0].arn
  }

  condition {
    host_header {
      values = ["${var.fqdn}"]
    }
  }
  # lifecycle {
  #   replace_triggered_by = [aws_lb_target_group.nlb_target_group, aws_lb_target_group.target_group]
  # }
}

resource "aws_lb_listener" "nlb_listener" {
  count             = var.expose_service && var.lb_type == "nlb" ? 1 : 0
  load_balancer_arn = var.load_balancer_arn
  port              = "7233"
  protocol          = "TCP"
  tags = {
    "Environment" = "${var.env}"
  }

  default_action {
    type             = "forward"
    target_group_arn = var.lb_type == "application" ? aws_lb_target_group.target_group[0].arn : aws_lb_target_group.nlb_target_group[0].arn
  }
}


##### ADD DOMAIN TO RECORDS ########
resource "aws_route53_record" "account_dns" {
  count   = var.expose_service ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.fqdn
  type    = "A"
  depends_on = [
    module.ecs_service
  ]

  alias {
    name                   = "dualstack.${var.env}-${var.lb_dns_name}"
    zone_id                = var.lb_zone_id
    evaluate_target_health = var.route53_evaluate_target_health
  }
}