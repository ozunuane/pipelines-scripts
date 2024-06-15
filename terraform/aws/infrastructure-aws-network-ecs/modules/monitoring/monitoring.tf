resource "aws_cloudwatch_log_group" "ecs_events" {
  name              = "/aws/events/${var.log_group_name}"
  retention_in_days = var.log_group_retention_in_days
}

resource "aws_cloudwatch_event_rule" "ecs_events" {
  name        = var.event_rule_name
  description = var.event_rule_description

  event_pattern = jsonencode({
    "source" : ["aws.ecs"],
    "detail" : {
      "clusterArn" : [var.cluster_arn]
    }
  })
}

resource "aws_cloudwatch_event_target" "logs" {
  rule      = aws_cloudwatch_event_rule.ecs_events.name
  target_id = "send-to-cloudwatch"
  arn       = aws_cloudwatch_log_group.ecs_events.arn
}

resource "aws_cloudwatch_log_metric_filter" "ecs_errors" {
  name           = "ECS Errors"
  pattern        = <<PATTERN
{
  ($.detail.group = "*" && $.detail.stopCode = "TaskFailedToStart") ||
  ($.detail-type = "ECS Service Action" && ($.detail.eventName = "SERVICE_DEPLOYMENT_FAILED" || $.detail.eventName = "SERVICE_TASK_PLACEMENT_FAILURE" || $.detail.eventName = "SERVICE_STEADY_STATE_TIMEOUT")) ||
  ($.detail-type = "ECS Task State Change" && ($.detail.stoppedReason = "OutOfMemoryError" || $.detail.stoppedReason = "EssentialContainerExited" || $.detail.stoppedReason != "" || $.detail.stopCode = "TaskFailed"))
}
PATTERN
  log_group_name = aws_cloudwatch_log_group.ecs_events.name

  metric_transformation {
    name      = "ECSErrors"
    namespace = "ECSEvents"
    value     = "1"
    unit      = "Count"
    dimensions = {
      group = "$.detail.group"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "service_crashes" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ECSErrors"
  namespace           = "ECSEvents"
  period              = "300"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = var.alarm_description
  alarm_actions       = [aws_sns_topic.monitoring.arn]
  ok_actions          = [aws_sns_topic.monitoring.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    group = "service:${var.service_name}"
  }
}

resource "aws_sns_topic" "monitoring" {
  name                                = "monitoring"
  lambda_success_feedback_role_arn    = aws_iam_role.sns_delivery_status.arn
  lambda_failure_feedback_role_arn    = aws_iam_role.sns_delivery_status.arn
  lambda_success_feedback_sample_rate = 100

  tags = {
    environment = var.env
  }
}

resource "aws_iam_role" "sns_delivery_status" {
  name = "sns-delivery-status"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "sns.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "sns_delivery_status" {
  name = "sns-delivery-status"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:PutMetricFilter",
          "logs:PutRetentionPolicy"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "sns_delivery_status" {
  name       = "sns-delivery-status"
  roles      = [aws_iam_role.sns_delivery_status.name]
  policy_arn = aws_iam_policy.sns_delivery_status.arn
}
