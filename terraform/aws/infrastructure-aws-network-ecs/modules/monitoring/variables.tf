variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
  default     = "ecs"
}

variable "log_group_retention_in_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 7
}

variable "event_rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
  default     = "ecs-events"
}

variable "event_rule_description" {
  description = "Description of the EventBridge rule"
  type        = string
  default     = "Capture all ECS events"
}

variable "cluster_arn" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "alarm_name" {
  description = "Name of the CloudWatch alarm"
  type        = string
}

variable "alarm_description" {
  description = "Description of the CloudWatch alarm"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}
