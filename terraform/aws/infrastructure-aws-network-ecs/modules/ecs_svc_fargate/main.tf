data "aws_region" "current" {}

# data "aws_ecs_container_definition" "ecs" {
#   task_definition = aws_ecs_task_definition.task_definition.id
#   container_name  = local.container_info[0].container_name
#   depends_on = [
#     aws_ecs_task_definition.task_definition
#   ]
# }

#create default task execution role
resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "${var.env}-${var.service_name}ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json

  inline_policy {
    name   = "allow-registry-access"
    policy = data.aws_iam_policy_document.inline_policy.json

  }

}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions   = ["*", ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

locals {
  container_info = flatten([
    for service_name, container_details in var.container_definitions : [
      {
        container_def = <<TASK_DEFINITION
        

  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${service_name}",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-create-group": "true",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [

        %{if container_details["port"] != 0~}
        {"hostPort": ${container_details["port"]},
        "containerPort": ${container_details["port"]},
        "protocol":"tcp"}
        %{~endif}
      
    ],
    "command": [ ${join(", ", [for command in container_details["command"] : format("%q", command)])} ],
    "environment": ${jsonencode(container_details["environment"])},
    "secrets": ${jsonencode(container_details["secret"])},
    "mountPoints": [
              %{if var.add_container_volume}
              {
          "containerPath": ${jsonencode(container_details["mount_path"])},
          "sourceVolume": ${jsonencode(container_details["volumename"])}
        }
        %{~endif}
        %{if var.add_container_volume2}
        ,{
          "containerPath": ${jsonencode(container_details["mount_path2"])},
          "sourceVolume": ${jsonencode(container_details["volumename2"])}
        }
        %{~endif}
        %{if var.add_container_volume3}
        ,{
          "containerPath": ${jsonencode(container_details["mount_path3"])},
          "sourceVolume": ${jsonencode(container_details["volumename3"])}
        }
        %{~endif}
    ],
    "essential": true,
    "cpu": 0,
    "volumesFrom": [],
    "image": "${container_details["image"]}",
    "name": "${service_name}"
  }
TASK_DEFINITION
      }
    ]
  ])

  containers = "[${join(",", [for k, v in local.container_info : "${v.container_def}"])}]"
  depends_on = [
    #data.aws_ecs_container_definition.ecs,
    aws_ecs_task_definition.task_definition
  ]
}

# resource "local_file" "private_key" {
#     content  = local.container_image
#     filename = "private_key.pem"
# }

resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.service_name
  task_role_arn            = var.task_role_arn == null ? aws_iam_role.ecs_tasks_execution_role.arn : var.task_role_arn
  execution_role_arn       = var.execution_role_arn == null ? aws_iam_role.ecs_tasks_execution_role.arn : var.execution_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.compute_info[0]
  memory                   = var.compute_info[1]
  container_definitions    = local.containers

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  dynamic "volume" {
    for_each = var.add_container_volume ? [1] : []
    content {
      name = var.efs_volume_name
      efs_volume_configuration {
        file_system_id          = var.efs_file_system_id
        root_directory          = var.efs_root_dir
        transit_encryption      = var.efs_transit_encryption
        transit_encryption_port = var.efs_transit_encryption_port
      }
    }
  }
}

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

resource "aws_lb_target_group" "nlb_target_group" {
  count       = var.lb_type == "nlb" ? 1 : 0
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

#get latest task definition revision
data "aws_ecs_task_definition" "task_definition_revision" {
  task_definition = aws_ecs_task_definition.task_definition.family
}


resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = var.ecs_cluster
  task_definition = "${aws_ecs_task_definition.task_definition.family}:${max(aws_ecs_task_definition.task_definition.revision, data.aws_ecs_task_definition.task_definition_revision.revision)}"
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.lb_type == "application" ? aws_lb_target_group.target_group[0].arn : aws_lb_target_group.nlb_target_group[0].arn
    container_name   = var.service_name
    container_port   = var.container_port
  }
  depends_on = [
    aws_lb_target_group.target_group,
    aws_ecs_task_definition.task_definition
  ]

  dynamic "service_registries" {
    for_each = var.enable_service_discovery ? [1] : []
    content {
      registry_arn = aws_service_discovery_service.service_discovery[0].arn
      port         = var.service_registry_port
    }
  }

}

