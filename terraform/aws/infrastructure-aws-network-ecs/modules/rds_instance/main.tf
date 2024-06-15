resource "aws_db_parameter_group" "parameter_group_mysql_8" {
  name        = "${var.env}-parameter-group-mysql-8"
  description = "${var.env}-parameter-group-mysql-8"
  family      = "mysql8.0"
  tags = {
    "Environment" = "${var.env}"
  }
}

resource "aws_db_subnet_group" "private_subnet_group" {
  name        = "${var.env}-private-subnet-group"
  description = "${var.env}-private-subnet-group"
  subnet_ids  = var.subnet_ids
  tags = {
    "Environment" = "${var.env}"
  }
}

resource "aws_db_option_group" "option_group_mysql_8" {
  name                     = "${var.env}-option-group-mysql-8"
  option_group_description = "${var.env}-option-group-mysql-8"
  engine_name              = "mysql"
  major_engine_version     = "8.0"
  tags = {
    "Environment" = "${var.env}"
  }
}



resource "random_password" "db_password" {
  length  = 32
  special = false
}


resource "aws_ssm_parameter" "database_password" {
  name  = "/software/mysql/${var.env}/${var.db_name}/database-password"
  value = random_password.db_password.result
  type  = "SecureString"

}


resource "aws_db_instance" "db_instance" {
  identifier        = var.db_identifier == null ? "${var.db_name}-${var.env}-db" : var.db_identifier
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  db_name           = var.default_db_name
  username          = var.admin_username
  # password               = var.admin_password == "default" ? random_password.db_password[0].result : var.admin_password
  password               = random_password.db_password.result
  port                   = var.db_port
  vpc_security_group_ids = [var.db_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name
  parameter_group_name   = aws_db_parameter_group.parameter_group_mysql_8.name
  option_group_name      = aws_db_option_group.option_group_mysql_8.name
  skip_final_snapshot    = var.skip_final_snapshot
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  snapshot_identifier   = var.snapshot_identifier
  copy_tags_to_snapshot = var.copy_tags_to_snapshot

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? 100 : null

  backup_retention_period = var.backup_retention_period
  max_allocated_storage   = var.max_allocated_storage


  # enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection = false
}