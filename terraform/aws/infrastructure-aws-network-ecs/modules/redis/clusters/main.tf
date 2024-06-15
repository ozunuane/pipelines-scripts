resource "aws_elasticache_parameter_group" "redis_pg" {
  count  = var.create_parameter_group ? 1 : 0
  name   = var.parameter_group_name
  family = var.pg_family
}

resource "aws_elasticache_subnet_group" "sub_group" {
  count      = var.create_subnet_group ? 1 : 0
  name       = "${var.name}-${var.env}-subnet-group"
  subnet_ids = var.subnets
}

resource "aws_cloudwatch_log_group" "redis_logs" {
  name = "${var.name}-${var.env}-redis-cluster"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id = var.replication_group_id
  description          = "${var.env}-${var.service}-replication-group"
  engine               = "redis"
  node_type            = var.node_size
  num_node_groups      = var.num_node_groups
  parameter_group_name = var.create_parameter_group ? aws_elasticache_parameter_group.redis_pg[0].name : var.parameter_group
  subnet_group_name    = var.create_subnet_group ? aws_elasticache_subnet_group.sub_group[0].name : var.subnet_group_name
  security_group_ids   = [var.security_group_ids]
  engine_version       = var.cache_engine_verision
  port                 = var.port
  apply_immediately    = true
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis_logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }
}