resource "aws_service_discovery_service" "service_discovery" {
  count = var.enable_service_discovery ? 1 : 0
  name  = var.service_name
  dns_config {
    namespace_id = var.namespace_id
    dns_records {
      ttl  = 30
      type = "A"
    }
  }
}


##########################   service auto-scaling CPU and Memory       #############################
resource "aws_cloudwatch_metric_alarm" "high" {
  count               = var.create_autoscaling && (var.metric_name == "CPUUtilization" || var.metric_name == "MemoryUtilization") ? 1 : 0
  alarm_name          = "${var.service_name}-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = var.metric_name
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.scale_up_threshold
  dimensions = {
    ClusterName = "${var.ecs_cluster}"
    ServiceName = "${var.service_name}"
  }
  alarm_actions = [aws_appautoscaling_policy.scale_up_policy[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count               = var.create_autoscaling && (var.metric_name == "CPUUtilization" || var.metric_name == "MemoryUtilization") ? 1 : 0
  alarm_name          = "${var.service_name}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = var.metric_name
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.scale_down_threshold
  dimensions = {
    ClusterName = "${var.ecs_cluster}"
    ServiceName = "${var.service_name}"
  }
  alarm_actions = [aws_appautoscaling_policy.scale_down_policy[0].arn]
}

resource "aws_appautoscaling_policy" "scale_up_policy" {
  count              = var.create_autoscaling ? 1 : 0
  name               = "${var.service_name}-scale-up-policy"
  depends_on         = [aws_appautoscaling_target.scale_target]
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down_policy" {
  count              = var.create_autoscaling ? 1 : 0
  name               = "${var.service_name}-scale-down-policy"
  depends_on         = [aws_appautoscaling_target.scale_target]
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_appautoscaling_target" "scale_target" {
  count              = var.create_autoscaling ? 1 : 0
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.autoscale_min_capacity
  max_capacity       = var.autoscale_max_capacity
}



##########################      service auto-scaling ALB request count per target       #############################
resource "aws_appautoscaling_policy" "ecs_policy" {
  count              = var.create_autoscaling && var.metric_name == "ALBRequestCountPerTarget" ? 1 : 0
  name               = var.service_name
  resource_id        = "service/${var.ecs_cluster}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.alb_request_count_target_value
    disable_scale_in   = var.disable_scale_in
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.alb_arn_suffix}/${var.lb_type == "application" ? aws_lb_target_group.target_group[0].arn_suffix : aws_lb_target_group.nlb_target_group[0].arn_suffix}"
    }
  }
}


##########################      Expose service      #############################
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
  lifecycle {
    replace_triggered_by = [aws_lb_target_group.nlb_target_group, aws_lb_target_group.target_group]
  }
}

resource "aws_route53_record" "account_dns" {
  count   = var.expose_service ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.fqdn
  type    = "A"
  depends_on = [
    aws_ecs_service.service
  ]

  alias {
    name                   = "dualstack.${var.lb_dns_name}"
    zone_id                = var.lb_zone_id
    evaluate_target_health = var.route53_evaluate_target_health
  }
}








locals {
  cluster_aws_ecs_service = aws_ecs_service.service.cluster
  ecs_service_name        = aws_ecs_service.service.name
}

# Provisioner to force a new deployment by updating the desired count
resource "null_resource" "force_redeploy" {
  triggers = {
    task_definition = aws_ecs_task_definition.task_definition.revision
  }

  provisioner "local-exec" {
    command = <<EOT
      aws ecs update-service --cluster ${local.cluster_aws_ecs_service} --service ${local.ecs_service_name} --force-new-deployment
    EOT
  }
}