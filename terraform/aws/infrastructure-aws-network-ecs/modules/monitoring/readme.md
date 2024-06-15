# ECS Events Monitoring Module

This Terraform module sets up CloudWatch logging and monitoring for ECS events. It includes CloudWatch log groups, EventBridge rules, CloudWatch metric filters, alarms, and SNS topics.

## Usage

```hcl
module "ecs_events" {
  source  = "path_to_this_module"

  log_group_name                 = "ecs"
  log_group_retention_in_days    = 7
  event_rule_name                = "ecs-events"
  event_rule_description         = "Capture all ECS events"
  cluster_arn                    = "arn:aws:ecs:us-east-1:123456789012:cluster/cluster-name"
  alarm_name                     = "ECS service is stopped with error"
  alarm_description              = "crashes occurred"
  service_name                   = "our-ecs-service"
  env                            = "prod"
  aws_region                     = "us-east-1"
}
