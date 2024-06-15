################### REDIS ############################

resource "aws_elasticache_subnet_group" "sub_group" {
  name       = "${var.env}-${var.name}-redis-spg}"
  subnet_ids = [var.private_subnets]
}





module "cluster" {
  source               = "./clusters"
  subnets              = var.private_subnets
  security_group_ids   = var.redis_security_group_ids
  replication_group_id = "${var.name}-${var.env}-server"
  subnet_group_name    = aws_elasticache_subnet_group.sub_group.name
  create_subnet_group  = false
  parameter_group_name = "${var.env}-parameter-group"
  env                  = var.env
  service              = "redis-${var.env}-${var.name}"
  node_size            = var.redis_node_size
  name                 = var.name
}

