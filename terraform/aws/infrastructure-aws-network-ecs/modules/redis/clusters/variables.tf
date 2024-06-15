variable "pg_family" {
  description = "The family of the ElastiCache parameter group. Current valid value include redis3.2, redis4.0, redis5.0, redis6.x and redis7"
  default     = "redis6.x"
}

variable "port" {
  description = " The port number on which each of the cache nodes will accept connections."
  default     = "6379"
}

variable "security_group_ids" {
  description = "LIST of VPC security groups associated with the cache cluster"
}

variable "cache_engine_verision" {
  description = "Version number of the cache engine to be used"
  default     = "6.2"
}

variable "subnet_group_name" {
  description = "Name of the subnet group to be used for the cache cluster"
  default     = null
}

variable "num_node_groups" {
  description = "Number of node groups (shards) for this Redis replication group"
  default     = 1
}

variable "node_size" {
  description = "The instance class used."
}

variable "subnets" {
  description = "subnet(s) to include in redis subnet group"
}

variable "env" {
  description = "the service environment"
}

variable "service" {
  description = "Service this redis cluster is associated with"
}

variable "create_parameter_group" {
  description = "a boolean variable, set to true if you want the module to create new parameter group"
  default     = true
}

variable "create_subnet_group" {
  default = true
}

variable "parameter_group" {
  default = null
}

variable "replication_group_id" {
}

variable "parameter_group_name" {
}

variable "name" {

}