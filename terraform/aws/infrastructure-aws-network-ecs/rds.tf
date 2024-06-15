

resource "aws_security_group" "mysql" {
  name   = "${var.name}-${var.env}-mysql-sg"
  vpc_id = module.network.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["100.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["100.10.0.0/16"]
  }

}

module "mysql_db1" {
  source                      = "./modules/rds_instance"
  db_identifier               = "${var.name}-${var.env}-mysql"
  env                         = var.env
  db_engine                   = "mysql"
  db_engine_version           = var.mysql_db_engine_version
  allocated_storage           = var.rds_allocated_storage
  admin_username              = "root"
  admin_password              = null
  storage_encrypted           = false
  storage_type                = var.rds_storage_type
  db_security_group_id        = aws_security_group.mysql.id
  publicly_accessible         = false
  apply_immediately           = true
  db_port                     = 3306
  allow_major_version_upgrade = true
  subnet_ids                  = local.private_subnet_ids
  db_name                     = var.db_name
  multi_az                    = var.use_multi_az
  max_allocated_storage       = var.rds_mysql_max_allocated_storage
  instance_class              = var.rds_instance_class
}
