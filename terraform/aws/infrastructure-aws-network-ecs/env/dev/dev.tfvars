####### VPC #######
environment = "dev"
name        = "fortnoto"
vpc_cidr    = "100.10.0.0/16"
region      = "us-east-1"



#### DNS ###
# hosted_zone1 = "ozi-test.com.ng"

#### CERTS - DOMAINS #### 

########  PUBLIC SUBNETS  #########
public_subnets = {
  public_subnet = {
    subnets = ["100.10.2.0/24", "100.10.4.0/24"]
  }
}


########  PRIVATE SUBNETS  #########
private_subnets = {
  private_subnets = {
    subnets = ["100.10.1.0/24",

      "100.10.3.0/24",

      "100.10.7.0/24"
    ]
  }
}


####### ECS SERVICES MEMORY AND CPU SPECS ######
####[CPU, MEMORY]#######
# backend_compute_info = [256, 512]



#### EC2 BASTION / CLOUDFLARE  ####
bastion_volume_size   = 30
bastion_volume_type   = "gp2"
bastion_instance_type = "t2.micro"
bastion_key_name      = "dev-key-pair"
ec2_template_key_name = "dev-key-pair"

#### ECS INSTANCE TEMPLATE #####
ecs_instance_type = "t2.micro"
ecs_volume_size   = 30
ecs_volume_type   = "gp2"


####### ECS AUTO SCALING PARAMETERS ###
maximum_scaling_step_size = 5
minimum_scaling_step_size = 1
target_capacity           = 60

####### ECR REPO ......  #######
ecr_repo_url = "851725540862.dkr.ecr.us-east-1.amazonaws.com"


ecr_repo = {
  "fortnoto-dev-repo" = {
    image_tag_mutability     = true
    image_scan_on_push       = true
    encryption_type          = "AES256"
    attach_repository_policy = false
    create_lifecycle_policy  = false
    lifecycle_policy = {
      countNumber   = 90
      tagStatus     = "any"
      tagPrefixList = "test"
      countType     = "imageCountMoreThan"
    }
  }
}



env = "dev"

###### Mysql rds database ######
mysql_db_engine_version = "8.0.36"
rds_instance_class      = "db.t3.micro"
rds_storage_type        = "gp2"
db_name                 = "fortnoto-dev-user"
use_multi_az            = false
rds_allocated_storage   = 20

##### AUTOSCALE RDS STORAGE ####
rds_mysql_max_allocated_storage = 1000



#### REDIS SPECS ####

#Number of node groups (shards) for this Redis replication group
redis_num_node_groups = 0
#description = "The instance class used
redis_node_size = "Cache.t2.micro"
#The family of the ElastiCache parameter group. Current valid value include redis3.2, redis4.0, redis5.0, redis6.x and redis7"
redis_pg_family = "redis7"
#Version number of the cache engine to be used"
cache_engine_verision = 7.1





###########  SECURITY GROUP RULES ###############



### ECS SERVICE SECURITY GROUP #####
ecs_service_rules = {
  # "Allow http traffic from internet" = {
  #   from_port          = 80
  #   to_port            = 80
  #   protocol           = "tcp"
  #   allowed_cidr_block = "100.0.0.0/16"
  # },
  # "Allow https traffic from internet" = {
  #   from_port          = 443
  #   to_port            = 443
  #   protocol           = "tcp"
  #   allowed_cidr_block = "100.0.0.0/0"
  # },
  # "Allow traffic from rds-mysqldb" = {
  #   from_port          = 3306
  #   to_port            = 3306
  #   protocol           = "tcp"
  #   allowed_cidr_block = "100.0.0.0/16"
  # },
  "Allow ALL Connections from Vpc cidr" = {
    from_port          = 0
    to_port            = 0
    protocol           = "-1"
    allowed_cidr_block = "100.10.0.0/16"
  }
}




##### BASTION SECURITY GROUP #####
ec2_bastion_rules = {

  "Allow SSH Connections into bastion/cloudflare from anywhere" = {
    from_port          = 22
    to_port            = 22
    protocol           = "tcp"
    allowed_cidr_block = "0.0.0.0/0"
  }
}



redis_cluster_rules = {

  "Allow SSH Connections into bastion/cloudflare from anywhere" = {
    from_port          = 22
    to_port            = 22
    protocol           = "tcp"
    allowed_cidr_block = "100.10.0.0/16"
  }
}





########### RULE TO EXPOSE SERVICE TO WEB ALB RULE ##############
web_alb_expose_external_rules = {

  "Allow SSH Connections into bastion/cloudflare from anywhere" = {
    from_port          = 80
    to_port            = 80
    protocol           = "tcp"
    allowed_cidr_block = "0.0.0.0/0"
  }
  "Allow SSH Connections into bastion/cloudflare from anywhere" = {
    from_port          = 443
    to_port            = 443
    protocol           = "tcp"
    allowed_cidr_block = "0.0.0.0/0"
  }
}




########### INTERNAL NETWORKS INBOUND ONLY ##############
internal_netwok_only_rules = {

  "Allow connections from anywhere within vpc cidr range" = {
    from_port          = 0
    to_port            = 0
    protocol           = -1
    allowed_cidr_block = "100.10.0.0/16"

  }
}



