variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: ddd:hh24:mi-ddd:hh24:mi. Eg: Mon:00:00-Mon:03:00"
  default     = "Sun:00:00-Sun:03:00"
}

variable "db_engine" {
  description = "The database engine to use"
}

variable "db_engine_version" {
  description = "The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10)"
  default     = "8.0.28"
}

variable "instance_class" {
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes"
  default     = 20
}

variable "storage_type" {
  description = "One of $standard (magnetic), $gp2 (general purpose SSD), $gp3 (general purpose SSD that needs iops independently) or $io1 (provisioned IOPS SSD)"
  default     = "io1"
}

variable "db_name" {
  description = " The name of the database to create when the DB instance is created. If this parameter is not specified, no database is created in the DB instance."
}

variable "admin_password" {
  description = "Password for the master DB user"
  default     = "default"
}

variable "admin_username" {
  description = "Username for the master DB user"
}

variable "db_port" {
}

variable "db_security_group_id" {
  description = "List of VPC security groups to associate"
}

# variable "db_subnet_group_name" {

# }

# variable "parameter_group_name" {
#   default = "default"
# }

variable "option_group_name" {
  default = "default"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
}

variable "publicly_accessible" {
  default = false
}

variable "allow_major_version_upgrade" {
  default = false
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "apply_immediately" {
  default = false
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot"
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Instance tags to snapshots"
  default     = true
}

variable "performance_insights_enabled" {
  default = false
}

variable "backup_retention_period" {
  default = 7
}

variable "max_allocated_storage" {
}

# variable "enabled_cloudwatch_logs_exports" {
#   default = ["audit", "error", "general", "slowquery"]
# }

# variable "enabled_cloudwatch_logs_exports" {
#   default = ["audit", "alert", "listener", "trace"]
# }

# variable "service_name" {
#   description = "name of the service the db will be hosting"
# }

variable "default_db_name" {
  default = "init_db"
}

variable "env" {
}

variable "db_identifier" {
  default = null
}

variable "storage_encrypted" {
  default = true
}

variable "skip_final_snapshot" {
  default = true
}

variable "create_random_password" {
  default = false
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}