output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_events.arn
}

output "cloudwatch_event_rule_arn" {
  description = "ARN of the CloudWatch event rule"
  value       = aws_cloudwatch_event_rule.ecs_events.arn
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.monitoring.arn
}

output "iam_role_arn" {
  description = "ARN of the IAM role for SNS delivery status"
  value       = aws_iam_role.sns_delivery_status.arn
}
